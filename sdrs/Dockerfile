FROM ubuntu:22.04

ARG USER
ARG UID
ARG GID
ARG TZ

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    # user packages
    sudo \
    # SDRplay dependencies
    git build-essential cmake libsoapysdr-dev soapysdr-tools usbutils udev \
    # UHD dependencies
    autoconf automake build-essential ccache cmake cpufrequtils doxygen ethtool g++ git inetutils-tools \
    libboost-all-dev libncurses5 libncurses5-dev libusb-1.0-0 libusb-1.0-0-dev libusb-dev python3-dev \
    python3-mako python3-numpy python3-requests python3-scipy python3-setuptools python3-ruamel.yaml \
    # FTDI dependencies
    wget unzip

###########################
#  USER WITH SUDO ACCESS  #
###########################

RUN \
    useradd -rm -d /home/$USER -s /bin/bash -g 100 -G sudo -u $UID $USER && \
    groupadd -g $GID $USER && \
    echo "$USER ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/dont-prompt-$USER-for-sudo-password"

#################################
#  MAKE DIRECTORY FOR SOFTWARE  #
#################################

USER $USER
RUN mkdir -p /home/$USER/foss

####################
#  SDRplay RSPxxx  #
####################

WORKDIR /home/$USER/foss

RUN \
    cd /home/$USER/foss && \
    git clone https://github.com/ziflabs/sdrplay-api-linux-docker && \
    cd /home/$USER/foss/sdrplay-api-linux-docker && ./install_lib_DOCKER.sh && \
    cd /home/$USER/foss && \
    git clone https://github.com/pothosware/SoapySDRPlay.git && \
    mkdir /home/$USER/foss/SoapySDRPlay/build && \
    cd /home/$USER/foss/SoapySDRPlay/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

#########
#  UHD  #
#########

RUN \
    cd /home/$USER/foss && \
    git clone https://github.com/EttusResearch/uhd && cd uhd && git checkout v4.4.0.0 && \
    mkdir /home/$USER/foss/uhd/host/build && \
    cd /home/$USER/foss/uhd/host/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig && \
    sudo /usr/local/lib/uhd/utils/uhd_images_downloader.py

##########
#  FTDI  #
##########
# (for Signal Hound SDK)

RUN \
    cd /home/$USER/foss && \
    wget https://ftdichip.com/wp-content/uploads/2022/07/libftd2xx-x86_64-1.4.27.tgz && \
    tar zxvf libftd2xx-x86_64-1.4.27.tgz --one-top-level

RUN \
    cd /home/$USER/foss/libftd2xx-x86_64-1.4.27/release && \
    sudo cp ftd2xx.h /usr/include/ && \
    sudo cp WinTypes.h /usr/include/ && \
    sudo ldconfig && \
    sudo cp build/libftd2xx.* /usr/lib/ && \
    sudo chmod 0755 /usr/lib/libftd2xx.so.1.4.27 && \
    sudo ln -sf /usr/lib/libftd2xx.so.1.4.27 /usr/lib/libftd2xx.so

######################
#  SIGNAL HOUND SDK  #
######################
 
RUN \
    cd /home/$USER/foss && \
    wget https://signalhound.com/download/bbsa-application-programming-interface-for-windows-3264-bit/ -O signal_hound_sdk.zip && \
    unzip signal_hound_sdk.zip
 
RUN \
    cd /home/$USER/foss/signal_hound_sdk/device_apis/bb_series/include && \
    sudo cp bb_api.h /usr/include/
 
RUN \
    cd /home/$USER/foss/signal_hound_sdk/device_apis/bb_series/lib/linux/Ubuntu\ 18.04/ && \
    sudo ldconfig -v -n . && \
    ln -sf libbb_api.so.5.0.5 libbb_api.so && \
    sudo cp libbb_api.* /usr/lib/

##########
#  DONE  #
##########

WORKDIR /home/$USER
