# A stand-in for diffusers in the trial's serving tests.
import torch


class Image:
    def save(self, out, format):
        torch.calls.append(('save', format))
        out.write(b'\x89PNG stand-in')


class Result:
    images = [Image()]


class Pipeline:
    def __init__(self, kind):
        self.kind = kind

    def __call__(self, prompt, **kwargs):
        torch.calls.append(('call', prompt, kwargs))
        return Result()

    def to(self, device):
        torch.calls.append(('to', device))
        return self


class DiffusionPipeline:
    @staticmethod
    def from_pretrained(path, **kwargs):
        torch.calls.append(('pipeline', path, kwargs))
        return Pipeline('diffusion')


class FluxPipeline:
    @staticmethod
    def from_pretrained(path, **kwargs):
        torch.calls.append(('flux', path, sorted(kwargs)))
        return Pipeline('flux')


class FluxTransformer2DModel:
    @staticmethod
    def from_pretrained(path, **kwargs):
        torch.calls.append(('transformer', kwargs['subfolder'], kwargs['quantization_config'].bits))
        return 'transformer'


class BitsAndBytesConfig:
    def __init__(self, load_in_8bit):
        self.bits = 8 if load_in_8bit else 16
