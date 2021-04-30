#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

cp -fpr $thispath/lib64/* $1/lib64/
cp -fpr $thispath/etc/* $1/etc/
cp -fpr $thispath/bin/* $1/bin/
cp -fpr $thispath/overlay/* $1/product/overlay/

# Custom Manifest   
python $thispath/../../../scripts/custom_manifest.py $thispath/../../../tmp/manifest.xml $thispath/manifest.xml $1/etc/vintf/manifest.xml
cp -fpr $thispath/../../../tmp/manifest.xml $1/etc/vintf/manifest.xml

# ZenUI things \/
# Fix audio
model=$(sed -n 's/^ro.build.product=[[:space:]]*//p' "$1/build.prop")
size=${#model}
for n in $(seq $size);
do
    new=$new'\x00'
done
sed -i "s/audio_policy_configuration_$model.xml/audio_policy_configuration.xml\x00$new/" "$1/lib/libaudiopolicymanagerdefault.so"
sed -i "s/audio_policy_configuration_$model.xml/audio_policy_configuration.xml\x00$new/" "$1/lib64/libaudiopolicymanagerdefault.so"
