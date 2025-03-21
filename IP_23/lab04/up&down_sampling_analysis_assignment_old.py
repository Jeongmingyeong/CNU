import cv2
import numpy as np

def my_bilinear(src, scale):

    (h, w) = src.shape
    h_dst = int(h * scale + 0.5)
    w_dst = int(w * scale + 0.5)

    dst = np.zeros((h_dst, w_dst), dtype=np.float32)

    for row in range(h_dst):
        for col in range(w_dst):
            #######################################################################
            # TODO bilinear interpolation 완성
            # TODO bilinear interpolation 실습 코드 참고
            # TODO Note: dst변수 data type은 np.float32로해서 반환할 것
            #######################################################################

            y = row / scale
            x = col / scale

            # bilinear interpolation
            # 1.(y,x)를 기준으로 좌측위, 좌측아래, 우측아래, 우측위 좌표를 구함.
            # 2. bilinear interplation 식에 따라 해당 row,col좌표에 값을 대입
            y_up = int(y)  # 버림
            y_down = min(int(y + 1), h - 1)  # 반올림 단 src의 최대 좌표값보다는 같거나 작게
            x_left = int(x)  # 버림
            x_right = min(int(x + 1), w - 1)  # 반올림 단 src의 최대 좌표값보다는 같거나 작게

            t = y - y_up
            s = x - x_left

            intensity = ((1 - s) * (1 - t) * src[y_up, x_left]) \
                        + (s * (1 - t) * src[y_up, x_right]) \
                        + ((1 - s) * t * src[y_down, x_left]) \
                        + (s * t * src[y_down, x_right])
            dst[row, col] = intensity
        dst = np.round(dst).astype(np.float32)
    return dst

def my_nearest_neighbor(src, scale=None, shape=None):

    """
    함수 인자 정보
    src: gray scale 이미지 (H x W)
    scale: tuple 자료형
    """

    (h, w) = src.shape

    # scale이 지정된 경우
    if scale is not None:
        h_scale, w_scale = scale
        h_dst = int(h * h_scale + 0.5)
        w_dst = int(w * w_scale + 0.5)

    # scale이 지정 안되고 구체적인 dst 크기가 지정된 경우
    else:
        h_dst, w_dst = shape
        h_scale = h_dst / h
        w_scale = w_dst / w

    dst = np.zeros((h_dst, w_dst), dtype=np.float32)
    for row in range(h_dst):
        for col in range(w_dst):
            #######################################################################
            # TODO nearest interpolation 완성
            # TODO nearest interpolation 실습 코드 참고
            # TODO Note: dst변수 data type은 np.float32로해서 반환할 것
            #######################################################################

            # int(): 소수점 이하를 버림
            r = min(int(row / h_scale), h - 1)
            c = min(int(col / w_scale), w - 1)
            dst[row, col] = src[r, c]
        dst = np.round(dst).astype(np.float32)
    return dst


def my_downsampling(src, ratio):

    """
    함수 인자 정보
    :param src: gray 이미지( H x W )
    :param ratio: downsampling 할 비율

    변수 정보
    downsampled_img: src에 ratio만큼 downsamling을 적용한 결과 이미지

    :return: downsampled_img
    """

    ###########################################################################
    # TODO Downsampling 함수 완성
    # TODO 단순히 ratio 비율 만큼 행 열 추출
    ##########################################################################

    # ratio 만큼 행과 열을 추출
    downsampled_img = src[::ratio, ::ratio]

    return downsampled_img


def my_upsampling_laplacian(srcs, ratio, residuals=None, upsampling_type='bilinear'):

    pyramid_len = len(srcs)
    srcs = srcs[::-1]

    if residuals is not None:
        residuals = residuals[::-1]

    for i in range(pyramid_len):
        if upsampling_type == 'nearest':
            x = my_nearest_neighbor(srcs[i], scale=(ratio, ratio))

        else:
            # bilinear interpolation
            x = my_bilinear(srcs[i], scale=ratio)

        if residuals is not None:
            #######################################################################
            # TODO upsampling된 이미지에 residual 정보 반영하기
            #######################################################################
            # x = ???
            x = x + residuals
            # 0 ~ 255 사이 값으로 bounding
            x = np.clip(x, 0, 255)

    x = np.round(x).astype(np.uint8)
    return x

def my_downsampling_pyramid(src, ratio, pyramid_lvl, filter_size, sigma):

    """
    인자 정보
    :param src: gray 이미지( H x W)
    :param ratio: downsampling 할 비율
    :param pyramid_len:  피라미드의 층 개수
    :param filter_size: gaussian filter 크기
    :param sigma: gaussian filter sigma 값

    변수 정보
    gaussian_pyramid: gaussian filtering 후 크기를 줄인 이미지를 저장할 변수
    downsample_imgs: gaussian filtering을 적용하지 않고 단순히 이미지를 다운 샘플링한 것들을 저장할 변수
    residuals: residual 이미지를 저장할 변수
    """

    gaussian_pyramid = [src.astype(np.float32)]
    if filter_size is not None:
        gaussian_filter = cv2.getGaussianKernel(ksize=filter_size, sigma=sigma)
        gaussian_filter = gaussian_filter @ gaussian_filter.T

    residuals = []
    downsample_imgs = []

    if filter_size is not None:
        for level in range(pyramid_lvl):

            ###########################################################################
            # TODO Laplacian pyramid 진행 절차 (교수님 PPT 41page 참고)
            # TODO 1. Gaussian filtering cv2.filter2D 내장함수 사용할
            # TODO 2. residual 계산 및 저장
            # TODO  2.1 1의 filtering된 이미지를 downsampling 후 upsampling
            # TODO  2.2 residual = filtering된 이미지 - 2.1에서 구한 이미지
            # TODO 3. 2.1에서 downsampling한 이미지를 다음 피라미드의 입력으로 설정
            # TODO 4. 1 ~ 3 과정을 반복
            ###########################################################################

            # 1. filtering
            filtered_img = cv2.filter2D(gaussian_pyramid[-1], -1, gaussian_filter)

            # 2. residual 계산 및 저장
            down_gaussian_img = my_downsampling(filtered_img, ratio)
            up_gaussian_img = cv2.resize(down_gaussian_img, dsize=(0, 0),
                                         fx=ratio, fy=ratio, interpolation=cv2.INTER_LINEAR)
            residual = filtered_img - up_gaussian_img

            # # 2. residual 계산 및 저장
            # residual = ???
            # residuals.append(residual)
            residuals.append(residual)

            if level == 0:
                # 원본 이미지 삭제
                gaussian_pyramid.pop()

            # 3. 2.1에서 downsampling한 이미지를 다음 피라미드의 입력으로 설정
            gaussian_pyramid.append(downsample_imgs)

        return residuals, gaussian_pyramid

    if filter_size is None:
        for level in range(pyramid_lvl):

            ###########################################################################
            # TODO naive pyramid
            # TODO subsample(즉 downsampling 이미지 크기 줄이기) - my_downsampling 함수 사용
            ###########################################################################

            out_img = my_downsampling(src, ratio)
            downsample_imgs.append(out_img)

        return downsample_imgs

def main():

    src = cv2.imread('Lena.png', cv2.IMREAD_GRAYSCALE)

    #######################################################################
    # TODO Upsampling 과정시 Residual 사용 유무 결과 비교
    # TODO down-sampling시 두 과정 모두 기본적으로 Residual + Gaussian filter 사용
    # TODO
    #######################################################################
    ratio = 2
    pyramid_level = 3

    #######################################################################
    # TODO 1.1 Nearest interpolation + Residual 적용
    #######################################################################

    residuals, downsample_imgs = my_downsampling_pyramid(src, ratio=ratio, pyramid_lvl=pyramid_level,
                                                         filter_size=3, sigma=1)

    near_output = my_upsampling_laplacian(downsample_imgs, ratio, residuals, upsampling_type='nearest')


    #######################################################################
    # TODO 1.2 Nearest interpolation + Residual 적용 x
    #######################################################################
    residuals, downsample_imgs = my_downsampling_pyramid(src, ratio=ratio,
                                                         pyramid_lvl=pyramid_level,
                                                         filter_size=3, sigma=1)

    no_res_near_output = my_upsampling_laplacian(downsample_imgs,
                                                 ratio,
                                                 residuals=None,
                                                 upsampling_type='nearest')


    #######################################################################
    # TODO 1.3 Naive up&down sampling Gaussian 적용 x and Residual 적용 x
    #######################################################################
    downsample_imgs = my_downsampling_pyramid(src, ratio=ratio,
                                                         pyramid_lvl=pyramid_level,
                                                         filter_size=None, sigma=None)
    naive_output = my_upsampling_laplacian(downsample_imgs,
                                                 ratio,
                                                 residuals=None,
                                                 upsampling_type='nearest')


    #######################################################################
    # TODO 2 Bilinear Interpolation 적용
    # TODO 2.1 Bilinear Interpolation 적용 + Residual 적용
    #######################################################################
    residuals, downsample_imgs = my_downsampling_pyramid(src, ratio=ratio, pyramid_lvl=pyramid_level,
                                                         filter_size=3, sigma=1)

    bilinear_output = my_upsampling_laplacian(downsample_imgs, ratio, residuals, upsampling_type='bilinear')

    #######################################################################
    # TODO 2 Bilinear Interpolation 적용
    # TODO 2.2 Bilinear Interpolation 적용 + Residual x
    #######################################################################
    residuals, downsample_imgs = my_downsampling_pyramid(src, ratio=ratio, pyramid_lvl=pyramid_level,
                                                         filter_size=3, sigma=1)

    no_res_bilinear_output = my_upsampling_laplacian(downsample_imgs, ratio, residuals=None,
                                                     upsampling_type='bilinear')

    #######################################################################
    # TODO 2 Bilinear Interpolation 적용
    # TODO 2.3 Bilinear Interpolation 적용 + Gaussian 적용 x and Residual 적용 x
    #######################################################################
    downsample_imgs = my_downsampling_pyramid(src, ratio=ratio,
                                                         pyramid_lvl=pyramid_level,
                                                         filter_size=None, sigma=None)

    naive_bilinear_output = my_upsampling_laplacian(downsample_imgs,
                                                 ratio,
                                                 residuals=None,
                                                 upsampling_type='bilinear')

    cv2.imshow('original', src)
    cv2.imshow('naive', naive_output)
    cv2.imshow('nearest', near_output)
    cv2.imshow('no residual nearest', no_res_near_output)
    cv2.imshow('bilinear + residual', bilinear_output)
    cv2.imshow('no residual bilinear output', no_res_bilinear_output)
    cv2.imshow('naive bilinear outputt', naive_bilinear_output)
    cv2.waitKey()
    cv2.destroyAllWindows()


    # 보고서 출력용 이미지
    cv2.imwrite('nearest+residual.png',near_output)
    cv2.imwrite('nearest+no+residual.png', no_res_near_output)
    cv2.imwrite('nearest_naive.png', naive_output)
    cv2.imwrite('bilinear+residual.png',bilinear_output)
    cv2.imwrite('bilinear+no+residual.png',no_res_bilinear_output)
    cv2.imwrite('bilinear_navie.png', naive_bilinear_output)

    return


if __name__ == '__main__':
    main()