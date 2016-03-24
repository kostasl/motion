CROSS COMPILATION FOR THE RASP PI - QT Applications
#My First Attempt was with cmake. Added a cmake.pi include that I call before each call to cmake. This worked for same sample applications coded from begining. For both methods mentioned here you need to first mount the RPI FS:

##Make sure you have first mounted the RaspPi Fs in the mntrpi directory with the following command~:##

sudo sshfs pi@192.168.0.20:/ /home/kostasl/workspace/raspberrypi/mntrpi/ -o transform_symlinks -o allow_other

##CMAKE Cross Compile##
-For cmake cross-compilation :
Add CMakeLists.txt with:

project(larvamotiontracker)
cmake_minimum_required(VERSION 2.8)
aux_source_directory(. SRC_LIST)
add_executable(${PROJECT_NAME} ${SRC_LIST})
---
Then run:
cmake -D CMAKE_TOOLCHAIN_FILE=$HOME/workspace/raspberrypi/pi.cmake ../
and :
make

###GMAKE
However I couldn't get it work with motion-mmal - Thus I turned to gmake. There I customized the make file to use the cross compiler. First for the make to find the include files you need to mount the RPI fs as above. 

To Cross Compile for RaspPi - I used the example makeFile included in this dir. I added an rpi target. U can call make rpi to cross compile. The key is to call the right compiler arm-linux-gnueabihf-gcc and add the flags for -march and mtune as below:

CFLAGSRPI       =  -g -O2 -D_REENTRANT -DMOTION_V4L2 -DMOTION_V4L2_OLD -DTYPE_32BIT="int" -DHAVE_BSWAP   -march=armv7-a -mtune=generic-armv7-a -Wall -DVERSION=\"Git-8619d7c17ce112e7196975905c6e840f345141ba\" -Dsysconfdir=\"$(sysconfdir)\" -I $(INCDIR_RPI) -I $(INCDIR_RPI2) -I $(INCDIR_RPI3) -L $(LIBDIR_RPI)

as well as the include directories from the mounted RPI:
INCDIR_RPI	= /home/kostasl/workspace/raspberrypi/mntrpi/usr/include
INCDIR_RPI2	= /home/kostasl/workspace/raspberrypi/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/arm-linux-gnueabihf/sysroot/usr/include
INCDIR_RPI3 	= /home/kostasl/workspace/raspberrypi/mntrpi/usr/include/arm-linux-gnueabihf

##The Develoment Enviroment QT - can compile given the Makefile is provided -
# Yet I am not sure how to get it to use the cross kit and construct makefile automatically thus : /*I haven't managed to get Qt Creator to compile - but the make file works fine.


##########
#KL Note 24/3/2016: For Webcam Start with preloading of library :
#
# bash -c 'LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libv4l/v4l1compat.so ./larmotion -c motion-dist.conf'
#-Side note: I've been getting Gray screen on localhost:8081 with /dev/video0 failing when using USB webcams #although they work when I use other webcam software (like cheese).
#The solution I infered from here  (https://help.ubuntu.com/community/Webcam/Troubleshooting)
# is to preload the v41 library :
#first find it :
#find /usr/lib* -name v4l*
#
#then preload as : 
#bash -c 'LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libv4l/v4l1compat.so ./motion -c motion-dist.conf'

