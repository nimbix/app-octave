FROM ubuntu:jammy
LABEL maintainer="Nimbix, Inc." \
      license="BSD"

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER ${SERIAL_NUMBER:-20221106.1000}

ARG OCTAVE_VERSION
ENV OCTAVE_VERSION 7.3.0

# Install image-common tools and desktop
WORKDIR /tmp
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update && \
    apt-get install -y curl ca-certificates && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/jarvice-desktop/master/install-nimbix.sh \
        | bash

WORKDIR /opt
RUN apt-get -y update && \
    apt-get -y install \
        gfortran libfftw3-dev libbz2-dev libhdf5-dev libglpk-dev libcurl4 libsndfile1-dev libarpack2-dev libqrupdate-dev libsundials-dev portaudio19-dev libgraphicsmagick++1-dev libqscintilla2-qt5-dev libfltk1.1-dev \
        libblas-dev \
        liblapack-dev \
        libqhull-dev \
        libpcre3-dev \
        pkg-config \
        texinfo \
        libqt5gui5 libqt5help5 libqt5xml5 libqt5network5 libqt5printsupport5 qtbase5-dev qttools5-dev \
        rapidjson-dev \
        libreadline-dev \
        binutils \
        build-essential \
        libxi-dev \
        libbison-dev \
        openjdk-17-jdk && \
    wget https://mirror.koddos.net/gnu/octave/octave-${OCTAVE_VERSION}.tar.gz && \
    tar xzf octave-${OCTAVE_VERSION}.tar.gz && \
    rm -rf octave-${OCTAVE_VERSION}.tar.gz && \
    cd octave-${OCTAVE_VERSION} && \
    ./configure && \
    make -j16 && make install && make clean

COPY scripts /usr/local/scripts

# RUN echo "exec /usr/bin/octave -W" >> /etc/profile.d/octave.sh

COPY NAE/screenshot.png /etc/NAE/screenshot.png
COPY NAE/AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://cloud.nimbix.net/api/jarvice/validate

RUN mkdir -p /etc/NAE && touch /etc/NAE/{screenshot.png,screenshot.txt,license.txt,AppDef.json}
