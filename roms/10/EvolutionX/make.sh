#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

echo "ro.setupwizard.mode=DISABLED" >> $1/etc/prop.default
echo "qemu.hw.mainkeys=0" >> $1/etc/prop.default
