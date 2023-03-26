import cv2
import numpy as np

img01 = np.zeros((200, 20))
img02 = np.zeros((20, 20))

img03 = np.zeros((20, 20), dtype=np.uint8)
img04 = np.ones((20, 20), dtype=np.uint8)
img05 = np.full((20, 20), 255, dtype=np.uint8)

print(img01.dtype)
print(img03.dtype)

cv2.imshow("img01", img01)
cv2.imshow("img02", img02)
cv2.imshow("img03", img03)
cv2.imshow("img04", img04)
cv2.imshow("img05", img05)

cv2.waitKey()
cv2.destroyAllWindows()