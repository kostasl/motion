################################################################################
# Makefile for Motion                                                          #
################################################################################
# Copyright 2000 by Jeroen Vreeken                                             #
#                                                                              #
# This program is published under the GNU public license version 2.0 or later. #
# Please read the file COPYING for more info.                                  #
################################################################################
# Please visit the Motion home page:                                           #
# http://www.lavrsen.dk/twiki/bin/view/Motion                                  #
################################################################################

CC      = gcc
CCRPI	 = arm-linux-gnueabihf-gcc
INSTALL = install

################################################################################
# Install locations, controlled by setting configure flags.                    #
################################################################################
prefix      = /usr/local
builddir    = build
exec_prefix = ${prefix}
bindir      = ${exec_prefix}/bin
mandir      = ${datarootdir}/man
sysconfdir	= ${prefix}/etc
sysconfdirRPI	= ${prefix}/etc
datadir     = ${datarootdir}
datarootdir = ${prefix}/share
docdir      = $(datadir)/doc/motion-Git-8619d7c17ce112e7196975905c6e840f345141ba 
examplesdir = $(datadir)/motion-Git-8619d7c17ce112e7196975905c6e840f345141ba/examples

################################################################################
# These variables contain compiler flags, object files to build and files to   #
# install.                                                                     #
################################################################################
OBJDIR	=$(builddir)
INCDIR_RPI	= /home/kostasl/workspace/raspberrypi/mntrpi/usr/include
INCDIR_RPI1	= /home/kostasl/workspace/raspberrypi/mntrpi/usr/local/include
INCDIR_RPI2	= /home/kostasl/workspace/raspberrypi/tools/arm-bcm2708/arm-rpi-4.9.3-linux-gnueabihf/arm-linux-gnueabihf/sysroot/usr/include
INCDIR_RPI3 	= /home/kostasl/workspace/raspberrypi/mntrpi/usr/include/arm-linux-gnueabihf

LIBDIR_RPI	= /home/kostasl/workspace/raspberrypi/mntrpi/usr/lib/arm-linux-gnueabihf

CFLAGS       =  -g -O2 -D_REENTRANT -DMOTION_V4L2 -DMOTION_V4L2_OLD -DTYPE_32BIT="int" -DHAVE_BSWAP -DHAVE_FFMPEG -DHAVE_FFMPEG_NEW  -march=native -mtune=native -Wall -DVERSION=\"Git-8619d7c17ce112e7196975905c6e840f345141ba\" -Dsysconfdir=\"$(sysconfdir)\" 

#-L/mntrpi/usr/lib/arm-linux-gnueabihf
FFMPEG_LIB =  -lavformat -lavcodec -lavutil -lm -lz
FFMPEG_OBJ = ffmpeg.o

########RPI 2 ###########
###I Run Config on RPI 2 Got :
#CFLAGS:  -g -O2 -D_REENTRANT -DHAVE_FFMPEG -I/usr/local/include -DFFMPEG_NEW_INCLUDES -DHAVE_FFMPEG_NEW -#DMOTION_V4L2 -DMOTION_V4L2_OLD -DTYPE_32BIT="int" -DHAVE_BSWAP   -march=native -mtune=native
# For Cross-Compile I use : -march=armv7-a -mfloat-abi=softfp
CFLAGSRPI       =  -g -O2 -D_REENTRANT -DMOTION_V4L2 -DMOTION_V4L2_OLD -DHAVE_FFMPEG -DFFMPEG_NEW_INCLUDES -DHAVE_FFMPEG_NEW -DTYPE_32BIT="int" -DHAVE_BSWAP   -march=armv7-a -mtune=generic-armv7-a -Wall -DVERSION=\"Git-8619d7c17ce112e7196975905c6e840f345141ba\" -Dsysconfdir=\"$(sysconfdir)\" -I $(INCDIR_RPI) -I $(INCDIR_RPI2) -I $(INCDIR_RPI3) -L $(LIBDIR_RPI)


LDFLAGS      	=
LDFLAGS_RPI	= -L $(LIBDIR_RPI)
LIBS         	= -lm  -lpthread -ljpeg $(FFMPEG_LIB)
VIDEO_OBJ    	= video.o video2.o video_common.o


#OBJ          =  motion.o logger.o conf.o draw.o jpegutils.o vloopback_motion.o $(VIDEO_OBJ) \
#			   netcam.o netcam_ftp.o netcam_jpeg.o netcam_wget.o track.o \
#			   alg.o event.o picture.o rotate.o webhttpd.o \
#			   stream.o md5.o  
OBJ          = $(addprefix $(OBJDIR)/, motion.o logger.o conf.o draw.o jpegutils.o vloopback_motion.o $(VIDEO_OBJ) netcam.o netcam_ftp.o netcam_jpeg.o netcam_wget.o track.o alg.o event.o picture.o rotate.o webhttpd.o stream.o md5.o  $(FFMPEG_OBJ))

SRC          = $(.o=.c)
DOC          = CHANGELOG COPYING CREDITS INSTALL README motion_guide.html
EXAMPLES     = *.conf motion.init-Debian motion.init-Fedora motion.init-FreeBSD.sh
PROGS        = larmotion
PROGSRPI     = larmotion-rpi
DEPEND_FILE  = .depend

################################################################################
# ALL and PROGS build Motion and, possibly, Motion-control.                    #
################################################################################
all: progs
ifneq (,$(findstring freebsd,$(VIDEO_OBJ)))
	@echo "Build complete, run \"gmake install\" to install Motion!"
else
	@echo "Build complete, run \"make install\" to install Motion!"
endif
	@echo

progs: pre-build-info $(PROGS)

################################################################################
# ALL and PROGS build Motion and, possibly, Motion-control.                    #
################################################################################
rpi: progs-rpi
	@echo "Build complete, run \"gmake install\" to install Motion!"
	@echo

progs-rpi: pre-build-info-rpi $(PROGSRPI)


################################################################################
# PRE-BUILD-INFO outputs some general info before the build process starts.    #
################################################################################
pre-build-info: 
	@echo "Welcome to the setup procedure for Motion, the motion detection daemon! If you get"
	@echo "error messages during this procedure, please report them to the mailing list. The"
	@echo "Motion Guide contains all information you should need to get Motion up and running."
	@echo "Run \"make updateguide\" to download the latest version of the Motion Guide."
	@echo
	@echo "Version: Git-8619d7c17ce112e7196975905c6e840f345141ba"
ifneq (,$(findstring freebsd,$(VIDEO_OBJ)))
	@echo "Platform: FreeBSD"
else
	@echo "Platform: Linux (if this is incorrect, please read README.FreeBSD)"
endif
	@echo

################################################################################
# PRE-BUILD-INFO RPI outputs some general info before the build process starts.    #
################################################################################
pre-build-info-rpi: 
	@echo "Welcome to the setup procedure for Motion, the motion detection daemon! If you get"
	@echo "error messages during this procedure, please report them to the mailing list. The"
	@echo "Motion Guide contains all information you should need to get Motion up and running."
	@echo "Run \"make updateguide\" to download the latest version of the Motion Guide."
	@echo
	@echo "Version: Git-8619d7c17ce112e7196975905c6e840f345141ba"
	@echo "Platform: Raspberry Pi 2 : ARM 7"
	@echo


################################################################################
# MOTION builds motion. MOTION-OBJECTS and PRE-MOBJECT-INFO are helpers.       #
################################################################################
larmotion: motion-objects
	@echo "Linking Motion..."
	@echo "--------------------------------------------------------------------------------"
	$(CC) $(LDFLAGS) -o $(addprefix $(OBJDIR)/, $@) $(OBJ) $(LIBS)
	@echo "--------------------------------------------------------------------------------"
	@echo "Motion has been linked."
	@echo


motion-objects: dep pre-mobject-info $(OBJ)
	@echo "--------------------------------------------------------------------------------"
	@echo "Motion object files compiled."
	@echo
	
pre-mobject-info:
	@echo "Compiling Motion object files..."
	@echo "--------------------------------------------------------------------------------"

################################################################################
# Define the compile command for C files.                                      #
################################################################################
#%.o: %.c
#	@echo -e "\tCompiling $< into $@..."
#	@$(CC) -c $(CFLAGS) $< -o $@
#$(OBJDIR)/%.o: %.c
#	@echo -e "\tCompiling $< into $@..."
#	$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<

################################################################################
# Include the dependency file if it exists.                                    #
################################################################################
ifeq ($(DEPEND_FILE), $(wildcard $(DEPEND_FILE)))
ifeq (,$(findstring clean,$(MAKECMDGOALS)))
-include $(DEPEND_FILE)
endif
endif

##########################################
# MOTION For RASPBERRY PI CROSS COMPILATION
#####################################
larmotion-rpi: motion-objects-rpi
	@echo "Linking Motion for raspberry pi..."
	@echo "--------------------------------------------------------------------------------"
	$(CCRPI) $(LDFLAGS_RPI) -o $(addprefix $(OBJDIR)/, $@) $(OBJ) $(LIBS)
	@echo "--------------------------------------------------------------------------------"
	@echo "Motion for RPI has been linked ."
	@echo

motion-objects-rpi: dep-rpi pre-mobject-info-rpi $(OBJ)
	@echo "--------------------------------------------------------------------------------"
	@echo "Motion for RPI object files compiled."
	@echo

pre-mobject-info-rpi:
	@echo "Compiling Motion for RPI object files..."
	@echo "--------------------------------------------------------------------------------"
################################################################################
# Define the compile command for C files.                                      #
################################################################################
#%.o: %.c
#	@echo -e "\tCompiling $< into $@..."
#	@$(CC) -c $(CFLAGS) $< -o $@
$(OBJDIR)/%.o: %.c
	@echo -e "\tCompiling $< into $@..."
	$(CCRPI) $(CFLAGSRPI) $(CPPFLAGS) -c -o $@ $<

################################################################################
# Include the dependency file if it exists.                                    #
################################################################################
ifeq ($(DEPEND_FILE_RPI), $(wildcard $(DEPEND_FILE_RPI)))
ifeq (,$(findstring clean,$(MAKECMDGOALS)))
-include $(DEPEND_FILE_RPI)
endif
endif




################################################################################
# Make the dependency file depend on all header files and all relevant source  #
# files. This forces the file to be re-generated if the source/header files    #
# change. Note, however, that the existing version will be included before     #
# re-generation.                                                               #
################################################################################
	
$(DEPEND_FILE): *.h $(SRC)
	@echo "Generating dependencies into $@, please wait..."
	@$(CC) $(CFLAGS) -M $(SRC) -o $@ > .tmp 
	@mv -f .tmp $(DEPEND_FILE)
	@echo

	
$(DEPEND_FILE_RPI): *.h $(SRC)
	@echo "Generating dependencies for RPI into $@, please wait..."
	@$(CCRPI) $(CFLAGSRPI) -M $(SRC) -o $@ > .tmp 
	@mv -f .tmp $(DEPEND_FILE_RPI)
	@echo


################################################################################
# DEP, DEPEND and FASTDEP generate the dependency file.                        #
################################################################################
dep depend fastdep: $(DEPEND_FILE)

################################################################################
# DEP, DEPEND and FASTDEP generate the dependency file FOR RPI.                #
################################################################################
dep-rpi depend-rpi fastdep-rpi: $(DEPEND_FILE_RPI)


################################################################################
# DEV, BUILD with developer flags                                              #
################################################################################
dev: distclean autotools all

################################################################################
# DEV-GIT, BUILD with developer flags                                          #
################################################################################
dev-git: distclean autotools-git all


################################################################################
# GIT, BUILD with developer flags                                              #
################################################################################
build-commit-git: distclean set-version-git all

################################################################################
# CURRENT, BUILD current svn trunk.                                            #
################################################################################
current: distclean svn autotools all

svn:
	svn update

autotools:
	@sed -i 's/.\/commit-version.sh/.\/version.sh/g' configure.in
	autoconf
	./configure --with-developer-flags 

autotools-git:
	@sed -i 's/.\/git-commit-version.sh/.\/version.sh/g' configure.in
	autoconf
	./configure --with-developer-flags 


build-commit: distclean svn set-version all

set-version:
	@sed -i 's/.\/version.sh/.\/commit-version.sh/g' configure.in
	autoconf
	@sed -i 's/.\/commit-version.sh/.\/version.sh/g' configure.in
	./configure --with-developer-flags

set-version-git:
	@sed -i 's/.\/version.sh/.\/git-commit-version.sh/g' configure.in
	autoconf
	@sed -i 's/.\/git-commit-version.sh/.\/version.sh/g' configure.in
	./configure --with-developer-flags


help:
	@echo "--------------------------------------------------------------------------------"
	@echo "make                   Build motion from local copy in your computer"
	@echo "make rpi               Cross Build motion from local copy in your computer for RPI 2"		
	@echo "make current           Build last version of motion from svn"
	@echo "make dev               Build motion with dev flags"
	@echo "make dev-git           Build motion with dev flags for git"
	@echo "make build-commit      Build last version of motion and prepare to commit to svn"
	@echo "make build-commit-git  Build last version of motion and prepare to commit to git"
	@echo "make clean             Clean objects" 
	@echo "make distclean         Clean everything"	
	@echo "make install           Install binary , examples , docs and config files"
	@echo "make uninstall         Uninstall all installed files"
	@echo "--------------------------------------------------------------------------------"
	@echo

################################################################################
# INSTALL installs all relevant files.                                         #
################################################################################
install:
	@echo "Installing files..."
	@echo "--------------------------------------------------------------------------------"
	mkdir -p $(DESTDIR)$(bindir)
	mkdir -p $(DESTDIR)$(mandir)/man1
	mkdir -p $(DESTDIR)$(sysconfdir)
	mkdir -p $(DESTDIR)$(docdir)
	mkdir -p $(DESTDIR)$(examplesdir)
	$(INSTALL) motion.1 $(DESTDIR)$(mandir)/man1
	$(INSTALL) $(DOC) $(DESTDIR)$(docdir)
	$(INSTALL) $(EXAMPLES) $(DESTDIR)$(examplesdir)
	$(INSTALL) motion-dist.conf $(DESTDIR)$(sysconfdir)
	for prog in $(PROGS); \
	do \
	($(INSTALL) $$prog $(DESTDIR)$(bindir) ); \
	done
	@echo "--------------------------------------------------------------------------------"
	@echo "Install complete! The default configuration file, motion-dist.conf, has been"
	@echo "installed to $(sysconfdir). You need to rename/copy it to $(sysconfdir)/motion.conf"
	@echo "for Motion to find it. More configuration examples as well as init scripts"
	@echo "can be found in $(examplesdir)."
	@echo

################################################################################
# UNINSTALL and REMOVE uninstall already installed files.                      #
################################################################################
uninstall remove: pre-build-info
	@echo "Uninstalling files..."
	@echo "--------------------------------------------------------------------------------"
	for prog in $(PROGS); \
	do \
		($ rm -f $(bindir)/$$prog ); \
	done
	rm -f $(mandir)/man1/motion.1
	rm -f $(sysconfdir)/motion-dist.conf
	rm -rf $(docdir)
	rm -rf $(examplesdir)
	@echo "--------------------------------------------------------------------------------"
	@echo "Uninstall complete!"
	@echo

################################################################################
# CLEAN is basic cleaning; removes object files and executables, but does not  #
# remove files generated from the configure step.                              #
################################################################################
clean: pre-build-info
	@echo "Removing compiled files and binaries..."
	@rm -f *~ *.jpg *.o $(PROGS) combine $(DEPEND_FILE)

################################################################################
# DIST restores the directory to distribution state.                           #
################################################################################
dist: distclean updateguide
	@chmod -R 644 *
	@chmod 755 configure
	@chmod 755 version.sh

################################################################################
# DISTCLEAN removes all files generated during the configure step in addition  #
# to basic cleaning.                                                           #
################################################################################
distclean: clean
	@echo "Removing files generated by configure..."
	@rm -f config.status config.log config.cache Makefile motion.init-Fedora motion.init-Debian motion.init-FreeBSD.sh
	@rm -f thread1.conf thread2.conf thread3.conf thread4.conf motion-dist.conf motion-help.conf motion.spec
	@rm -rf autom4te.cache config.h
	@echo "You will need to re-run configure if you want to build Motion."
	@echo

################################################################################
# UPDATEGUIDE downloads the Motion Guide from TWiki.                           #
################################################################################
updateguide: pre-build-info
	@echo "Downloading Motion Guide. If it fails, please check your Internet connection."
	@echo
	wget www.lavrsen.dk/twiki/bin/view/Motion/MotionGuideOneLargeDocument?skin=text -O motion_guide.tmp
	@echo "Cleaning up and fixing links..."
	@cat motion_guide.tmp | sed -e 's/\?skin=text//g;s,"/twiki/,"http://www.lavrsen.dk/twiki/,g' > motion_guide.html
	@rm -f motion_guide.tmp
	@echo "All done, you should now have an up-to-date local copy of the Motion guide."
	@echo
