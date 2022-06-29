#!/bin/sh
mkdir sdk-tools; cd sdk-tools;

sudo apt update; sudo apt upgrade -y

sudo apt -y install build-essential checkinstall cmake pkg-config yasm
sudo apt -y install git gfortran
sudo apt -y install libjpeg-dev
echo "@@@@@@@@@@@@@  setp 1 done @@@@@@@@@@@@@"
wget http://launchpadlibrarian.net/516139264/libjasper-dev_1.900.1-debian1-2.4ubuntu1.3_arm64.deb

sudo apt install ./libjasper-dev*.deb --install-recommends -y
echo "@@@@@@@@@@@@@  setp 2 done @@@@@@@@@@@@@"

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
echo "@@@@@@@@@@@@@  setp 3 done @@@@@@@@@@@@@"

cd ~/sdk-tools;

git clone https://github.com/opencv/opencv.git
git clone https://github.com/opencv/opencv_contrib.git
echo "@@@@@@@@@@@@@  setp 4 done @@@@@@@@@@@@@"

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
echo "@@@@@@@@@@@@@  setp 5 done @@@@@@@@@@@@@"

make -j4
echo "@@@@@@@@@@@@@  setp 6 done @@@@@@@@@@@@@"

sudo make install
echo "@@@@@@@@@@@@@  setp 7 done @@@@@@@@@@@@@"

sudo ldconfig
echo "@@@@@@@@@@@@@  setp 8 done @@@@@@@@@@@@@"

echo "@@@@@@@@@@@@@  All    done @@@@@@@@@@@@@"

