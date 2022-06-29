# Thinker board OpenCV installer ( rk3399 )
## Envs
* [Debian OS](https://dlcdnets.asus.com/pub/ASUS/Embedded_IPC/Tinker%20Board%202/Tinker_Board_2-Debian-Buster-v2.0.4-20211222.zip)
* python3
* cmake 3.13.4

## Reference
* [Jasper-dev](https://launchpad.net/ubuntu/xenial/arm64/libjasper-dev/1.900.1-debian1-2.4ubuntu1.3)
* [Opencv install](https://github.com/vlarobbyk/opencv-tinker-board)

## Dependency

### Update OS packages and required libraries
----
```sh
sudo apt update; sudo apt upgrade -y

sudo apt -y install build-essential checkinstall cmake pkg-config yasm
sudo apt -y install git gfortran
sudo apt -y install libjpeg-dev

```

### Install jasper library
---
```sh
wget http://launchpadlibrarian.net/516139264/libjasper-dev_1.900.1-debian1-2.4ubuntu1.3_arm64.deb

sudo apt install ./libjasper-dev*.deb --install-recommends -y
```

### Install codecs
---
```sh
sudo apt -y install libtiff5-dev
sudo apt -y install libtiff-dev
sudo apt -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
sudo apt -y install libxine2-dev libv4l-dev
sudo apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt -y install libgtk2.0-dev libtbb-dev qt5-default
sudo apt -y install libatlas-base-dev
sudo apt -y install libmp3lame-dev libtheora-dev
sudo apt -y install libvorbis-dev libxvidcore-dev libx264-dev
sudo apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
sudo apt -y install libavresample-dev
sudo apt -y install x264 v4l-utils

cd /usr/include/linux
sudo ln -s -f ../libv4l1-videodev.h videodev.h

cd ~
```

## Download OpenCV and OpenCV-Contrib source
```sh
mkdir sdk-tools; cd sdk-tools;
git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
# opencv version 4.x
# if your using 3.x version, checkout branch 3.x
```

## Compile and install OpenCV with contrib modules
```sh
cd opencv; mkdir build; cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D CMAKE_SHARED_LINKER_FLAGS=-latomic \
    -D BUILD_EXAMPLES=OFF \
    -D PYTHON3_EXECUTABLE=$(which python3) \
    -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
    -D PYTHON3_INCLUDE_DIR2=$(python3 -c "from os.path import dirname; from distutils.sysconfig import get_config_h_filename; print(dirname(get_config_h_filename()))") \
    -D PYTHON3_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))") \
    -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())") \
    -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") ..

make -j4

sudo make install

sudo ldconfig
```

## Test Opencv Library C++ source
```sh
cd TestCV/cpp; mkdir build;
cmake ..; make;
test_opencv_video_cpp
```

> c++ source
```cpp
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
        frame = cv::imread("test.jpg");
        cv::imshow("video", frame);
        cv::waitKey(0);
    }
	return 0;
}
```
> CmakeLists.txt
```CMake
cmake_minimum_required(VERSION 3.3)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} [OpenCV.cmake PATH])

project(test_opencv_video_cpp)



set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")



find_package(OpenCV REQUIRED)

include_directories(${OpenCV_INCLUDE_DIR})



set(SOURCE_FILES main.cpp)

add_executable(test_opencv_video_cpp ${SOURCE_FILES})

target_link_libraries(test_opencv_video_cpp ${OpenCV_LIBRARIES})
```

## Test Opencv Library C++ source
```sh
cd TestCV/python;
python3 main.py
```
> python source
```python
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
        f = cv2.imread("test.jpg")
        cv2.imshow("video", f)
        cv2.waitKey(0)


if __name__ == "__main__":
    main()
```