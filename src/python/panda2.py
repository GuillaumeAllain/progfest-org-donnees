#! shebangrun() { conda activate ../../build/python/env > /dev/null;ipython $1;conda deactivate > /dev/null; }; shebangrun

import pandas as pd
import matplotlib.pyplot as plt
from panda1 import extract_magnitude


def read_datafile(id):
    file = f"data/rwe_{str(id)}.dat"

def main():
    data_frame_acc = []
    for ii in range(1, 8):
        data_frame_acc.append(read_datafile(ii))


if __name__ == "__main__":
    main()
