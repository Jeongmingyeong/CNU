import cv2
import numpy as np
import matplotlib.pyplot as plt
from Practice_Sobel import *

def my_get_Gaussian_filter(fshape, sigma=1):
    (f_h, f_w) = fshape

    ############################################################################
    # TODO 2 2D Gaussian filter 구현
    # TODO 2 np.mrid를 사용하면 y, x 모두 구할 수 있음
    # TODO 이 함수에서는 정규화를 사용하지 않음.
    # TODO hint
    #     y, x = np.mgrid[-1:2, -1:2]
    #     y => [[-1,-1,-1],
    #           [ 0, 0, 0],
    #           [ 1, 1, 1]]
    #     x => [[-1, 0, 1],
    #           [-1, 0, 1],
    #           [-1, 0, 1]]
    ############################################################################

    return gaussian_filter

def first_DoG_filter_mask(fsize, sigma):
    ############################################################################
    # TODO 2 가우시안 마스크와 미분 필터를 이용한 DoG 필터 마스크 구현
    # TODO 2 미분 필터는 이론 PPT 필터를 참고
    # TODO 2 가우시안 마스크에 미분 필터를 적용하여 DoG 마스크를 구함
    # TODO 2 OPEN CV 내장함수 사용 불가
    # TODO 2 원하는 크기의 DoG 필터를 구해야 함.
    # TODO 2 Hint 필터링 과정 시 영역을 넘어가는 부분을 잘 처리해야함.
    # TODO 수식은 이론 및 실습 ppt를 참고하여 구현.
    ############################################################################

    return gaussianfilter_x, gaussianfilter_y

def second_DoG_filter_mask(fsize, sigma):
    ############################################################################
    # TODO 3 수식을 이용한 DoG 필터 마스크 구현
    # TODO 3 np.mrid를 사용하면 y, x 모두 구할 수 있음
    # TODO hint
    #     y, x = np.mgrid[-1:2, -1:2]
    #     y => [[-1,-1,-1],
    #           [ 0, 0, 0],
    #           [ 1, 1, 1]]
    #     x => [[-1, 0, 1],
    #           [-1, 0, 1],
    #           [-1, 0, 1]]
    # TODO 수식은 이론 및 실습 ppt를 참고하여 구현.
    ############################################################################

    return DoG_x, DoG_y

def calculate_magnitude(sobel_x, sobel_y):
    magnitude = np.sqrt(sobel_x ** 2 + sobel_y ** 2)
    return magnitude

def make_noise(std, gray):
    height, width = gray.shape
    img_noise = np.zeros((height, width), dtype=np.float)
    for i in range(height):
        for a in range(width):
            make_noise = np.random.normal()  # 랜덤함수를 이용하여 노이즈 적용
            set_noise = std * make_noise
            img_noise[i][a] = gray[i][a] + set_noise
    return img_noise


if __name__ == "__main__":
    ############################################################################
    # TODO 1 Denoising DoG
    ############################################################################
    image = cv2.imread('Lena.png', cv2.IMREAD_GRAYSCALE)

    noise_image = make_noise(10, image)
    cv2.imshow('noise_image', noise_image / 255)
    sobX, sobY = generate_sobel_filter_cv2(noise_image)
    sobel_x_filter, sobel_y_filter = generate_sobel_filter_2D()
    sobel_x_image = filtering(noise_image, sobel_x_filter)
    sobel_y_image = filtering(noise_image, sobel_y_filter)

    cv2.imshow('Sobel_magnitude', calculate_magnitude(sobel_x_image / 255., sobel_y_image / 255.))

    dog_2_y, dog_2_x = second_DoG_filter_mask(5, 1)
    dog_x_image = cv2.filter2D(noise_image, -1, dog_2_x, borderType=cv2.BORDER_CONSTANT)
    dog_y_image = cv2.filter2D(noise_image, -1, dog_2_y, borderType=cv2.BORDER_CONSTANT)
    cv2.imshow('Dog_Magnitude', calculate_magnitude(dog_x_image / 255., dog_y_image / 255.))

    ############################################################################
    # TODO 2 첫번째 DoG 필터 마스크 구현
    ############################################################################
    image = cv2.imread('Lena.png', cv2.IMREAD_GRAYSCALE)
    dog_2_y, dog_2_x = second_DoG_filter_mask(5, 1)
    dog_1_x, dog_1_y = first_DoG_filter_mask(5, 1)

    rate = dog_2_y.mean() / dog_1_y.mean()
    print(rate)
    dog_1_y_renew = dog_1_y * rate
    dog_1_x_renew = dog_1_x * rate

    dog_x_image = cv2.filter2D(image, -1, dog_2_x, borderType=cv2.BORDER_CONSTANT)
    dog_y_image = cv2.filter2D(image, -1, dog_2_y, borderType=cv2.BORDER_CONSTANT)
    dog_x_image2 = cv2.filter2D(image, -1, dog_1_x_renew, borderType=cv2.BORDER_CONSTANT)
    dog_y_image2 = cv2.filter2D(image, -1, dog_1_y_renew, borderType=cv2.BORDER_CONSTANT)

    cv2.imshow('TODO_1_Dog_Magnitude', calculate_magnitude(dog_x_image / 255., dog_y_image / 255.))
    cv2.imshow('TODO_2_Dog_Magnitude', calculate_magnitude(dog_x_image2 / 255., dog_y_image2 / 255.))
    cv2.waitKey()


