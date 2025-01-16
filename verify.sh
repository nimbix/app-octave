#!/usr/bin/env bash

# Get latest image
IMAGE=$(podman images | grep octave | grep -v localhost | head -n1 | awk '{print $1 ":" $2}')

if [[ -z $IMAGE ]]; then
    echo "ERROR: Octave image not found..."
    exit 1
fi

echo "INFO: Found Image -> $IMAGE"

podman run -it --rm --shm-size=16g -p 5902:5902 --entrypoint=bash "$IMAGE" -ec "
    useradd --shell /bin/bash nimbix
    usermod -aG root nimbix
    mkdir -p /home/nimbix/
    mkdir -p /data
    chown -R nimbix:nimbix /home/nimbix
    chown -R nimbix:nimbix /data
    mkdir -p /etc/JARVICE
    echo 127.0.0.1 > /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 >> /etc/JARVICE/cores
    echo 127.0.0.1 > /etc/JARVICE/nodes
    chown -R nimbix:nimbix /etc/JARVICE
    echo JOB_NAME=Local_Testing >> /etc/JARVICE/jobinfo.sh
    su nimbix -c '
        cd \$HOME
        # /usr/local/scripts/octave-shell.sh
        /usr/local/bin/nimbix_desktop /usr/local/scripts/octave-gui.sh
    '
"
