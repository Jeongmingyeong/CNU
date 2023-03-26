from pixel_wise_operation import *
from histogram import *
from histogram_stretch import *

def select_pixel_wise_operation(image, mode, contrast_intensity=2, intensity=32):
    if mode == 'darken':
        return darken(image, intensity)
    elif mode == 'lighten':
        return lighten(image, intensity)
    elif mode == 'lower contrast':
        return lower_contrast(image, contrast_intensity)
    elif mode == 'raise contrast':
        return raise_contrast(image, contrast_intensity)
    elif mode == 'invert':
        return invert(image)
    elif mode == 'non linear lower contrast':
        return non_linear_lower_contrast(image)
    elif mode == 'non linear raise contrast':
        return non_linear_raise_contrast(image)
    else:
        print('존재하지 않는 Pixel-wise operation입니다.')
        return None

def pixel_wise_main():
    image = cv2.imread('Lena.png',cv2.IMREAD_GRAYSCALE)
    file_name = 'Lena'
    modes = ['darken', 'lighten', 'lower contrast', 'raise contrast', 'invert', 'non linear lower contrast', 'non linear raise contrast']
    for mode in modes:
        cv2.imwrite('save_image/{}_{}.jpg'.format(file_name,mode), select_pixel_wise_operation(image,mode,2))
    return 0

def draw_histogram_main():
    high_image = cv2.imread('Lena.png',cv2.IMREAD_GRAYSCALE)
    high_image1 = select_pixel_wise_operation(high_image, 'lower contrast', 1, 24)
    high_image2 = select_pixel_wise_operation(high_image, 'lower contrast', 3, 24)
    cv2.imwrite('save_image/test2.png', high_image1)
    cv2.imwrite('save_image/test3.png', high_image2)
    high_histogram1 = cal_hist(high_image1)
    save_histogram_ver1(high_histogram1, 'save_histogram/darken')
    save_histogram_ver2(high_histogram1, 'save_histogram/darken2')
    high_histogram2 = cal_hist(high_image2)
    save_histogram_ver1(high_histogram2, 'save_histogram/high')
    save_histogram_ver2(high_histogram2, 'save_histogram/high2')
    return 0

def histogram_stretch_main():
    original = cv2.imread('save_image/test2.png', cv2.IMREAD_GRAYSCALE)
    divide_three = cv2.imread('save_image/test3.png', cv2.IMREAD_GRAYSCALE)
    divide_hist = cal_hist(divide_three)

    dst, st_hist = hist_stretch(divide_three, divide_hist)
    save_histogram_stretch(st_hist, 'save_histogram/stretch')
    cv2.imwrite('save_image/stretch.png', dst)


if __name__ == "__main__":
    histogram_stretch_main()