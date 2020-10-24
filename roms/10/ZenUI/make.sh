#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# build.prop
#echo "ro.bluetooth.library_name=libbluetooth_qti.so" >> $1/build.prop

# Custom files
cp -fpr $thispath/lib64/* $1/lib64/

# Fix audio
model=$(sed -n 's/^ro.build.product=[[:space:]]*//p' "$1/build.prop")
size=${#model}
for n in $(seq $size);
do
    new=$new'\x00'
done
sed -i "s/audio_policy_configuration_$model.xml/audio_policy_configuration.xml\x00$new/" "$1/lib/libaudiopolicymanagerdefault.so"
sed -i "s/audio_policy_configuration_$model.xml/audio_policy_configuration.xml\x00$new/" "$1/lib64/libaudiopolicymanagerdefault.so"
sed -i "s/audio_policy_configuration_$model.xml/audio_policy_configuration.xml\x00$new/" "$1/lib/libaudiopolicyenginedefault.so"
sed -i "s/audio_policy_configuration_$model.xml/audio_policy_configuration.xml\x00$new/" "$1/lib64/libaudiopolicyenginedefault.so"

# Wifi fix
cp -fpr $thispath/bin/* $1/bin/
cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh

# get vendor overlay (fix call old devices)
"$thispath/../../../zip2img.sh" "$FIRMWARE_PATH" "$thispath/../../../working/" "-v"
vendorpath="$thispath/../../../working/vendor"
mkdir $vendorpath
sudo mount $thispath/../../../working/vendor.img $vendorpath
cp -frp $vendorpath/overlay/TelephonyResCommon.apk $1/product/overlay/VendorTelephonyResCommon.apk
sudo umount $vendorpath
