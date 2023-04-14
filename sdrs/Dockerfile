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
    # NVIDIA dependencies
    gnupg2 curl ca-certificates \
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

# fix for hanging tzdata package configuration
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
RUN echo $TZ > /etc/timezone && exit

############
#  NVIDIA  #
############

WORKDIR /root
RUN \
    curl -fsSLO https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring_1.0-1_all.deb && \
    apt-key del 7fa2af80

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends cuda-cudart-11-8 cuda-compat-11-8
RUN ln -s cuda-11.8 /usr/local/cuda

# Required for nvidia-docker v1
RUN \
    echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV \
    PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64 \
    NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility

#################################
#  MAKE DIRECTORY FOR SOFTWARE  #
#################################

USER $USER
RUN mkdir -p /home/$USER/foss

#########
#  UHD  #
#########

WORKDIR /home/$USER/foss

RUN \
    git clone https://github.com/EttusResearch/uhd && cd uhd && git checkout v4.4.0.0 && \
    mkdir /home/$USER/foss/uhd/host/build && \
    cd /home/$USER/foss/uhd/host/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

RUN sudo /usr/local/lib/uhd/utils/uhd_images_downloader.py

##########
#  FTDI  #
##########
# (for Signal Hound SDK)

WORKDIR /home/$USER/foss
RUN \
    wget https://ftdichip.com/wp-content/uploads/2022/07/libftd2xx-x86_64-1.4.27.tgz && \
    tar zxvf libftd2xx-x86_64-1.4.27.tgz --one-top-level

WORKDIR /home/$USER/foss/libftd2xx-x86_64-1.4.27/release
RUN \
    sudo cp ftd2xx.h /usr/include/ && \
    sudo cp WinTypes.h /usr/include/ && \
    sudo ldconfig && \
    sudo cp build/libftd2xx.* /usr/lib/ && \
    sudo chmod 0755 /usr/lib/libftd2xx.so.1.4.27 && \
    sudo ln -sf /usr/lib/libftd2xx.so.1.4.27 /usr/lib/libftd2xx.so

######################
#  SIGNAL HOUND SDK  #
######################

WORKDIR /home/$USER/foss
RUN \
    wget https://signalhound.com/download/bbsa-application-programming-interface-for-windows-3264-bit/ -O signal_hound_sdk.zip && \
    unzip signal_hound_sdk.zip

WORKDIR /home/$USER/foss/signal_hound_sdk/device_apis/bb_series/include
RUN sudo cp bb_api.h /usr/include/

WORKDIR /home/$USER/foss/signal_hound_sdk/device_apis/bb_series/lib/linux/Ubuntu\ 18.04/
RUN \
    sudo ldconfig -v -n . && \
    ln -sf libbb_api.so.5.0.5 libbb_api.so && \
    sudo cp libbb_api.* /usr/lib/

##########
#  DONE  #
##########

WORKDIR /home/$USER
RUN uhd_config_info --version
