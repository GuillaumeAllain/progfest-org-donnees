#! shebangrun() { conda activate ../../build/python/env > /dev/null;ipython $1;conda deactivate > /dev/null; }; shebangrun

import pandas as pd
import numpy as np
from scipy.interpolate import SmoothBivariateSpline
import matplotlib.pyplot as plt

N_SIDE = 21


def extract_magnitude(fma_panda, n=N_SIDE):
    mx = fma_panda["X-Field"].max()
    my = fma_panda["Y-Field"].max()
    arry, arrx = np.mgrid[-mx : mx : n * 1j, -my : my : n * 1j]
    output = np.zeros_like(arrx)
    ry, rx = np.argwhere(np.sqrt(arry**2 + arrx**2) <= (mx + 1e-8)).T
    test = SmoothBivariateSpline(
        fma_panda["X-Field"], fma_panda["Y-Field"], fma_panda["Magnitude"]
    )
    output[:, :] = np.nan
    output[ry, rx] = test.ev(arry, arrx)[ry, rx]
    return output


def read_datafile(id):
    file = f"data/rwe_{str(id)}.dat"
    dataframe = pd.read_csv(file, header=3, sep="\t+", skipfooter=4, engine="python")
    dataframe["id"] = id
    return dataframe


def main():
    data_frame_acc = []
    for ii in range(1, 8):
        data_frame_acc.append(read_datafile(ii))
    data_frame_final = pd.concat(data_frame_acc)
    data_frame_final.to_hdf("data/data_concat.hdf5", "store")
    data_frame_read = pd.read_hdf("data/data_concat.hdf5")
    magrand = extract_magnitude(data_frame_read[data_frame_read["id"] == 1])
    plt.imshow(magrand)
    plt.show()


if __name__ == "__main__":
    main()
