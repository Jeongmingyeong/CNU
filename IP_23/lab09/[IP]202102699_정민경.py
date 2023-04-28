import cv2
import numpy as np
import matplotlib.pyplot as plt


def get_threshold_by_within_variance(intensity, p):

    """
    :param intensity: pixel 값 0 ~ 255 범위를 갖는 배열
    :param p: 상대도수 값 ( 이론자료 수식에서의 p와 동일 )
    :return: k: 최적의 threshold 값
    """

    ########################################################
    # TODO
    # TODO otsu_method 완성
    # TODO  1. within-class variance를 이용한 방법
    # TODO  교수님 이론 PPT 22 page 참고 (수식을 이용해서 구현)
    ########################################################

    q1, q2 = 0       # 전체에서의 비율 ( 이론자료에서의 q와 동일 )
    m1, m2 = 0       # 평균 (m)
    sum1, sum2 = 0   # pixel 값 * 그에 해당하는 pixel 의 개수
    s1, s2 = 0       # 분산 (sigma^2)
    w_s = 0          # within-class variance

    # q 값 구하기
    for i in range(256): # threshold 값을 1부터 255 까지 바꿔가며 값 저장
        for j in range(i+1):
            q1[i] += p[j]
            for k in range(j+1, 256):
                q2[i] += p[k]

    # 평균 구하기
    for i in range(256): # threshold 값을 1부터 255 까지 바꿔가며 값 저장
        for j in range(i+1):
            sum1 += j * p[j]
            m1[i] = sum1 / p[j]
            for k in range(j+1, 256):
                sum2 += k * p[k]
                m2[i] = sum2 / p[k]

    # 분산 구하기
    sum1, sum2 = 0  # (각각 pixel 값 - 평균)^2 * pixel 의 개수(p(i))
    for i in range(256): # threshold 값을 1부터 255 까지 바꿔가며 값 저장
        for j in range(i+1):
            sum1 += (((j - m1[j]) ** 2) * p[j])
            s1[i] = sum1 / q1[j]
            for k in range(j+1, 256):
                sum2 += (((k - m1[k]) ** 2) * p[k])
                s2[i] = sum2 / q1[k]

    # within-class variance
    for k in range(256): # threshold 값을 1부터 255 까지 바꿔가며 값 저장
        w_s[k] = (p[k] * s1[k]) + ((1-p[k]) * s2[k])

    # k 구하기 ( = w_s 의 최솟값 찾기 )
    k = np.amin(w_s)

    return k

def get_threshold_by_inter_variance(p):

    """
    :param p: 상대도수 값 ( 이론자료 수식에서의 p와 동일 )
    :return: k: 최적의 threshold 값
    """

    ########################################################
    # TODO
    # TODO otsu_method 완성
    # TODO  2. inter-class variance를 이용한 방법
    # TODO  Moving average를 이용하여 구현
    # TODO  교수님 이론 PPT 26 page 참고 (수식을 이용해서 구현)
    ########################################################

    p += 1e-7  # q1과 q2가 0일때 나눗셈을 진행할 경우 오류를 막기 위함

    q1 = []
    m1, m2 = []  # 평균 (m)
    b_s = 0  # between-class variance
    q1[0] = 0
    m1[0] = 0
    m2[0] = 0

    for k in range(1, 256):
        q1[k] = q1[k-1] + p[k]
        m1[k] = ((q1[k-1] * m1[k-1]) + (k * p[k])) / q1[k]
        m2[k] = (((1 - q1[k - 1]) * m2[k - 1]) - (k * p[k])) / (1 - q1[k])

    for k in range(256):
        b_s[k] = q1[k] * (1 - q1[k]) * ((m1[k] - m2[k]) ** 2)

    k = np.amax(b_s)

    return k


def get_hist(src, mask):

    """
    :param src: gray scale 이미지
    :param mask: masking을 하기 위한 값
    :return:
    """

    #######################################################################
    # TODO mask를 적용한 히스토그램 완성
    # TODO mask 값이 0인 영역은 픽셀의 빈도수를 세지 않음
    # TODO histogram을 생성해 주는 내장함수 사용금지. np.histogram, cv2.calHist
    #######################################################################
    hist = np.zeros((256,))

    ???

    return hist


def threshold(src, threshold, mask):
    """
    :param src: gray scale 이미지
    :param threshold: threshold 값
    :param mask: masking을 하기 위한 값
    :return:
    """

    ########################################################
    # TODO threshold 값을 이용한 이미지 값 채우기
    # TODO 0 < src <= threshold 이면 255로 채움
    # TODO mask의 값이 0인 좌표에 대해서는 값을 0으로 채움
    # TODO 이외의 영역은 모두 0으로 채움
    # TODO cv2.threshold 사용금지
    ########################################################

    h, w = src.shape
    dst = np.zeros((h, w), dtype=np.uint8)

    ???

    return dst


def otsu_method(src, mask):

    """
    :param src: 원본 이미지와 mask를 곱한 이미지
    :param mask: 0 or 1의 값을 갖음
            histogram과 threshold 과정시 mask 값이 0에 해당하는 index는 처리를 하지 않기 위함

    변수 정보
    hist: 위의 src에 대하여 masking을 적용한 히스토그램을 구한 배열
    intensity: 0 ~ 255의 값을 갖는 배열
    p: 상대 도수 (히스토그램의 정규화)
    k1: within variance 방식으로 구한 최적의 threshold 값
    k2: inter variance 방식으로 구한 최적의 threshold 값

    :return: 2가지 방식으로 thresholding된 결과 이미지들 (dst1, dst2)
    """

    hist = get_hist(src, mask)
    hist = hist.astype((np.int32))
    intensity = np.array([i for i in range(256)])

    ########################################################
    # TODO 상대도수 p 구하기
    # TODO 교수님 이론 PPT 17 page -> p_{i}에 해당
    ########################################################
    p = hist / hist.size

    ########################################################
    # TODO otsu_method 완성
    # TODO  1. within-class variance를 이용한 방법
    # TODO      (get_threshold_by_within_variance 함수 사용)
    # TODO  2. between-class variance를 이용한 방법
    # TODO      (get_threshold_by_inter_variance 함수 사용)
    ########################################################

    k1 = get_threshold_by_within_variance(intensity, p)
    k2 = get_threshold_by_inter_variance(p)

    # k1과 k2가 같아야 한다.
    # 같지 않으면 실행 종료
    assert k1 == k2

    dst1 = threshold(src, k1, mask)
    dst2 = threshold(src, k2, mask)

    ########################################################
    # TODO Bimodal histogram 완성
    # TODO 2개의 peak에 해당하는 픽셀 값에 점 찍기
    # TODO 보고서에 결과 이미지 첨부
    ########################################################
    # Bi-modal Distribution
    plt.plot(intensity, hist)
    plt.plot(???, ???, color='red', marker='o', markersize=6)
    plt.plot(???, ???, color='red', marker='o', markersize=6)
    plt.xlabel('Pixel value')
    plt.ylabel('Frequency')
    plt.title('Interest region histogram')
    plt.show()

    return dst1, dst2


def main():
    meat = cv2.imread('meat.png', cv2.IMREAD_GRAYSCALE)
    # mask 값을 0 또는 1로 만들기 위해 255로 나누어줌
    mask = cv2.imread('mask.png', cv2.IMREAD_GRAYSCALE) / 255

    # meat.png에서 관심 영역 해당하는 부분만 따로 추출.
    src = (meat * mask).astype(np.uint8)

    # 추출된 이미지 확인.
    cv2.imshow('original', meat)
    cv2.imshow('interest src', src)
    cv2.waitKey()
    cv2.destroyAllWindows()

    # 관심 영역 해당하는 이미지에 대하여 otsu's method 적용
    dst1, dst2 = otsu_method(src, mask)

    # True 값이 나와야함
    print("2가지 방식 결과 비교 : {}".format(np.array_equal(dst1, dst2)))

    # 원본 이미지에 적용하기
    final1 = cv2.add(meat, dst1)
    final2 = cv2.add(meat, dst1)

    # 본인 학번 적기
    cv2.imshow('2021xxxx within_variance dst', dst1)
    cv2.imshow('2021xxxx inter_variance dst', dst2)
    cv2.imshow('2021xxxx final1', final1)
    cv2.imshow('2021xxxx final2', final2)

    cv2.waitKey()
    cv2.destroyAllWindows()

    # 보고서 첨부용
    cv2.imwrite('dst_by_within_variance.png', dst1)
    cv2.imwrite('dst_by_inter_variance.png', dst2)
    cv2.imwrite('final_by_within_variance.png', final1)
    cv2.imwrite('final_by_inter_variance.png', final2)

    return


if __name__ == '__main__':
    main()