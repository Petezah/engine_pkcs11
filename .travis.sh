#!/bin/sh
set -e
#
# Copyright (c) 2016 Michał Trojnara <Michal.Trojnara@stunnel.org>
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

install_from_github() {
    echo "Installing $2"
    git clone https://github.com/$1/$2.git
    cd $2
    git checkout $3
    autoreconf -fvi
    ./configure
    make
    sudo -E make install
    cd ..
    echo "$2 installed"
    sudo ldconfig
}

# ppa:pkg-opendnssec provides a less-obsolete softhsm
sudo apt-add-repository -y ppa:pkg-opendnssec/ppa
sudo apt-get update -qq
# libpcsclite-dev is required for OpenSC
# softhsm is required for "make check"
sudo apt-get install -y libpcsclite-dev softhsm

export CC=`which $CC`
mkdir prerequisites
cd prerequisites
install_from_github OpenSC OpenSC 0.16.0
install_from_github OpenSC libp11 22de793340ab73cafc92f8238afb51a06d8411c3
cd ..
rm -rf prerequisites
