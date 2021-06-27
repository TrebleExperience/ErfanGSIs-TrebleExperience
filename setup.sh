#!/bin/bash

set -e

if [ "${EUID}" -ne 0 ]; then
    echo "-> Run as root!"
    exit 1
fi

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    distro=$(awk -F= '$1 == "ID" {print $2}' /etc/os-release)
    if [[ ! "$distro" == "arch" ]]; then
        echo " - Starting the installation of packages"
        if $(sudo -E apt-get -qq install bc build-essential zip curl libstdc++6 git wget python gcc clang libssl-dev rsync flex bison ccache expect aria2 unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract file-roller device-tree-compiler liblzma-dev brotli liblz4-tool axel gawk aria2 detox cpio rename build-essential simg2img aria2 python3-pip tree >>./.apt 2>&1); then
            echo "-> Successfully installed."
            rm -rf "$(pwd)/.apt"
        else
            echo "-> Failed, here the log:"
            cat "$(pwd)/.apt"
            rm -rf "$(pwd)/.apt"
        fi
    elif [[ "$distro" == "arch" ]]; then
        echo " - Starting the installation of packages"
        if $(sudo pacman -Sy --noconfirm unace unrar zip unzip p7zip sharutils uudeview arj cabextract dtc python-pip brotli axel gawk aria2 detox cpio expect tree python-setuptools jdk8-openjdk >>./.pacman 2>&1); then
            echo "-> Successfully installed."
            rm -rf "$(pwd)/.pacman"
        else
            echo "-> Failed, here the log:"
            cat "$(pwd)/.pacman"
            rm -rf "$(pwd)/.pacman"
        fi
    else
        echo "-> Your $distro distro seems not supported, try making a issue on GitHub."
        exit 1
    fi

    # pip moment
    echo " - Trying to install/update some python3 packages"
    if $(pip3 install wheel setuptools >> /dev/null 2>&1); then
        pip3 install wheel setuptools
        pip3 install backports.lzma docopt zstandard bsdiff4 protobuf pycrypto
        pip3 install --upgrade protobuf wheel setuptools
        echo "-> Successfully installed."
    else
        # Making user's life easy
        echo "-> Failed to install whell & setuptools packages, check this thread: https://unix.stackexchange.com/questions/547820/python-pip-is-broken"
    fi
fi
