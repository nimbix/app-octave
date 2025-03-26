#!/usr/bin/env bash

set -e
set -x

OCTAVE_VERSION="$(echo "$1" | tr '.' '-')"

WORK_DIR="/tmp/install-$$"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR" || exit 1

curl -L "https://github.com/gnu-octave/octave/archive/refs/tags/release-$OCTAVE_VERSION.tar.gz" | tar xz --strip-components=1 --no-same-owner
mkdir -p BUILD

./bootstrap

cd BUILD || exit 1

CC=/opt/rh/gcc-toolset-14/root/bin/gcc \
CXX=/opt/rh/gcc-toolset-14/root/bin/g++ \
F77=/opt/rh/gcc-toolset-14/root/bin/gfortran \
CFLAGS="-mtune=generic -march=x86-64-v3 -O2" \
CXXFLAGS="-mtune=generic -march=x86-64-v3 -O2" \
FFLAGS="-mtune=generic -march=x86-64-v3 -O2" \
LDFLAGS="-flto=auto" \
../configure --prefix=/opt/octave --disable-rapidjson
make -j"$(nproc --ignore=2)"
make install

cd /tmp || exit 1
rm -rf "$WORK_DIR"
