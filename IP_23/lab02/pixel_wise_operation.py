import cv2
import numpy as np


def lighten(image, intensity):
    dst = np.zeros(image.shape)
    if len(dst.shape) == 3:
        for i in range(3):
            dst = cv2.add(image[:, :, i], intensity)
    else:
        dst = cv2.add(image[:, :], intensity)
    return dst


def darken(image, intensity):
    dst = np.zeros(image.shape)
    if len(dst.shape) == 3:
        for i in range(3):
            dst = cv2.subtract(image[:, :, i], intensity)
    else:
        dst = cv2.subtract(image[:, :], intensity)
    return dst


def lower_contrast(image, intensity):
    intensity_image = np.full((image.shape), intensity, dtype=np.uint8)
    return cv2.divide(image, intensity_image)


def raise_contrast(image, intensity):
    intensity_image = np.full((image.shape), intensity, dtype=np.uint8)

    dst = cv2.multiply(image, intensity_image)
    return dst


def invert(image):
    return 255 - image


def non_linear_lower_contrast(image):
    return ((image / 255) ** (1 / 3)) * 255


def non_linear_raise_contrast(image):
    return ((image / 255) ** 2) * 255
