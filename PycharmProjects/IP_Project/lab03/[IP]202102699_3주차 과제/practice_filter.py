import cv2
import numpy as np


def filtering_to_opencv(src, divide_number, mode):
    if mode == 'average':
        kernel = np.ones((3, 3), np.float32) / divide_number
    elif mode == 'sharpening':
        kernel = np.ones((3, 3), np.float32) / 9
        center_kernel = [[0, 0, 0],
                         [0, 2, 0],
                         [0, 0, 0]]
        kernel = center_kernel - kernel
    return cv2.filter2D(src, -1, kernel, borderType=cv2.BORDER_CONSTANT)


def filtering_average_divide_12(src):
    kernel = np.ones((3, 3), np.float32) / 12
    return cv2.filter2D(src, -1, kernel, borderType=cv2.BORDER_CONSTANT)


def filtering_average_divide_4(src):
    kernel = np.ones((3, 3), np.float32) / 4
    return cv2.filter2D(src, -1, kernel, borderType=cv2.BORDER_CONSTANT)
