import numpy as np
import cv2


def my_normalize(src):
    dst = src.copy()
    dst *= 255
    dst = np.clip(dst, 0, 255)
    return dst.astype(np.uint8)


def my_padding(src, pad_shape):
    (h, w) = src.shape
    (p_h, p_w) = pad_shape
    pad_img = np.zeros((h+2*p_h, w+2*p_w))
    pad_img[p_h:p_h+h, p_w:p_w+w] = src
    return pad_img



def rgb_filtering(img):
    tmp = img
    dst = []
    for i in range(3):
        dst.append(cv2.equalizeHist(tmp[:, :, i]))
    dst = np.stack(dst, axis=2)

    return dst


def yuv_filtering(yuv):
    yuv[:, :, 0] = cv2.equalizeHist(yuv[:, :, 0])
    return yuv


if __name__ == '__main__':
    src = cv2.imread('canoe.png')
    src = cv2.resize(src, (src.shape[1] * 2, src.shape[0] * 2))
    yuv = cv2.cvtColor(src, cv2.COLOR_BGR2YUV)
    rgb_result = rgb_filtering(src)
    yiq_result = yuv_filtering(yuv)

    cv2.imshow('sharpening_YUV', cv2.cvtColor(yiq_result, cv2.COLOR_YUV2BGR))
    cv2.imshow('sharpening_RGB', rgb_result)
    cv2.waitKey()
    cv2.destroyAllWindows()
