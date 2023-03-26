import cv2
import numpy as np

def gaussian_2D_mask(filter_size, sigma):
    mask = cv2.getGaussianKernel(filter_size, sigma)
    gaussian_mask = mask @ mask.T
    return gaussian_mask

def gaussian_1D_mask(filter_size, sigma):
    mask = cv2.getGaussianKernel(filter_size, sigma)
    return mask