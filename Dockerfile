FROM rockylinux:8
LABEL maintainer="Nimbix, Inc." \
      license="BSD"

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER=${SERIAL_NUMBER}

ARG OCTAVE_VERSION
ENV OCTAVE_VERSION=$OCTAVE_VERSION

# Install image-common tools and desktop
WORKDIR /tmp
RUN dnf install -y epel-release && dnf config-manager --set-enabled powertools && \
    dnf -y update && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/jarvice-desktop/master/install-nimbix.sh \
        | bash

RUN dnf install -y \
        btop htop \
        gnutls-devel \
        icoutils \
        librsvg2-tools \
        xdg-utils \
        yum-utils && \
    yum-builddep -y octave

WORKDIR /opt
RUN curl -L https://mirror.koddos.net/gnu/octave/octave-${OCTAVE_VERSION}.tar.gz | tar xz && \
    mkdir -p octave-${OCTAVE_VERSION}/BUILD && \
    cd octave-${OCTAVE_VERSION}/BUILD && \
    CC=/opt/rh/gcc-toolset-13/root/bin/gcc \
    CXX=/opt/rh/gcc-toolset-13/root/bin/g++ \
    CFLAGS="-mtune=generic -march=x86-64-v3 -O2" \
    CXXFLAGS="-mtune=generic -march=x86-64-v3 -O2" \
    LDFLAGS="-flto=auto" \
    ../configure && \
    make -j16 | tee -a build.log && make install | tee -a install.log && make clean

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
