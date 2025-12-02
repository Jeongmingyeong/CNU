import cv2
import numpy as np

def my_padding(src, pad_shape, pad_type = 'zero'):
    """
    TODO : padding 구현
    :param src: original image
    :param pad_shape: padding size 2D
    :param pad_type: 'zero' or 'repetition'
    :return:
    """
    h, w= src.shape
    p_h, p_w = pad_shape[0], pad_shape[1]
    pad_image = np.zeros((h + 2 * p_h, w + 2 * p_w)).astype(np.uint8)
    pad_image[p_h: h + p_h, p_w: w + p_w] = src

    if pad_type == 'repetition':
        print('Apply Repetition Padding')
        # up
        pad_image[:p_h, p_w:p_w + w] = src[0, :]

        # down
        pad_image[p_h + h:, p_w:p_w + w] = src[h-1:, :]

        # left
        pad_image[:, :p_w] = pad_image[:, p_w:p_w + 1]

        # right
        pad_image[:, p_w + w:] = pad_image[:, p_w + w - 1: p_w + w]
    else:
        print('Apply Zero Padding')

    return pad_image