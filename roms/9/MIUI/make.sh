#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# build.prop
#cp -fpr $thispath/build.prop $1/
#echo "ro.bluetooth.library_name=libbluetooth_qti.so" >> $1/build.prop

# drop finddevice, needs to be done before copying system files
rm -rf $1/priv-app/FindDevice

# Copy system files
rsync -ra $thispath/system/ $systempath

# AOSP libs
cp -fpr $thispath/lib/* $1/lib/
cp -fpr $thispath/lib64/* $1/lib64/
cp -fpr $thispath/init/* $1/etc/init/
cp -fpr $thispath/overlay/* $1/product/overlay/

# drop caf permissions
rm -rf $1/etc/permissions/qti_permissions.xml
# drop dirac
rm -rf $1/priv-app/DiracAudioControlService
# remove phh qtiaudio
rm -rf $1/priv-app/QtiAudio
# drop FingerprintExtensionService
rm -rf $1/app/FingerprintExtensionService
# drop nfc
rm -rf $1/app/NQNfcNci

cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh

sed -i 's/<bool name="support_round_corner">true/<bool name="support_round_corner">false/' $1/etc/device_features/*

sed -i "/miui.notch/d" $1/build.prop

# workaround for MIUI v11 on some devices
if grep -iq ro.miui.ui.version.name=V11 $1/build.prop;then
    echo "MIUI V11 Detected, make device provisioned on init"
    
    # device is already provisioned on init
    # removing these apps
    rm -rf $1/priv-app/Provision
    rm -rf $1/priv-app/dpmserviceapp
    
    # add settings put secure user_setup_complete 1
    # add settings put global device_provisioned 1
    # on boot.init.miui.rc to set these variables to true on boot
    sed -i 's/boot_completed=1/boot_completed=1\n    # force \"provision and usersetup\" to be true on boot complete\n    exec \- root \-\- \/system\/bin\/sh \-c \"settings put secure user_setup_complete 1 \&\& settings put global device_provisioned 1\"/' $1/etc/init/boot.init.miui.rc

fi

# workaround for MIUI v12 on some devices

if grep -iq ro.miui.ui.version.name=V12 $1/build.prop;then

    echo "MIUI V12 Detected, make device provisioned on init"

    # device is already provisioned on init
    # removing these apps
    rm -rf $1/priv-app/Provision
    rm -rf $1/priv-app/dpmserviceapp

    # add settings put secure user_setup_complete 1
    # add settings put global device_provisioned 1
    # on boot.init.miui.rc to set these variables to true on boot
    sed -i 's/boot_completed=1/boot_completed=1\n    # force \"provision and usersetup\" to be true on boot complete\n    exec \- root \-\- \/system\/bin\/sh \-c \"settings put secure user_setup_complete 1 \&\& settings put global device_provisioned 1\"/' $1/etc/init/boot.init.miui.rc

fi
