FROM sdrs

ARG USER

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
    # user packages
    net-tools vim wget \
    # GNU Radio dependencies
    git cmake g++ libboost-all-dev libgmp-dev swig python3-numpy python3-mako python3-sphinx python3-lxml doxygen libfftw3-dev \
    libsdl1.2-dev libgsl-dev libqwt-qt5-dev libqt5opengl5-dev python3-pyqt5 liblog4cpp5-dev libzmq3-dev python3-yaml python3-click \
    python3-click-plugins python3-zmq python3-scipy python3-gi python3-gi-cairo gir1.2-gtk-3.0 libcodec2-dev libgsm1-dev \
    pybind11-dev python3-matplotlib libsndfile1-dev python3-pip libsoapysdr-dev soapysdr-tools libiio-dev libad9361-dev libspdlog-dev \
    python3-packaging python3-jsonschema castxml clang-format \
    # gr-sigmf dependencies
    rapidjson-dev \
    # gr-fosphor dependencies
    cmake xorg-dev libglu1-mesa-dev nvidia-driver-530 nvidia-opencl-dev opencl-headers clinfo nvidia-modprobe

RUN sudo -H pip install -U pip pygccxml pyqtgraph


########
# VOLK #
########

WORKDIR /home/$USER/foss

RUN \
    git clone https://github.com/gnuradio/volk && cd volk && git checkout v3.0.0 && git submodule update --init && \
    mkdir /home/$USER/foss/volk/build && \
    cd /home/$USER/foss/volk/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

RUN volk_profile

###############
#  GNU Radio  #
###############

WORKDIR /home/$USER/foss

RUN \
    git clone https://github.com/gnuradio/gnuradio && cd gnuradio && git checkout v3.10.6.0 && \
    mkdir /home/$USER/foss/gnuradio/build && \
    cd /home/$USER/foss/gnuradio/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 .. && \
    make -j$(nproc) && sudo make install && sudo ldconfig && \
    # fix to make sure GNU Radio Companion launches correctly
    echo "export PYTHONPATH=/usr/local/lib/python3/dist-packages:/usr/local/lib/python3/site-packages:$PYTHONPATH" >> /home/$USER/.bashrc

###############
#  gr-shbb60  #
###############

WORKDIR /home/$USER/foss

RUN \
    git clone https://github.com/herrameise/gr-shbb60 && \
    mkdir /home/$USER/foss/gr-shbb60/build && \
    cd /home/$USER/foss/gr-shbb60/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

##############
#  gr-sigmf  #
##############

WORKDIR /home/$USER/foss

RUN \
    git clone https://github.com/skysafe/gr-sigmf && \
    mkdir /home/$USER/foss/gr-sigmf/build && \
    cd /home/$USER/foss/gr-sigmf/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

##################
#  gr-pdu_utils  #
##################

WORKDIR /home/$USER/foss


RUN \
    # git clone https://github.com/sandialabs/gr-pdu_utils
    # until Sandia Labs accepts the pull request
    git clone https://github.com/gunawanw9/gr-pdu_utils && \
    mkdir gr-pdu_utils/build && \
    cd /home/$USER/foss/gr-pdu_utils/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

#####################
#  gr-sandia_utils  #
#####################

WORKDIR /home/$USER/foss

RUN \
    git clone https://github.com/sandialabs/gr-sandia_utils && \
    mkdir gr-sandia_utils/build && \
    cd /home/$USER/foss/gr-sandia_utils/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

#####################
#  gr-timing_utils  #
#####################

WORKDIR /home/$USER/foss

RUN \
    git clone https://github.com/sandialabs/gr-timing_utils && \
    mkdir gr-timing_utils/build && \
    cd /home/$USER/foss/gr-timing_utils/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

###################
#  gr-fhss_utils  #
###################

WORKDIR /home/$USER/foss

RUN \
    git clone https://github.com/sandialabs/gr-fhss_utils && \
    mkdir gr-fhss_utils/build && \
    cd /home/$USER/foss/gr-fhss_utils/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

################
#  gr-fosphor  #
################

WORKDIR /home/$USER/foss

RUN \
    git clone https://github.com/glfw/glfw && \
    cd /home/$USER/foss/glfw && \
    mkdir build && cd build && cmake ../ -DBUILD_SHARED_LIBS=true && make -j$(nproc) && sudo make install && sudo ldconfig

WORKDIR /home/$USER/foss
RUN \
    git clone https://gitea.osmocom.org/sdr/gr-fosphor.git && \
    cd /home/$USER/foss/gr-fosphor && \
    mkdir build && cd build && cmake ../ -DBUILD_SHARED_LIBS=true && make -j$(nproc) && sudo make install && sudo ldconfig

# this has to be run as root for some reason ...
USER root
RUN mkdir -p /etc/OpenCL/vendors && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
USER $USER

################
#  FLOWGRAPHS  #
################

RUN mkdir -p /home/$USER/flowgraphs
COPY flowgraphs/test_b200.grc /home/$USER/flowgraphs/test_b200.grc
COPY flowgraphs/test_fosphor.grc /home/$USER/flowgraphs/test_fosphor.grc
COPY flowgraphs/test_signalhound.grc /home/$USER/flowgraphs/test_signalhound.grc

##########
#  DONE  #
##########

WORKDIR /home/$USER
