# The image trial's serving code (D135, D136), run by the Hugging Face
# inference toolkit inside AWS's container, from the weights' folder
# (code/inference.py). It writes nothing anywhere: a refusal raises a
# code, never the request's words (R3). The toolkit logs only timings.
import glob
import io
import json
import os
import subprocess
import sys

import torch

# What a request may set, besides the seed.
SETTINGS = ('num_inference_steps', 'guidance_scale', 'height', 'width', 'max_sequence_length')
# D136's fallback, pinned: its wheel sits in code/wheels/ beside this file.
EIGHT_BIT_WHEEL = 'bitsandbytes-0.50.2-py3-none-manylinux_2_24_x86_64.whl'


def model_fn(model_dir):
    if os.environ.get('TRIAL_EIGHT_BIT') == 'yes':
        return _eight_bit(model_dir)
    from diffusers import DiffusionPipeline
    # Straight onto the GPU: FLUX in full precision is larger than the
    # instance's memory (32 GiB on g6e.xlarge).
    return DiffusionPipeline.from_pretrained(model_dir, torch_dtype=torch.bfloat16, device_map='cuda')


def _eight_bit(model_dir):
    wheels = glob.glob(os.path.join(model_dir, 'code', 'wheels', EIGHT_BIT_WHEEL))
    if len(wheels) != 1:
        raise RuntimeError('trial-wheel')
    # From the file alone: the endpoint has no network.
    subprocess.run([sys.executable, '-m', 'pip', 'install', '--no-index', '--no-deps', '--quiet', wheels[0]],
                   check=True)
    from diffusers import BitsAndBytesConfig as DiffusersEightBit
    from diffusers import FluxPipeline, FluxTransformer2DModel
    from transformers import BitsAndBytesConfig as TransformersEightBit
    from transformers import T5EncoderModel
    transformer = FluxTransformer2DModel.from_pretrained(
        model_dir, subfolder='transformer', torch_dtype=torch.bfloat16,
        quantization_config=DiffusersEightBit(load_in_8bit=True))
    text_encoder_2 = T5EncoderModel.from_pretrained(
        model_dir, subfolder='text_encoder_2', dtype=torch.bfloat16,
        quantization_config=TransformersEightBit(load_in_8bit=True))
    pipe = FluxPipeline.from_pretrained(model_dir, transformer=transformer, text_encoder_2=text_encoder_2,
                                        torch_dtype=torch.bfloat16)
    return pipe.to('cuda')


def input_fn(input_data, content_type):
    if content_type != 'application/json':
        raise ValueError('trial-content-type')
    try:
        data = json.loads(input_data)
    except ValueError:
        raise ValueError('trial-request') from None
    if not isinstance(data, dict):
        raise ValueError('trial-request')
    prompt = data.get('inputs')
    settings = data.get('parameters', {})
    if not isinstance(prompt, str) or prompt == '' or not isinstance(settings, dict):
        raise ValueError('trial-request')
    if not set(settings) <= set(SETTINGS) | {'seed'}:
        raise ValueError('trial-setting')
    seed = settings.get('seed', 0)
    if not isinstance(seed, int) or isinstance(seed, bool) or seed < 0:
        raise ValueError('trial-seed')
    return prompt, {k: settings[k] for k in SETTINGS if k in settings}, seed


def predict_fn(data, model):
    prompt, settings, seed = data
    generator = torch.Generator(device='cuda').manual_seed(seed)
    return model(prompt, generator=generator, **settings).images[0]


def output_fn(prediction, accept):
    if accept != 'image/png':
        raise ValueError('trial-accept')
    out = io.BytesIO()
    prediction.save(out, format='PNG')
    return out.getvalue()
