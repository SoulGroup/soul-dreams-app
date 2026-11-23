# The trial's serving code against stand-ins, one case per run:
# python3 -I -B trial_inference_cases.py <case>. Exit 0 when it holds.
# The prompt is invented scenery.
import io
import json
import os
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, 'trial-stubs'))
sys.path.insert(0, os.path.join(HERE, '..', 'trial', 'code'))

import inference  # noqa: E402
import torch  # noqa: E402

PROMPT = 'a quiet harbour at dusk'


def body(**changes):
    data = {'inputs': PROMPT, 'parameters': {'num_inference_steps': 4, 'seed': 7}}
    data.update(changes)
    return json.dumps(data)


def refused(code, fn, *args):
    try:
        fn(*args)
    except ValueError as e:
        assert str(e) == code, str(e)
        assert PROMPT not in str(e)
        return
    raise AssertionError('not refused')


def case_full_precision():
    os.environ.pop('TRIAL_EIGHT_BIT', None)
    inference.model_fn('/opt/ml/model')
    assert torch.calls == [('pipeline', '/opt/ml/model', {'torch_dtype': 'bfloat16', 'device_map': 'cuda'})]


def case_request():
    got = inference.input_fn(body(parameters={
        'num_inference_steps': 4, 'guidance_scale': 0.0, 'height': 1024, 'width': 1024,
        'max_sequence_length': 256, 'seed': 7}), 'application/json')
    assert got == (PROMPT, {'num_inference_steps': 4, 'guidance_scale': 0.0, 'height': 1024, 'width': 1024,
                            'max_sequence_length': 256}, 7)
    assert inference.input_fn(json.dumps({'inputs': PROMPT}), 'application/json') == (PROMPT, {}, 0)


def case_refusals():
    refused('trial-content-type', inference.input_fn, body(), 'text/plain')
    refused('trial-request', inference.input_fn, '{', 'application/json')
    refused('trial-request', inference.input_fn, '[]', 'application/json')
    refused('trial-request', inference.input_fn, body(inputs=''), 'application/json')
    refused('trial-request', inference.input_fn, body(inputs=3), 'application/json')
    refused('trial-request', inference.input_fn, body(parameters=[]), 'application/json')
    refused('trial-setting', inference.input_fn, body(parameters={'negative_prompt': PROMPT}), 'application/json')
    refused('trial-seed', inference.input_fn, body(parameters={'seed': -1}), 'application/json')
    refused('trial-seed', inference.input_fn, body(parameters={'seed': True}), 'application/json')
    refused('trial-seed', inference.input_fn, body(parameters={'seed': 1.5}), 'application/json')
    refused('trial-accept', inference.output_fn, None, 'application/json')


def case_seeded_on_the_gpu():
    pipe = inference.model_fn('/opt/ml/model')
    torch.calls.clear()
    image = inference.predict_fn((PROMPT, {'num_inference_steps': 4}, 7), pipe)
    assert torch.calls[:2] == [('generator', 'cuda'), ('seed', 7)]
    call = torch.calls[2]
    assert call[0] == 'call' and call[1] == PROMPT
    assert call[2]['num_inference_steps'] == 4 and set(call[2]) == {'num_inference_steps', 'generator'}
    assert inference.output_fn(image, 'image/png') == b'\x89PNG stand-in'
    assert torch.calls[-1] == ('save', 'PNG')


def case_eight_bit():
    ran = []
    inference.subprocess.run = lambda args, check: ran.append((args, check))
    os.environ['TRIAL_EIGHT_BIT'] = 'yes'
    with tempfile.TemporaryDirectory() as model_dir:
        try:
            inference.model_fn(model_dir)
        except RuntimeError as e:
            assert str(e) == 'trial-wheel'
        else:
            raise AssertionError('no wheel, yet loaded')
        assert ran == [] and torch.calls == []
        wheels = os.path.join(model_dir, 'code', 'wheels')
        os.makedirs(wheels)
        wheel = os.path.join(wheels, 'bitsandbytes-0.50.2-py3-none-manylinux_2_24_x86_64.whl')
        io.open(wheel, 'wb').close()
        inference.model_fn(model_dir)
    assert ran == [([sys.executable, '-m', 'pip', 'install', '--no-index', '--no-deps', '--quiet', wheel], True)]
    assert torch.calls == [
        ('transformer', 'transformer', 8),
        ('encoder', 'text_encoder_2', 8),
        ('flux', model_dir, ['text_encoder_2', 'torch_dtype', 'transformer']),
        ('to', 'cuda'),
    ]


if __name__ == '__main__':
    globals()['case_' + sys.argv[1]]()
