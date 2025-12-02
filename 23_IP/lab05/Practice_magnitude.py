import cv2
import numpy as np
from Practice_Sobel import *

def calculate_magnitude(sobel_x, sobel_y):

    # Element Wise Multiplication

    # IxIx = np.zeros(sobel_x.shape, dtype=sobel_x.dtype)
    # for i in range(IxIx.shape[0]):
    #     for j in range(IxIx.shape[1]):
    #         IxIx[i,j] = sobel_x[i,j] * sobel_x[i,j]
    #
    # IyIy = np.zeros(sobel_y.shape, dtype=sobel_x.dtype)
    # for i in range(IyIy.shape[0]):
    #     for j in range(IyIy.shape[1]):
    #         IyIy[i, j] = sobel_y[i, j] * sobel_y[i, j]
    #
    # magnitude = np.sqrt(IxIx + IyIy)

    # Simple
    magnitude = np.sqrt(sobel_x ** 2 + sobel_y ** 2)
    return magnitude

if __name__ == "__main__":
    image = cv2.imread('noise_lena.png', cv2.IMREAD_GRAYSCALE)

    sobel_x_filter, sobel_y_filter = generate_sobel_filter_2D()
    sobel_x_image = filtering(image, sobel_x_filter)
    sobel_y_image = filtering(image, sobel_y_filter)

    magnitude_image = calculate_magnitude(sobel_x_image / 255., sobel_y_image / 255.)
    cv2.imwrite('save_image/magnitude_noise.png', magnitude_image * 255)

