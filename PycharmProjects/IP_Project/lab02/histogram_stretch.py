import numpy as np
import cv2
import matplotlib.pyplot as plt

def cal_hist(image):
    hist = cv2.calcHist([image],[0], None, [256],[0,256])
    return hist

def hist_stretch(src, hist):
    h, w = src.shape
    dst = np.zeros((h, w), dtype=np.uint8)
    min = 256
    max = -1

    for i in range(len(hist)):
        if hist[i] != 0 and i < min:
            min = i
        if hist[i] != 0 and i > max:
            max = i

    stretch_hist = np.zeros(hist.shape, dtype=np.int64)

    for i in range(min, max + 1):
        j = int((255 - 0) / (max - min) * (i - min) + 0)
        stretch_hist[j] = hist[i]

    for row in range(h):
        for col in range(w):
            dst[row, col] = (255 - 0) / (max - min) * (src[row, col] - min) + 0

    return dst, stretch_hist

def save_histogram_stretch(hist, name):
    plt.figure()
    hist = hist.flatten()
    binX = np.arange(len(hist))
    plt.bar(binX, hist, width=1, color='g')
    plt.title('histogram stretch')
    plt.xlabel('intensity')
    plt.ylabel('pixel num')
    plt.savefig('{}.jpg'.format(name))
