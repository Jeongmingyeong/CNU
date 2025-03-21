import numpy as np
import cv2
import matplotlib.pyplot as plt


def my_get_Gaussian2D_mask(msize, sigma=1):
    y, x = np.mgrid[-(msize // 2):(msize // 2) + 1, -(msize // 2):(msize // 2) + 1]

    gaus2D = 1 / (2 * np.pi * sigma ** 2) * np.exp(-((x ** 2 + y ** 2) / (2 * sigma ** 2)))

    gaus2D /= np.sum(gaus2D)
    return gaus2D


def my_normalize(src):
    dst = src.copy()
    dst *= 255
    dst = np.clip(dst, 0, 255)
    return dst.astype(np.uint8)


def my_padding(src, pad_shape):
    (h, w) = src.shape
    (p_h, p_w) = pad_shape
    pad_img = np.zeros((h + 2 * p_h, w + 2 * p_w))
    pad_img[p_h:p_h + h, p_w:p_w + w] = src
    return pad_img


def my_filtering(src, mask):
    """

    :param src: filtering 할 이미지
    :param mask: filtering 할 mask
    :return: filtering된 결과 이미지
    """

    (h, w) = src.shape
    # mask의 크기
    (m_h, m_w) = mask.shape
    # 직접 구현한 my_padding 함수를 이용
    pad_img = my_padding(src, (m_h // 2, m_w // 2))
    dst = np.zeros((h, w))
    for row in range(h):
        for col in range(w):
            val = np.sum(pad_img[row:row + m_h, col:col + m_w] * mask)
            dst[row, col] = val
    return dst


def add_gaus_noise(src, mean=0, sigma=0.1):
    # src : 0 ~ 255, dst : 0 ~ 1
    dst = src / 255
    h, w, c = dst.shape
    noise = np.random.normal(mean, sigma, size=(h, w, c))
    dst += noise
    return my_normalize(dst)


def my_median_filtering(src, msize):
    """

    :param src: filtering 할 이미
    :param msize: filter 크기
    :return: filtering된 이미지
    """
    h, w = src.shape

    dst = np.zeros((h, w))
    for row in range(h):
        for col in range(w):

            #########################################################
            # TODO
            # TODO median filtering 코드 작성
            # TODO median filtering 구현 시 openCV, np.median 사용금지
            # TODO median filtering 구현 시 sorting 관련 내장 함수 사용 허용
            # TODO 이전 실습 코드 참고
            # median filtering 은 mask 의 값들을 정렬해서 중간값 사용
            #########################################################

            r_start = np.clip(row - (msize // 2), 0, h)
            r_end = np.clip(row + (msize // 2), 0, h)

            c_start = np.clip(col - msize // 2, 0, w)
            c_end = np.clip(col + msize // 2, 0, w)

            mask = src[r_start:r_end, c_start:c_end]

            mask_1D = np.array(mask).flatten()

            # 1차원 배열을 정렬
            sorted_array = np.sort(mask_1D)

            # 중앙값 계산
            median = sorted_array[len(sorted_array) // 2]
            dst[row, col] = median

    return dst


if __name__ == '__main__':

    src = cv2.imread('canoe.png')
    np.random.seed(seed=100)

    # noise image: uint8 형
    noise_image = add_gaus_noise(src, mean=0.1, sigma=0.1)
    # noise image: float 형
    src_noise = noise_image / 255

    ######################################################
    # TODO
    # TODO RGB에서 Gaussian, Median filter 진행
    # TODO Filtering된 결과 이미지는 uint8형 타입이어야함
    #  -> (my_normalize 사용)
    ######################################################

    gaus2D = my_get_Gaussian2D_mask(msize=3, sigma=5)

    B = src_noise[:, :, 0]
    G = src_noise[:, :, 1]
    R = src_noise[:, :, 2]

    B_ = my_filtering(B, gaus2D)
    G_ = my_filtering(G, gaus2D)
    R_ = my_filtering(R, gaus2D)
    rgb_gaussian_dst = my_normalize(np.dstack((B_, G_, R_)))

    B_ = my_median_filtering(B, 3)
    G_ = my_median_filtering(G, 3)
    R_ = my_median_filtering(R, 3)
    rgb_median_dst = my_normalize(np.dstack((B_, G_, R_)))

    ######################################################
    # TODO
    # TODO YUV에서 Gaussian, Median filter 진행
    # TODO Filtering된 결과 이미지는 uint8형 타입이어야함
    #  -> (my_normalize 사용)
    # TODO yuv noise 이미지는 내장 모듈 사용 (cv2.COLOR_BGR2YUV)
    # TODO yuv_noise에서 첫번째 채널이 Y
    ######################################################

    gaus2D = my_get_Gaussian2D_mask(msize=3,  sigma=5)
    yuv_noise = cv2.cvtColor(noise_image, cv2.COLOR_BGR2YUV)
    yuv_noise = yuv_noise / 255

    Y = yuv_noise[:, :, 0]
    U = yuv_noise[:, :, 1]
    V = yuv_noise[:, :, 2]

    Y_ = my_filtering(Y, gaus2D)
    yuv_gaussian_dst = my_normalize(np.dstack((Y_, U, V)))

    Y = yuv_noise[:, :, 0]
    U = yuv_noise[:, :, 1]
    V = yuv_noise[:, :, 2]

    Y_ = my_median_filtering(Y, 3)
    yuv_median_dst = my_normalize(np.dstack((Y_, U, V)))

    cv2.imshow('original_202102699', src)
    cv2.imshow('noise image_202102699', noise_image)
    cv2.imshow('RGB + gaussain filtering_202102699', rgb_gaussian_dst)
    cv2.imshow('RGB + median filtering_202102699', rgb_median_dst)
    cv2.imshow('YUV + gaussian filtering_202102699', cv2.cvtColor(yuv_gaussian_dst, cv2.COLOR_YUV2BGR))
    cv2.imshow('YUV + median filtering_202102699', cv2.cvtColor(yuv_median_dst, cv2.COLOR_YUV2BGR))
    cv2.waitKey()
    cv2.destroyAllWindows()
