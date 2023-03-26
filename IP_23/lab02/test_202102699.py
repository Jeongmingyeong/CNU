import numpy as np
import cv2
import matplotlib.pyplot as plt

def my_calcHist(src):
    ###############################
    # TODO                        #
    # my_calcHist완성             #
    # src : input image           #
    # hist : src의 히스토그램      #
    ###############################

    array = []
    for i in src :
        for j in range(len(i)):
            array.append(i[j])

    hist = [0.0] * 256

    for i in array:
        hist[i] = hist[i] + 1

    a = np.array(hist)
    return a

def my_normalize_hist(hist, pixel_num):
    ########################################################
    # TODO                                                 #
    # my_normalize_hist완성                                #
    # hist : 히스토그램                                     #
    # pixel_num : image의 전체 픽셀 수                      #
    # normalized_hist : 히스토그램값을 총 픽셀수로 나눔      #
    ########################################################

    normalized_hist = np.zeros(hist.shape)
    for i in range(len(hist)) :
        normalized_hist[i] = float(hist[i]) / float(pixel_num)

    return np.array(normalized_hist)

def my_PDF2CDF(pdf):
    ########################################################
    # TODO                                                 #
    # my_PDF2CDF완성                                       #
    # pdf : normalized_hist                                #
    # cdf : pdf의 누적                                     #
    ########################################################
    cdf = np.zeros(pdf.shape)
    cdf[0] = 0 + pdf[0]
    for i in range(1, len(pdf)) :
        cdf[i] = cdf[i-1] + pdf[i]
    return np.array(cdf)

def my_denormalize(normalized, gray_level):
    ########################################################
    # TODO                                                 #
    # my_denormalize완성                                   #
    # normalized : 누적된pdf값(cdf)                        #
    # gray_level : max_gray_level                          #
    # denormalized : normalized와 gray_level을 곱함        #
    ########################################################
    denormalized = np.zeros(normalized.shape)
    for i in range(len(normalized)) :
        denormalized[i] = normalized[i] * gray_level
    return np.array(denormalized)

def my_calcHist_equalization(denormalized, hist):
    ###################################################################
    # TODO                                                            #
    # my_calcHist_equalization완성                                    #
    # denormalized : output gray_level(정수값으로 변경된 gray_level)   #
    # hist : 히스토그램                                                #
    # hist_equal : equalization된 히스토그램                           #
    ####################################################################
    hist_equal = np.zeros(hist.shape)

    for i in range(len(hist)):
        hist_equal[denormalized[i]] = hist_equal[denormalized[i]] + int(hist[i])

    return np.array(hist_equal)

def my_equal_img(src, output_gray_level):
    ###################################################################
    # TODO                                                            #
    # my_equal_img완성                                                #
    # src : input image                                               #
    # output_gray_level : denormalized(정수값으로 변경된 gray_level)   #
    # dst : equalization된 결과 이미지                                 #
    ####################################################################

    (h, w) = src.shape # h 는 몇줄인지 / w 는 몇열인지
    dst = np.zeros((h, w), dtype=np.uint8) # 이차원배열

    for row in range(h):
        for col in range(w):
            dst[row, col] = output_gray_level[src[row, col]]

    return dst

def check(pred, answer):
    # check shape
    if pred is None:
        print('틀렸습니다!')
        return 0
    #if pred.shape[0] != answer.shape[0]:
    #    print('틀렸습니다!!!')
    #    return 0
    #if pred.shape[1] != answer.shape[1]:
    #    print('틀렸습니다!!!')
    #    return 0
    if np.array_equal(pred,answer):
        print('pass the test')
        return 1
    else:
        print('틀렸습니다!!!')
        return 0

if __name__=="__main__":
    image = [[0, 1, 1, 1, 2],
             [2, 3, 3, 3, 3],
             [3, 3, 3, 4, 4],
             [4, 4, 4, 4, 5],
             [5, 5, 5, 7, 7],
             [8, 8, 9, 11, 12]]
    image = np.array(image)

    # my_calcHist 테스트 함수
    test_calc = my_calcHist(image)
    answer_1 = np.load('answer/hist_test.npy')
    check(test_calc, answer_1)

    # my_normalize_hist 테스트 함수
    test_calc2 = my_normalize_hist(test_calc, 30)
    answer_2 = np.load('answer/normalize_test.npy')
    check(test_calc2, answer_2)

    # my_PDF2CDF 테스트 함수
    test_calc3 = my_PDF2CDF(test_calc2)
    answer_3 = np.load('answer/cdf_test.npy')
    check(test_calc3, answer_3)

    # my_denormalize 테스트 함수
    test_calc4 = my_denormalize(test_calc3, 255) # 내가 바꿨음 (grey_pixel? 이거 인자 추가, image -> test_calc3)
    answer_4 = np.load('answer/denormalize_test.npy')
    check(test_calc4, answer_4)
    output_gray_level = test_calc4.astype(int)
    # my_calcHist_equalization 테스트 함수
    test_calc5 = my_calcHist_equalization(output_gray_level, test_calc) # (image, output_gray_level) -> (output_gray_level, test_calc)
    answer_5 = np.load('answer/hist_equal_test.npy')
    check(test_calc5, answer_5)

    test_calc6 = my_equal_img(image, output_gray_level)
    answer_6 = np.load('answer/my_equal_image.npy')
    check(test_calc6, answer_6)
