import ROOT
import numpy as np
import pydicom
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt

ds = pydicom.dcmread("CT.dcm")
image = ds.pixel_array * ds.RescaleSlope + ds.RescaleIntercept
plt.imshow(image, cmap="gray")

f = ROOT.TFile.Open("dose_1e4_gate91-Dose.root")
dose = f.histo

nx = dose.GetNbinsX()
ny = dose.GetNbinsY()

dose_np = np.zeros((nx,ny))

binpos = 0
for y in range(1, ny + 1):
    for x in range(1, nx + 1):
        binc = dose.GetBinContent(x, y)
        if not np.isnan(binc):
            dose_np[x-1,y-1] = binc


print(np.min(dose_np), np.max(dose_np))

dose_np[dose_np<1e-8] = np.nan

plt.imshow(dose_np, alpha=0.7, interpolation="bilinear")
plt.show()

plt.savefig("doseImage91.png")
