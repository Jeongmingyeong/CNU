import cv2
import numpy as np
import time
from average_filtering_analysis import *

def three_filtering(image, kernel):

    start = time.perf_counter()
    three_filtering = my_filtering(image, kernel)
    print('3 X 3 Filter Time : {}'.format(time.perf_counter() - start))
    cv2.imwrite('save_image/practice_3.png', three_filtering)

def seven_filtering(image, kernel):

    start = time.perf_counter()
    three_filtering = my_filtering(image, kernel)
    print('7 X 7 Filter Time : {}'.format(time.perf_counter() - start))
    cv2.imwrite('save_image/practice_7.png', three_filtering)

def fif_filtering(image, kernel):

    start = time.perf_counter()
    three_filtering = my_filtering(image, kernel)
    print('15 X 15 Filter Time : {}'.format(time.perf_counter() - start))
    cv2.imwrite('save_image/practice_15.png', three_filtering)

def compare_speed_filtering():

    image = cv2.imread('Lena.png', cv2.IMREAD_GRAYSCALE)
    three_filter = generate_average_filter(3)
    seven_filter = generate_average_filter(7)
    fif_filter = generate_average_filter(15)

    three_filtering(image, three_filter)
    #time.sleep(0.1)
    seven_filtering(image, seven_filter)
    #time.sleep(0.1)
    fif_filtering(image, fif_filter)
    #time.sleep(0.1)


def main():

    compare_speed_filtering()

    return

if __name__ == "__main__":
    main()