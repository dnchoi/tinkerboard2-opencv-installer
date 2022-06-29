import cv2

def main():
    cap = cv2.VideoCapture(5)
    cv2.namedWindow("video", cv2.WINDOW_AUTOSIZE)
    if cap.isOpened():
        while True:
            r, f = cap.read()

            if r:
                if f is not None:
                    cv2.imshow("video", f)
                    if cv2.waitKey(1) == ord('q'):
                        break
    else:
        f = cv2.imread("../test.jpg")
        cv2.imshow("video", f)
        cv2.waitKey(0)


if __name__ == "__main__":
    main()