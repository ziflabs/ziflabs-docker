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
    rapidjson-dev

RUN sudo -H pip install -U pip pygccxml pyqtgraph

########
# VOLK #
########

RUN \
    cd /home/$USER/foss && \
    git clone https://github.com/gnuradio/volk && cd volk && git checkout v3.0.0 && git submodule update --init && \
    mkdir /home/$USER/foss/volk/build && \
    cd /home/$USER/foss/volk/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig && \
    volk_profile

###############
#  GNU Radio  #
############### 

RUN \
    cd /home/$USER/foss && \
    git clone https://github.com/gnuradio/gnuradio && cd gnuradio && git checkout v3.10.7.0 && \
    mkdir /home/$USER/foss/gnuradio/build && \
    cd /home/$USER/foss/gnuradio/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DPYTHON_EXECUTABLE=/usr/bin/python3 .. && \
    make -j$(nproc) && sudo make install && sudo ldconfig && \
    # fix to make sure GNU Radio Companion launches correctly
    echo "export PYTHONPATH=/usr/local/lib/python3/dist-packages:/usr/local/lib/python3/site-packages:$PYTHONPATH" >> /home/$USER/.bashrc

#############
#  gr-bb60  #
#############

RUN \
    cd /home/$USER/foss && \
    git clone https://github.com/ziflabs/gr-bb60 && \
    mkdir /home/$USER/foss/gr-bb60/build && \
    cd /home/$USER/foss/gr-bb60/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

##############
#  gr-sigmf  #
##############

RUN \
    cd /home/$USER/foss && \
    git clone https://github.com/skysafe/gr-sigmf && \
    mkdir /home/$USER/foss/gr-sigmf/build && \
    cd /home/$USER/foss/gr-sigmf/build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

##################
#  gr-pdu_utils  #
##################

RUN \
    cd /home/$USER/foss && \
    git clone https://github.com/sandialabs/gr-pdu_utils && \
    cd /home/$USER/foss/gr-pdu_utils && git checkout maint-3.10 && \
    mkdir build && cd build && \
    cmake .. && make -j$(nproc) && sudo make install && sudo ldconfig

##########
#  DONE  #
##########

WORKDIR /home/$USER
