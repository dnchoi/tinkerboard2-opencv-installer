#include <iostream>
#include <cstdlib>

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/imgcodecs/imgcodecs.hpp>
#include <opencv2/video/video.hpp>
#include <opencv2/videoio/videoio.hpp>

using namespace std;

int main(int argc, char *argv[]){

	cv::VideoCapture video(5);

    cv::Mat frame;
	if(video.isOpened()){
		video.set(cv::CAP_PROP_FRAME_WIDTH, 640);
		video.set(cv::CAP_PROP_FRAME_HEIGHT, 480);

		cv::namedWindow("video", cv::WINDOW_AUTOSIZE);
		while(true){
			video >> frame;
			cv::imshow("video", frame);
			if(cv::waitKey(1)==27)
				break;
		}
	}
    else{
        frame = cv::imread("../../test.jpg");
        cv::imshow("video", frame);
        cv::waitKey(0);
    }
	return 0;
}