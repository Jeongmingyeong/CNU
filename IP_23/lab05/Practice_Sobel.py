import cv2
import numpy as np

def generate_sobel_filter_cv2(src):
    sobX = cv2.Sobel(src, cv2.CV_64F, 1, 0, ksize=3)
    sobY = cv2.Sobel(src, cv2.CV_64F, 0, 1, ksize=3)
    return sobX, sobY

def generate_sobel_filter_2D():
    sobel_x = np.dot(np.array([[1], [2], [1]]), np.array(([[-1, 0, 1]])))
    sobel_y = np.dot(np.array([[-1], [0], [1]]), np.array(([[1, 2, 1]])))
    return sobel_x, sobel_y

def filtering(src, kernel):
    filtering_image = cv2.filter2D(src, -1, kernel, borderType=cv2.BORDER_CONSTANT)
    return filtering_image

if __name__ == "__main__":
    image = cv2.imread('Lena.png', cv2.IMREAD_GRAYSCALE)

    sobX, sobY = generate_sobel_filter_cv2(image)
    sobel_x_filter, sobel_y_filter = generate_sobel_filter_2D()
    sobel_x_image = filtering(image, sobel_x_filter)
    sobel_y_image = filtering(image, sobel_y_filter)

    cv2.imwrite('save_image/cv2_sobel_x.png', sobX)
    cv2.imwrite('save_image/cv2_sobel_y.png', sobY)
    cv2.imwrite('save_image/kernel_sobel_x.png', sobel_x_image)
    cv2.imwrite('save_image/kernel_sobel_y.png', sobel_y_image)



