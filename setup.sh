#!/bin/bash

set -e

if [ "${EUID}" -ne 0 ]; then
    echo "-> Run as root!"
    exit 1
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    distro=$(awk -F= '$1 == "ID" {print $2}' /etc/os-release)
    if [[ ! "$distro" == "arch" && ! "$distro" == "darwin" ]]; then
        echo " - Starting the installation of packages"
        if $(sudo -E apt-get -qq install bc build-essential zip curl libstdc++6 git wget python gcc clang libssl-dev rsync flex bison ccache expect aria2 unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller device-tree-compiler liblzma-dev brotli liblz4-tool axel gawk aria2 detox cpio rename build-essential simg2img aria2 python3-pip tree >>./.apt 2>&1); then
            echo "-> Successfully installed."
            rm -rf "$(pwd)/.apt"
        else
            echo "-> Failed, here the log:"
            cat "$(pwd)/.apt"
            rm -rf "$(pwd)/.apt"
        fi

        # pip moment
        pip3 install wheel setuptools
        pip3 install backports.lzma docopt zstandard bsdiff4 protobuf pycrypto
        pip3 install --upgrade protobuf
    fi
fi
