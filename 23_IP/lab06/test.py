import cv2
import numpy as np

# import sys
# sys.setrecursionlimit(100000000)

def my_padding(src, filter):
    (h, w) = src.shape
    (h_pad, w_pad) = filter.shape
    h_pad = h_pad // 2
    w_pad = w_pad // 2
    padding_img = np.zeros((h+h_pad*2, w+w_pad*2))
    padding_img[h_pad:h+h_pad, w_pad:w+w_pad] = src
    return padding_img

def my_filtering(src, filter):
    (h, w) = src.shape
    (m_h, m_w) = filter.shape
    pad_img = my_padding(src, filter)
    dst = np.zeros((h, w))
    for row in range(h):
        for col in range(w):
            dst[row, col] = np.sum(pad_img[row:row + m_h, col:col + m_w] * filter)
    return dst

def convert_uint8(img):
    #이미지 출력을 위해서 타입을 변경 수행
    return ((img - np.min(img)) / np.max(img - np.min(img)) * 255).astype(np.uint8)

def get_DoG_filter():
    ###################################################
    # TODO                                            #
    # DoG mask 완성                                    #
    # DoG의 경우 과제가 진행중이기에 저장된 배열을 가지고 와서
    # 불러오는 형식으로 진행함.
    # 함수를 고칠 필요는 전혀 없음.
    ###################################################

    DoG_x = np.load('DoG_x.npy')
    DoG_y = np.load('DoG_y.npy')

    return DoG_x, DoG_y

def calcMagnitude(Ix, Iy):
    ###########################################
    # TODO                                    #
    # calcMagnitude 완성                      #
    # magnitude : ix와 iy의 magnitude         #
    ###########################################
    # Ix와 Iy의 magnitude를 계산
    magnitude = np.sqrt(Ix**2 + Iy**2)
    return magnitude

def calcAngle(Ix, Iy):
    #######################################
    # TODO                                #
    # calcAngle 완성                       #
    # angle     : ix와 iy의 angle          #
    # x 가 0 일 때 예외처리해야함
    # 내 생각에는 이론자료 56 page 참고
    #######################################
    h, w = Ix.shape
    angle = np.zeros(Ix.shape)
    for i in range(h):
        for j in range(w):
            if Ix[i, j] == 0:
                if Iy[i, j] < 0:
                    angle[i, j] = -90
                elif Iy[i, j] == 0:
                    angle[i, j] = 0
                else:
                    angle[i, j] = 90

            else:
                angle[i, j] = np.rad2deg(np.arctan(Iy[i, j] / Ix[i, j]))

    return angle

def pixel_bilinear_coordinate(src, pixel_coordinate):
    ####################################################################################
    # TODO                                                                             #
    # Pixel-Bilinear Interpolation 완성
    # 진행과정
    # 저번 실습을 참고로 픽셀 위치를 기반으로 주변 픽셀을 가져와서 Interpolation을 구현
    ####################################################################################

    h, w = src.shape
    # up_pixel_coordinate = (row + 1, col + rate)
    y, x = pixel_coordinate

    # 주변 픽셀 위치 4개를 가져옴.
    # 가져오는 방식은 저번주 실습을 참고하여 가져오는 것을 추천.
    y_up = int(y)
    y_down = min(int(y + 1), h - 1)
    x_left = int(x)
    x_right = min(int(x + 1), w - 1)

    t = y - y_up
    s = x - x_left

    intensity = ((1 - s) * (1 - t) * src[y_up, x_left]) \
                + (s * (1 - t) * src[y_up, x_right]) \
                + ((1 - s) * t * src[y_down, x_left]) \
                + (s * t * src[y_down, x_right])

    return intensity

def non_maximum_supression_three_size(magnitude, angle):
    ####################################################################################
    # TODO
    # non_maximum_supression 완성                                                      #
    # largest_magnitude     : non_maximum_supression 결과(가장 강한 edge만 남김)         #
    ####################################################################################
    (h, w) = magnitude.shape
    # angle의 범위 : -90 ~ 90
    largest_magnitude = np.zeros((h, w))
    for row in range(1, h - 1):
        for col in range(1, w - 1):
            degree = angle[row, col]

            # gradient의 degree는 edge와 수직방향이다.
            if 0 <= degree and degree < 45:
                rate = np.tan(np.deg2rad(degree))
                left_pixel_coordinate = (row + rate, col + 1)
                right_pixel_coordinate = (row - rate, col - 1)
                left_magnitude = pixel_bilinear_coordinate(magnitude, left_pixel_coordinate)
                right_magnitude = pixel_bilinear_coordinate(magnitude, right_pixel_coordinate)
                if magnitude[row, col] == max(left_magnitude, magnitude[row, col], right_magnitude):
                    largest_magnitude[row, col] = magnitude[row, col]

            elif 45 <= degree and degree <= 90:
                rate = np.tan(np.deg2rad(90 - degree))  # cotan = 1/tan
                up_pixel_coordinate = (row + 1, col + rate)
                down_pixel_coordinate = (row - 1, col - rate)
                up_magnitude = pixel_bilinear_coordinate(magnitude, up_pixel_coordinate)
                down_magnitude = pixel_bilinear_coordinate(magnitude, down_pixel_coordinate)
                if magnitude[row, col] == max(up_magnitude, magnitude[row, col], down_magnitude):
                    largest_magnitude[row, col] = magnitude[row, col]

            elif -45 <= degree and degree < 0:
                rate = -np.tan(np.deg2rad(degree))
                left_pixel_coordinate = (row - rate, col + 1)
                right_pixel_coordinate = (row + rate, col - 1)
                left_magnitude = pixel_bilinear_coordinate(magnitude, left_pixel_coordinate)
                right_magnitude = pixel_bilinear_coordinate(magnitude, right_pixel_coordinate)
                if magnitude[row, col] == max(left_magnitude, magnitude[row, col], right_magnitude):
                    largest_magnitude[row, col] = magnitude[row, col]

            elif -90 <= degree and degree < -45:
                rate = -np.tan(np.deg2rad(90 - degree))
                up_pixel_coordinate = (row - 1, col + rate)
                down_pixel_coordinate = (row + 1, col - rate)
                up_magnitude = pixel_bilinear_coordinate(magnitude, up_pixel_coordinate)
                down_magnitude = pixel_bilinear_coordinate(magnitude, down_pixel_coordinate)
                if magnitude[row, col] == max(up_magnitude, magnitude[row, col], down_magnitude):
                    largest_magnitude[row, col] = magnitude[row, col]

            else:
                print(row, col, 'error!  degree :', degree)

    return largest_magnitude

def non_maximum_supression_five_size(magnitude, angle, step = 0.5):
    ####################################################################################
    # TODO
    # non_maximum_supression 완성
    # largest_magnitude     : non_maximum_supression 결과(가장 강한 edge만 남김)
    ####################################################################################
    (h, w) = magnitude.shape
    # angle의 범위 : -90 ~ 90
    largest_magnitude = np.zeros((h, w))
    for row in range(2, h - 2):
        for col in range(2, w - 2):
            degree = angle[row, col]
            # gradient의 degree는 edge와 수직방향이다.
            if 0 <= degree and degree < 45:
                rate = np.tan(np.deg2rad(degree))
                left_max=0
                right_max = 0
                for i in range(1, 5):
                    left_pixel_coordinate = (row + ((0.5 * i) * rate), col + (((i-1)//2)+1))
                    right_pixel_coordinate = (row - ((0.5 * i) * rate), col - (((i-1)//2)+1))
                    left_magnitude = pixel_bilinear_coordinate(magnitude, left_pixel_coordinate)
                    right_magnitude = pixel_bilinear_coordinate(magnitude, right_pixel_coordinate)
                    if left_max < left_magnitude:
                        left_max = left_magnitude
                    if right_max < right_magnitude:
                        right_max = right_magnitude
                if magnitude[row, col] == max(left_max, magnitude[row, col], right_max):
                    largest_magnitude[row, col] = magnitude[row, col]
            elif 45 <= degree and degree <= 90:
                rate = np.tan(np.deg2rad(90 - degree))  # cotan = 1/tan
                up_max=0
                down_max = 0
                for i in range(1, 5):
                    up_pixel_coordinate = (row + (((i-1)//2)+1), col + ((0.5 * i) * rate))
                    down_pixel_coordinate = (row - (((i-1)//2)+1), col - ((0.5 * i) * rate))
                    up_magnitude = pixel_bilinear_coordinate(magnitude, up_pixel_coordinate)
                    down_magnitude = pixel_bilinear_coordinate(magnitude, down_pixel_coordinate)
                    if up_max < up_magnitude:
                        up_max = up_magnitude
                    if down_max < down_magnitude:
                        down_max = down_magnitude
                if magnitude[row, col] == max(up_max, magnitude[row, col], down_max):
                    largest_magnitude[row, col] = magnitude[row, col]

            elif -45 <= degree and degree < 0:
                rate = -np.tan(np.deg2rad(degree))
                left_max= 0
                right_max = 0
                for i in range(1, 5):
                    left_pixel_coordinate = (row - ((0.5 * i) * rate), col + (((i - 1) // 2) + 1))
                    right_pixel_coordinate = (row + ((0.5 * i) * rate), col - (((i - 1) // 2) + 1))
                    left_magnitude = pixel_bilinear_coordinate(magnitude, left_pixel_coordinate)
                    right_magnitude = pixel_bilinear_coordinate(magnitude, right_pixel_coordinate)
                    if left_max < left_magnitude:
                        left_max = left_magnitude
                    if right_max < right_magnitude:
                        right_max = right_magnitude
                if magnitude[row, col] == max(left_max, magnitude[row, col], right_max):
                    largest_magnitude[row, col] = magnitude[row, col]

            elif -90 <= degree and degree < -45:
                rate = -np.tan(np.deg2rad(90 - degree))
                up_max=0
                down_max = 0
                for i in range(1, 5):
                    up_pixel_coordinate = (row - (((i - 1) // 2) + 1), col + ((0.5 * i) * rate))
                    down_pixel_coordinate = (row + (((i - 1) // 2) + 1), col - ((0.5 * i) * rate))
                    up_magnitude = pixel_bilinear_coordinate(magnitude, up_pixel_coordinate)
                    down_magnitude = pixel_bilinear_coordinate(magnitude, down_pixel_coordinate)
                    if up_max < up_magnitude:
                        up_max = up_magnitude
                    if down_max < down_magnitude:
                        down_max = down_magnitude
                if magnitude[row, col] == max(up_max, magnitude[row, col], down_max):
                    largest_magnitude[row, col] = magnitude[row, col]

            else:
                print(row, col, 'error!  degree :', degree)

    return largest_magnitude

def double_thresholding(src, high_threshold):

    ####################################################################################
    # TODO
    # double_thresholding 완성
    # Goal : Weak Edge와 Strong Edge를 토대로 연결성을 찾아서 최종적인 Canny Edge Detection 이미지를 도출
    # 이 함수는 건드릴 필요가 없음.
    # largest_magnitude     : non_maximum_supression 결과(가장 강한 edge만 남김)
    # double_thresholding 수행 high threshold value는 메인문에서 지정한 값만 사용할 것
    # three : 40
    # five : 29
    ####################################################################################

    dst = src.copy()
    # dst => 0 ~ 255
    dst -= dst.min()
    dst /= dst.max()
    dst *= 255
    dst = dst.astype(np.uint8)
    (h, w) = dst.shape

    high_threshold_value = high_threshold

    low_threshold_value = high_threshold_value * 0.4

    for row in range(h):
        for col in range(w):
            if dst[row, col] >= high_threshold_value:
                dst[row, col] = 255
            elif dst[row, col] < low_threshold_value:
                dst[row, col] = 0
            else:
                # Weak Edge일때 구현
                # search_weak_edge 함수 설명 : Weak Edge를 찾아 배열에 저장하는 함수
                # classify_edge : search_weak_edge를 통해 찾아낸 Weak Edge들을 이용하여 주변에 Strong Edge가 있으면
                #                 weak Edge들을 Strong으로 변경
                #                 만약 Weak Edge 주변에 Strong이 없으면 Weak Edge를 버림.
                weak_edge = []
                # weak_edge.append((row, col))
                weak_edge = search_weak_edge(dst, weak_edge, high_threshold_value, low_threshold_value, (row, col))
                row, col = weak_edge.pop()
                weak_edge.append((row, col))
                # if classify_edge(dst, weak_edge, high_threshold_value, False, (row, col)):
                if calssify_edge(dst, weak_edge, high_threshold_value):
                    for idx in range(len(weak_edge)):
                        (r, c) = weak_edge[idx]
                        dst[r, c] = 255
                else:
                    for idx in range(len(weak_edge)):
                        (r, c) = weak_edge[idx]
                        dst[r, c] = 0

    return dst

def search_weak_edge(dst, edges, high_threshold_value, low_threshold_value, coordinate):
    ####################################################################################
    # TODO
    # search_weak_edge 함수
    # Goal : 연결된 Weak Edge를 찾아서 저장하는 함수
    # 구현의 자유도를 주기위해 실습을 참고하여 구현해도 되며
    # 직접 생각해서 구현해도 무방함. -> 재귀로 해결하기 위해 좌표값인 coordinate 인자 추가
    # dst : image [0 ~ 255]
    # edges : weak_edge 가 저장되는 배열 ( Tl <= dst <= Th 을 만족하는 dst 저장 )
    # high_threshold_value : Th
    # low_threshold_value : Tl
    # coordinate : 인접한 8개의 pixel 을 확인하기 위한 위치를 넘겨주는 float * float tuple 좌표
    # return 은 week edge 가 저장되어 있는 배열
    # weak edge 는 (i1, i2) 형태의 튜플들이 저장되는 배열
    # edges 로 전달받은 인덱스 (1개) 에 인접해있는 weak_edge 들만 저장되어있음.
    ####################################################################################

    h, w = dst.shape
    row, col = coordinate

    # 이미 확인한 index 이거나, weak_edge 가 아닐때는 현재의 edge 를 return 한다.
    if ((row, col) in edges) or (dst[row, col] < low_threshold_value) or (dst[row, col] >= high_threshold_value):
        return edges

    # 이번에 처음 확인한 index 이고, weak_edge 이면 edge 배열에 추가하고 다시 주변 8개의 pixel 에 대해 탐색한다.
    edges.append((row, col))

    # 1번 좌표
    if row > 0 and col > 0:
        edges = search_weak_edge(dst, edges, high_threshold_value, low_threshold_value, (row-1, col -1))
    # 2번 좌표
    if row > 0:
        edges = search_weak_edge(dst, edges, high_threshold_value, low_threshold_value, (row-1, col))
    # 3번 좌표
    if row > 0 and col < w - 1:
        edges = search_weak_edge(dst, edges, high_threshold_value, low_threshold_value, (row-1, col + 1))
    # 4번 좌표
    if col > 0:
        edges = search_weak_edge(dst, edges, high_threshold_value, low_threshold_value, (row, col - 1))
    # 6번 좌표
    if col < w - 1:
        edges = search_weak_edge(dst, edges, high_threshold_value, low_threshold_value, (row, col + 1))
    # 7번 좌표
    if row < h - 1 and col > 0:
        edges = search_weak_edge(dst, edges, high_threshold_value, low_threshold_value, (row + 1, col - 1))
    # 8번 좌표
    if row < h - 1:
        edges = search_weak_edge(dst, edges, high_threshold_value, low_threshold_value, (row + 1, col))
    # 9번 좌표
    if row < h - 1 and col < w - 1:
        edges = search_weak_edge(dst, edges, high_threshold_value, low_threshold_value, (row + 1, col + 1))

    # 중복 제거
    return list(set(edges))

def calssify_edge(dst, weak_edge, high_threshold_value):
    ####################################################################################
    # TODO
    # weak edge가 strong edge랑 연결되어 있는지 확인한 후 edge임을 결정하는 함수
    # 구현의 자유도를 주기위해 실습을 참고하여 구현해도 되며
    # 직접 생각해서 구현해도 무방함.
    # 재귀로 해도 되고, 알고리즘사용해 해결가능, 3가지 인자 모두 사용
    # return 은 week edge 주변에 strong edge 가 없으면 edges 배열에서 없애고 최종적으로 남은 weak edge 배열 반환
    # weak edge 는 (i1, i2) 형태의 튜플들이 저장되는 배열 <- 각 pixel 에 인접한 weak_edge 들의 모음
    # return type 은 bool type
    ####################################################################################
    # ???

    for (i1, i2) in weak_edge: # weak_edge를 봤을 때 <- 지금 베이스케이스가 없네??
        if ((dst[i1 - 1, i2 - 1] >= high_threshold_value)       # 왼쪽 위
            or (dst[i1, i2 - 1] > high_threshold_value)        # 위
            or (dst[i1 + 1, i2 - 1] > high_threshold_value)    # 오른쪽 위
            or (dst[i1 - 1, i2] > high_threshold_value)        # 왼쪽
            or (dst[i1 + 1, i2] > high_threshold_value)        # 오른쪽
            or (dst[i1 - 1, i2 + 1] > high_threshold_value)    # 왼쪽 아래
            or (dst[i1, i2 + 1] > high_threshold_value)        # 아래
            or (dst[i1 + 1, i2 + 1] > high_threshold_value)): # 오른쪽 아래
            return True
        else:
            continue

    return False

def my_canny_edge_detection(src):
    # low-pass filter를 이용하여 blur효과
    # high-pass filter를 이용하여 edge 검출
    # gaussian filter -> sobel filter 를 이용해서 2번 filtering
    DoG_x, DoG_y = get_DoG_filter()
    Ix = my_filtering(src, DoG_x)
    Iy = my_filtering(src, DoG_y)

    # magnitude와 angle을 구함
    magnitude = calcMagnitude(Ix, Iy)
    cv2.imshow('magnitude', convert_uint8(magnitude))

    angle = calcAngle(Ix, Iy)

    #non-maximum suppression 수행
    larger_magnitude2 = non_maximum_supression_three_size(magnitude, angle)
    cv2.imshow('NMS_Three', convert_uint8(larger_magnitude2))
    larger_magnitude3 = non_maximum_supression_five_size(magnitude, angle)
    cv2.imshow('NMS_Five', convert_uint8(larger_magnitude3))

    #double thresholding 수행
    dst = double_thresholding(larger_magnitude2,40)
    dst2 = double_thresholding(larger_magnitude3,29)
    return dst, dst2

def main():
    src = cv2.imread('Lena.png', cv2.IMREAD_GRAYSCALE)

    dst, dst2 = my_canny_edge_detection(src)

    cv2.imshow('original_202102655', src)
    cv2.imshow('my canny edge detection_202102655', dst)
    cv2.imshow('my canny edge detection2_202102655', dst2)
    cv2.waitKey()
    cv2.destroyAllWindows()

if __name__ == '__main__':
    main()

