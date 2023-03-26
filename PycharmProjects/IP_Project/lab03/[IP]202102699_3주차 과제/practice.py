from practice_filter import *
from practice_padding import *
from practice_gaussian import *
import cv2

def filtering_main():
    image = cv2.imread('Lena.png', cv2.IMREAD_GRAYSCALE)
    average_filterd_image = filtering_to_opencv(image, 9, 'average')
    cv2.imwrite('save_image/average_9.jpg', average_filterd_image)
    average_filterd_4_image = filtering_average_divide_4(image)
    cv2.imwrite('save_image/average_4.jpg', average_filterd_4_image)
    average_filterd_12_image = filtering_average_divide_12(image)
    cv2.imwrite('save_image/average_12.jpg', average_filterd_12_image)
    sharpening_image = filtering_to_opencv(image, 9, 'sharpening')
    cv2.imwrite('save_image/sharpening.jpg', sharpening_image)

def padding_main():
    image = cv2.imread('Lena.png', cv2.IMREAD_GRAYSCALE)
    zero_padding_image = my_padding(image, (40,40), 'average')
    cv2.imwrite('save_image/zero_padding.jpg', zero_padding_image)
    repetition_image = my_padding(image, (40,40), 'repetition')
    cv2.imwrite('save_image/repetition.jpg', repetition_image)

def gaussian_mask_main():
    ksize = 5
    sigma = 1
    mask_2D = gaussian_2D_mask(ksize, sigma)
    mask_1D = gaussian_1D_mask(ksize, sigma)
    print(mask_2D, mask_1D)

def gaussian_image_main():
    ksize = 5
    sigma = 3
    image = cv2.imread('Lena.png', cv2.IMREAD_GRAYSCALE)
    mask_2D = gaussian_2D_mask(ksize, sigma)
    mask_1D = gaussian_1D_mask(ksize, sigma)
    gaussian_2d_image = cv2.filter2D(image, -1, mask_2D, borderType=cv2.BORDER_CONSTANT)
    cv2.imwrite('save_image/gaussian_2D.jpg',gaussian_2d_image)
    gaussian_1d_image = cv2.filter2D(image, -1, mask_1D, borderType=cv2.BORDER_CONSTANT)
    gaussian_1d_image = cv2.filter2D(gaussian_1d_image, -1, mask_1D.T, borderType=cv2.BORDER_CONSTANT)
    cv2.imwrite('save_image/gaussian_1D.jpg', gaussian_1d_image)

if __name__ == "__main__":
    padding_main()