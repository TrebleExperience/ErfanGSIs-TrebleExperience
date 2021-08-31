#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Disable ICCC (PS: This will break Secure Folder)
sed -i "/ro.config.iccc_version/d" $1/build.prop
echo "ro.config.iccc_version=iccc_disabled" >> $1/build.prop

# Always force disable dm-verity (Needed on A20s for example)
# PS: You need to drop avb things in your vendor if necessary (you can check: https://android.stackexchange.com/questions/215800/how-to-disable-dm-verity-on-android-with-user-build-type-rom)
sed -i "/ro.config.dmverity/d" $1/build.prop
echo "ro.config.dmverity=false" >> $1/build.prop

# Disable useless security
sed -i "/ro.config.tima/d" $1/build.prop
sed -i "/ro.config.timaversion/d" $1/build.prop
echo "ro.config.tima=0" >> $1/build.prop
echo "ro.config.timaversion=0" >> $1/build.prop

# Disable secure
sed -i "/ro.secure/d" $1/build.prop
sed -i "/ro.secure/d" $1/etc/prop.default
echo "ro.secure=0" >> $1/build.prop
echo "ro.secure=0" >> $1/etc/prop.default

# Drop reboot_on_failure on apexd too
sed -i "/reboot_on_failure/d" $1/etc/init/apexd.rc

# Also drop avb stuff
rm -rf $1/../verity_key

# Drop useless recovery files inside
rm -rf $1/../init.recovery*

# Try to enable debugging
sed -i 's/persist.sys.usb.config=none/persist.sys.usb.config=adb/g' $1/build.prop
sed -i 's/ro.debuggable=0/ro.debuggable=1/g' $1/build.prop
sed -i 's/ro.adb.secure=1/ro.adb.secure=0/g' $1/build.prop
sed -i 's/persist.sys.usb.config=none/persist.sys.usb.config=adb/g' $1/system_ext/etc/build.prop
sed -i 's/ro.debuggable=0/ro.debuggable=1/g' $1/system_ext/etc/build.prop
sed -i 's/ro.adb.secure=1/ro.adb.secure=0/g' $1/system_ext/etc/build.prop
sed -i 's/persist.sys.usb.config=none/persist.sys.usb.config=adb/g' $1/product/etc/build.prop
sed -i 's/ro.debuggable=0/ro.debuggable=1/g' $1/product/etc/build.prop
sed -i 's/ro.adb.secure=1/ro.adb.secure=0/g' $1/product/etc/build.prop
echo "ro.force.debuggable=1" >> $1/product/etc/build.prop