FROM centos:8
LABEL maintainer="Nimbix, Inc." \
      license="BSD"

RUN yum -y install epel-release && \
    yum -y install dnf-plugins-core && \
    yum config-manager --set-enabled PowerTools && \
    dnf -y install texinfo libqhull && \
    yum -y install octave && \
    yum clean all

COPY scripts /usr/local/scripts

COPY NAE/AppDef.json /etc/NAE/AppDef.json
RUN curl --fail -X POST -d @/etc/NAE/AppDef.json https://api.jarvice.com/jarvice/validate

COPY NAE/screenshot.png /etc/NAE/screenshot.png
