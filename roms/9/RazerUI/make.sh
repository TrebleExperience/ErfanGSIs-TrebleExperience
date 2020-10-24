#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Enable on-screen navbar once rom boots
echo "qemu.hw.mainkeys=0" >> $1/build.prop
