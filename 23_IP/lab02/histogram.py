import numpy as np
import cv2
import matplotlib.pyplot as plt

def cal_hist(image):
    hist = cv2.calcHist([image],[0], None, [256],[0,256])
    return hist

def save_histogram_ver2(hist, name):
    plt.figure()
    hist = hist.flatten()
    binX = np.arange(len(hist))
    plt.bar(binX, hist, width=1, color='g')
    plt.title('histogram bar')
    plt.xlabel('intensity')
    plt.ylabel('pixel num')
    plt.savefig('{}.jpg'.format(name))

def save_histogram_ver1(hist, name):
    plt.figure()
    plt.plot(hist)
    plt.title('histogram plot')
    plt.xlabel('intensity')
    plt.ylabel('pixel num')
    plt.savefig('{}.jpg'.format(name))

