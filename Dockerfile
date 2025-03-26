FROM rockylinux/rockylinux:8 as BUILDER
LABEL maintainer="Nimbix, Inc." \
      license="BSD"

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER=${SERIAL_NUMBER}

ARG OCTAVE_VERSION
ENV OCTAVE_VERSION=${OCTAVE_VERSION}

RUN dnf install epel-release -y && \
    crb enable && \
    dnf update -y && \
    dnf install -y \
        btop htop \
        gcc-toolset-14 \
        git \
        gnutls-devel \
        icoutils \
        librsvg2-tools \
        openblas \
        sundials \
        xdg-utils && \
    dnf builddep -y octave && dnf clean all

WORKDIR /tmp
COPY buildscripts /tmp/buildscripts
RUN /tmp/buildscripts/install-octave.sh ${OCTAVE_VERSION}

FROM rockylinux/rockylinux:8

# Update SERIAL_NUMBER to force rebuild of all layers (don't use cached layers)
ARG SERIAL_NUMBER
ENV SERIAL_NUMBER=${SERIAL_NUMBER}

ARG OCTAVE_VERSION
ENV OCTAVE_VERSION=${OCTAVE_VERSION}

# Install image-common tools and desktop
WORKDIR /tmp
RUN dnf install -y epel-release && dnf config-manager --set-enabled powertools && \
    dnf -y update && \
    curl -H 'Cache-Control: no-cache' \
        https://raw.githubusercontent.com/nimbix/jarvice-desktop/master/install-nimbix.sh \
        | bash

RUN dnf install -y \
        btop htop \
        gcc-toolset-14 \
        ncurses \
        ncurses-base \
        ncurses-term \
        sundials \
        $(dnf deplist octave | grep provider | grep -v curl | sort -u | awk '{print $2}') \
    && dnf clean all

COPY --from=BUILDER /opt/octave /opt/octave

RUN mkdir -p /usr/lib/dri && \
    ln -s /usr/lib64/swrast*.so /usr/lib/dri/. && \
    ln -s /usr/share/terminfo /lib/terminfo

COPY scripts /usr/local/scripts

COPY NAE/screenshot.png /etc/NAE/screenshot.png
COPY NAE/license.txt /etc/NAE/license.txt
COPY NAE/AppDef-versioned.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://cloud.nimbix.net/api/jarvice/validate

RUN mkdir -p /etc/NAE && touch /etc/NAE/{screenshot.png,screenshot.txt,license.txt,AppDef.json,swlicense.txt}
