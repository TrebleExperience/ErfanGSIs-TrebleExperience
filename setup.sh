#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu" ]]; then
    distro=$(awk -F= '$1 == "ID" {print $2}' /etc/os-release)
    if [[ "$distro" == "arch" ]]; then
       echo "-> Arch Linux Detected"
       sudo pacman -S --needed unace unrar zip unzip p7zip sharutils uudeview arj cabextract file-roller dtc xz python-pip brotli lz4 gawk libmpack aria2
    else
       echo " - Starting the installation of packages"
       sudo apt install unace unrar zip unzip p7zip-full p7zip-rar sharutils rar uudeview mpack arj cabextract build-essential file-roller device-tree-compiler liblzma-dev python-pip brotli liblz4-tool gawk aria2 rename python3-setuptools python-setuptools -y
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "-> Darwin Detected". 
    echo " - Starting the installation of packages"
    brew install protobuf xz brotli lz4 aria2
fi

# Pip things
pip install -U setuptools; pip3 install -U setuptools
pip install backports.lzma protobuf pycrypto google
pip3 install backports.lzma protobuf pycrypto google

sudo chmod -R +x *
sudo chmod -R 0777 *
