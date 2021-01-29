cd ..

# 1. Packages 
# https://github.com/IntelRealSense/librealsense/blob/master/doc/installation_raspbian.md
# https://stackoverflow.com/questions/52378554/problems-importing-open-cv-in-python
sudo apt-get install -y libdrm-amdgpu1 libdrm-amdgpu1-dbgsym libdrm-dev libdrm-exynos1 libdrm-exynos1-dbgsym libdrm-freedreno1 libdrm-freedreno1-dbgsym libdrm-nouveau2 libdrm-nouveau2-dbgsym libdrm-omap1 libdrm-omap1-dbgsym libdrm-radeon1 libdrm-radeon1-dbgsym libdrm-tegra0 libdrm-tegra0-dbgsym libdrm2 libdrm2-dbgsym
sudo apt-get install -y libglu1-mesa libglu1-mesa-dev glusterfs-common libglu1-mesa libglu1-mesa-dev libglui-dev libglui2c2
sudo apt-get install -y mesa-utils mesa-utils-extra xorg-dev libgtk-3-dev libusb-1.0-0-dev
sudo apt-get install -y automake libtool vim cmake libusb-1.0-0-dev libx11-dev xor$
sudo apt-get install -y libqtgui4 libqt4-test
sudo apt-get install -y build-essential cmake pkg-config
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libfontconfig1-dev libcairo2-dev
sudo apt-get install -y libgdk-pixbuf2.0-dev libpango1.0-dev
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev
sudo apt-get install -y libatlas-base-dev gfortran
sudo apt-get install -y libhdf5-dev libhdf5-serial-dev libhdf5-103
sudo apt-get install -y ibqtgui4 libqtwebkit4 libqt4-test python3-pyqt5
sudo apt-get install -y python3-dev

# 2. Intel RealSense repo
git clone https://github.com/IntelRealSense/librealsense.git
cd librealsense
sudo cp config/99-realsense-libusb.rules /etc/udev/rules.d/ 
sudo udevadm control --reload-rules && udevadm trigger 
cd ..

export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
source ~/.bashrc

# 3. Protobuf
git clone --depth=1 -b v3.5.1 https://github.com/google/protobuf.git
cd protobuf
./autogen.sh
./configure
make -j4 -fpermissive
sudo make install
cd python
echo 'export LD_LIBRARY_PATH=../src/.libs' >> ~/.bashrc
source ~/.bashrc
#python3 setup.py build --cpp_implementation 
#python3 setup.py test --cpp_implementation
#sudo python3 setup.py install --cpp_implementation
#~
pip3 install protobuf
#~
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=cpp
export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION_VERSION=3
sudo ldconfig
protoc --version
cd ../..

# 4. Intel TBB
wget https://github.com/PINTO0309/TBBonARMv7/raw/master/libtbb-dev_2018U2_armhf.deb
sudo dpkg -i libtbb-dev_2018U2_armhf.deb
sudo ldconfig
rm libtbb-dev_2018U2_armhf.deb

# 5. OpenCV for Python
# https://learnopencv.com/install-opencv-4-on-raspberry-pi/
# https://stackoverflow.com/questions/59080094/raspberry-pi-and-opencv-cant-install-libhdf5-100
#sudo apt autoremove -y libopencv3
#wget https://github.com/mt08xx/files/raw/master/opencv-rpi/libopencv3_3.4.3-20180907.1_armhf.deb
#sudo dpkg -i libopencv3_3.4.3-20180907.1_armhf.deb
#sudo ldconfig
pip3 install opencv-contrib-python

# 6. GStreamer
# https://docs.mopidy.com/en/v0.8.0/installation/gstreamer/
# https://raspberrypi.stackexchange.com/questions/58826/gstreamer-installation-on-raspberry-pi-for-video-streaming
# https://stackoverflow.com/questions/40246437/problems-with-gst-in-python-program
sudo apt-get install -y gstreamer-1.0 gstreamer1.0-tools python3-gst-1.0

# 7. Compile and install librealsense
cd librealsense
mkdir build && cd build
cmake .. -DBUILD_EXAMPLES=true -DCMAKE_BUILD_TYPE=Release -DFORCE_LIBUVC=true
make -j4
sudo make install

# 8. Compile and install RealSense Python module
cmake .. -DBUILD_PYTHON_BINDINGS=bool:true -DPYTHON_EXECUTABLE=$(which python3)
make -j4
sudo make install
echo 'export PYTHONPATH=$PYTHONPATH:/usr/local/lib' >> ~/.bashrc
source ~/.bashrc

# 9. OpenGL for Python
sudo apt-get install -y python-opengl
sudo -H pip3 install pyopengl
sudo -H pip3 install pyopengl_accelerate

# 9. More Python modules
pip3 install netifaces flask_socketio
pip3 install -r requirements_pi.txt

# 10. Last steps
# Run raspi-config to check that your video driver is set to Fake KMS.
# Reboot.
# Test by running realsense-viewer .
