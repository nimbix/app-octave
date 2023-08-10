FROM ubuntu:jammy
LABEL maintainer="Nimbix, Inc." \
      license="BSD"

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20230620.1000}

ARG OCTAVE_VERSION=8.3.0
ENV OCTAVE_VERSION=$OCTAVE_VERSION

# Install image-common tools and desktop
WORKDIR /tmp
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y curl ca-certificates && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/jarvice-desktop/master/install-nimbix.sh \
        | bash

WORKDIR /opt
RUN apt-get -y update && \
    apt-get -y install \
        binutils \
        build-essential \
        gfortran \
        libarpack2-dev \
        libbison-dev \
        libblas-dev \
        libbz2-dev \
        libcurl4 \
        libfftw3-dev \
        libfltk1.1-dev \
        libglpk-dev \
        libgraphicsmagick++1-dev \
        libhdf5-dev \
        liblapack-dev \
        libpcre3-dev \
        libqhull-dev \
        libqrupdate-dev \
        libqscintilla2-qt5-dev \
        libqt5gui5 \
        libqt5help5 \
        libqt5network5 \
        libqt5printsupport5 \
        libqt5xml5 \
        libreadline-dev \
        libsndfile1-dev \
        libsundials-dev \
        libxi-dev \
        openjdk-17-jdk \
        pkg-config \
        portaudio19-dev \
        qtbase5-dev \
        qttools5-dev \
        rapidjson-dev \
        texinfo  && \
    wget https://mirror.koddos.net/gnu/octave/octave-${OCTAVE_VERSION}.tar.gz && \
    tar xzf octave-${OCTAVE_VERSION}.tar.gz && \
    rm -rf octave-${OCTAVE_VERSION}.tar.gz && \
    cd octave-${OCTAVE_VERSION} && \
    ./configure && \
    make -j16 && make install && make clean

COPY scripts /usr/local/scripts

COPY NAE/screenshot.png /etc/NAE/screenshot.png
COPY NAE/AppDef-versioned.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://cloud.nimbix.net/api/jarvice/validate

RUN mkdir -p /etc/NAE && touch /etc/NAE/{screenshot.png,screenshot.txt,license.txt,AppDef.json}

# # # For testing locally
# # Add nimbix user
# RUN useradd --shell /bin/bash nimbix
# RUN mkdir -p /home/nimbix/
# RUN mkdir -p /data

# # Have all files be owned by nimbix user
# RUN chown -R nimbix:nimbix /home/nimbix
# RUN chown -R nimbix:nimbix /data

# # Add user to sudo group and make them passwordless
# RUN usermod -aG sudo nimbix
# RUN echo "nimbix    ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
