#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Add missing c2 software xml
rsync -ra $thispath/system/ $systempath

# Fix systemui crash because of FOD
echo "ro.hardware.fp.fod=true" >> $1/build.prop
echo "persist.vendor.sys.fp.fod.location.X_Y=445,1260" >> $1/build.prop
echo "persist.vendor.sys.fp.fod.size.width_height=190,190" >> $1/build.prop

# Drop recovery-persist
rm -rf $1/etc/init/recovery-persist.rc

# Drop some things
sed -i 's/<bool name="support_round_corner">true/<bool name="support_round_corner">false/' $1/etc/device_features/*
sed -i "/ro.miui.notch/d" $1/build.prop
sed -i "/persist.miui.density_v2/d" $1/build.prop