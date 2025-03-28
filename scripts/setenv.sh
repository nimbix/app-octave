#!/usr/bin/env bash
# Copyright (c) 2025, Nimbix, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are
# those of the authors and should not be interpreted as representing official
# policies, either expressed or implied, of Nimbix, Inc.

# Need to add folders to the LD_LIBRARY_PATH
EXTRA_LD_PATH=/usr/lib:/usr/lib64:/usr/lib64/atlas:/usr/lib64/llvm17/lib
export LD_LIBRARY_PATH="$EXTRA_LD_PATH:$LD_LIBRARY_PATH"

mkdir -p "/data/AppConfig/octave/$OCTAVE_VERSION/config/octave"
mkdir -p "/data/AppConfig/octave/$OCTAVE_VERSION/local/octave"

mkdir -p "$HOME"/.config
mkdir -p "$HOME"/.local/share

ln -sf "/data/AppConfig/octave/$OCTAVE_VERSION/config/octave" "$HOME"/.config/
ln -sf "/data/AppConfig/octave/$OCTAVE_VERSION/local/octave" "$HOME"/.local/share/

# Enable gcc 14
# shellcheck disable=SC1091
. /opt/rh/gcc-toolset-14/enable

# Add octave to path
export PATH="/opt/octave/bin:$PATH"
echo "INFO: Starting $(octave --version 2>/dev/null | head -n1)"
