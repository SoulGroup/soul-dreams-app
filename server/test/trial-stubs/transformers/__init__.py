# A stand-in for transformers in the trial's serving tests.
import torch


class BitsAndBytesConfig:
    def __init__(self, load_in_8bit):
        self.bits = 8 if load_in_8bit else 16


class T5EncoderModel:
    @staticmethod
    def from_pretrained(path, **kwargs):
        torch.calls.append(('encoder', kwargs['subfolder'], kwargs['quantization_config'].bits))
        return 'encoder'
