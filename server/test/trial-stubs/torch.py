# A stand-in for PyTorch in the trial's serving tests: it records what
# the serving code asks of it.
bfloat16 = 'bfloat16'
calls = []


class Generator:
    def __init__(self, device):
        calls.append(('generator', device))

    def manual_seed(self, seed):
        calls.append(('seed', seed))
        return self
