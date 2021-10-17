#!/bin/bash

systempath=$1
romdir=$2
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Drop prebuilt fstab.postinstall
rm -rf $systempath/etc/fstab.postinstall

# Drop prebuilt apns-conf.xml
rm -rf $1/etc/apns-conf.xml

# Download apns-conf.xml from LineageOS
curl -s "https://raw.githubusercontent.com/LineageOS/android_vendor_lineage/lineage-18.1/prebuilt/common/etc/apns-conf.xml" > $1/etc/apns-conf.xml

# Also fix user/group name & chmod permission
chown root:root $1/etc/apns-conf.xml
chmod 0644 $1/etc/apns-conf.xml

# Patch for system
rsync -ra $thispath/system/ $systempath
rm -rf $1/etc/permissions/com.qti.dpmframework.xml

# Append file_context
cat $thispath/file_contexts >> $1/etc/selinux/plat_file_contexts

# Make logcat binary executable
sed -i "s/u:object_r:logcat_exec:s0/u:object_r:logd_exec:s0/g" $1/etc/selinux/plat_file_contexts

# Drop QCC thing (Always crashing)
rm -rf $1/system_ext/app/QCC*
rm -rf $1/system_ext/priv-app/QCC*
rm -rf $1/system_ext/lib/libqcc*.so

# Cleanup plat property
plat_property=$1/etc/selinux/plat_property_contexts
sed -i "/ro.opengles.version/d" $plat_property
sed -i "/sys.usb.configfs/d" $plat_property
sed -i "/sys.usb.controller/d" $plat_property
sed -i "/sys.usb.config/d" $plat_property
sed -i "/ro.build.fingerprint/d" $plat_property

# If the ROM supports getting vendor properties, we will get them.
if [ -f $romdir/SUPPORTSVENDORPROPS ]; then
    echo "-> Getting props from the vendor is allowed in this rom, trying to get them..."
    if [ -d $thispath/../../working/vendor ]; then
        bash $thispath/getVendorProps.sh $thispath/../../working/vendor $1 || true
    else
        echo " - Failed because the vendor seems unmounted."
    fi
fi

# Remove qti_permissions
find $systemdir -type f -name "qti_permissions.xml" | xargs rm -rf

# Remove firmware
find $systemdir -type d -name "firmware" | xargs rm -rf

# Remove avb
find $systemdir -type d -name "avb" | xargs rm -rf

# Remove com.qualcomm.location
find $systemdir -type d -name "com.qualcomm.location" | xargs rm -rf

# Drop prebuilt verity key (AVB)
rm -rf $1/../verity_key

# Drop some recovery stuff (useless)
rm -rf $1/../init.recovery*

# Drop recovery chunk (useless) (BSDIFF)
rm -rf $1/recovery-from-boot.*

# Drop reboot_on_failure
sed -i "/reboot_on_failure/d" $1/etc/init/hw/init.rc
sed -i "/reboot_on_failure/d" $1/etc/init/apexd.rc

# Drop ro.expect.recovery_id
sed -i "/ro.expect.recovery_id/d" $1/build.prop

# Append props
cat $thispath/build.prop >> $1/build.prop

# Append extra code to phh script
cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh

# Disable Actionable props
sed -i "/ro.actionable_compatible_property.enabled/d" $1/etc/prop.default
sed -i "/ro.actionable_compatible_property.enabled/d" $1/build.prop

# Drop dummy codes
sed -i "/sys.use_fifo_ui/d" $1/build.prop
sed -i "/debug.sf.latch_unsignaled/d" $1/build.prop

# Let's vendor decides it
sed -i "/ro.sys.fw.dex2oat_thread_count/d" $1/build.prop
sed -i "/dalvik.vm.boot-dex2oat-threads/d" $1/build.prop
sed -i "/dalvik.vm.dex2oat-threads/d" $1/build.prop
sed -i "/dalvik.vm.image-dex2oat-threads/d" $1/build.prop
sed -i "/dalvik.vm.dex2oat-filter/d" $1/build.prop
sed -i "/dalvik.vm.heapgrowthlimit/d" $1/build.prop
sed -i "/dalvik.vm.heapstartsize/d" $1/build.prop
sed -i "/dalvik.vm.heapsize/d" $1/build.prop
sed -i "/dalvik.vm.heaptargetutilization/d" $1/build.prop
sed -i "/dalvik.vm.heapminfree/d" $1/build.prop
sed -i "/dalvik.vm.heapmaxfree/d" $1/build.prop

# Disable vndk lite
if [[ -f $1/product/etc/build.prop ]]; then
    echo "ro.vndk.lite=false" >> $1/product/etc/build.prop
else
    echo "ro.vndk.lite=false" >> $1/etc/prop.default
    echo "ro.vndk.lite=false" >> $1/product/build.prop
fi

# Fix app missing
sed -i '/ro.opengles.version/d' -i $1/build.prop
echo "# You can nuke this if necessary" >> $1/build.prop
echo "ro.opengles.version=196610" >> $1/build.prop

# disable RescureParty
if [[ -f $1/product/etc/build.prop ]]; then
    echo "persist.sys.disable_rescue=true" >> $1/product/etc/build.prop
else
    echo "persist.sys.disable_rescue=true" >> $1/etc/prop.default
fi

# disable privapp_permissions checking
if [[ -f $1/product/etc/build.prop ]]; then
    echo "ro.control_privapp_permissions=disable" >> $1/product/etc/build.prop
else
    echo "ro.control_privapp_permissions=disable" >> $1/etc/prop.default
    echo "ro.control_privapp_permissions=disable" >> $1/product/build.prop
fi

# Use qti Bluetooth lib if avaliable
if [ -f $1/lib64/libbluetooth_qti.so ]; then
    echo "ro.bluetooth.library_name=libbluetooth_qti.so" >> $1/build.prop
fi

# Enable debugging
sed -i 's/persist.sys.usb.config=none/persist.sys.usb.config=adb/g' $1/build.prop
sed -i 's/ro.debuggable=0/ro.debuggable=1/g' $1/build.prop
sed -i 's/ro.adb.secure=1/ro.adb.secure=0/g' $1/build.prop

if [ -d "$1/system_ext" ]; then
    sed -i 's/persist.sys.usb.config=none/persist.sys.usb.config=adb/g' $1/system_ext/etc/build.prop
    sed -i 's/ro.debuggable=0/ro.debuggable=1/g' $1/system_ext/etc/build.prop
    sed -i 's/ro.adb.secure=1/ro.adb.secure=0/g' $1/system_ext/etc/build.prop
fi

sed -i 's/persist.sys.usb.config=none/persist.sys.usb.config=adb/g' $1/product/etc/build.prop
sed -i 's/ro.debuggable=0/ro.debuggable=1/g' $1/product/etc/build.prop
sed -i 's/ro.adb.secure=1/ro.adb.secure=0/g' $1/product/etc/build.prop
echo "ro.force.debuggable=1" >> $1/product/etc/build.prop

# cleanup build prop
if grep -q ADDITIONAL_BUILD_PROPERTIES $1/build.prop; then
    $thispath/../../scripts/propcleanner.sh $1/build.prop > $1/../../build.prop
    cp -fpr $1/../../build.prop $1/
fi
if grep -q post_process_props $1/product/etc/build.prop; then
    $thispath/../../scripts/propcleannerS.sh $1/product/etc/build.prop > $1/../../build.prop
    cp -fpr $1/../../build.prop $1/product/etc/
fi

# Fix FP touch issues for some meme devices
if [ -f $romdir/DONTPATCHFP ]; then
      echo "-> Patching Fingerprint touch is not supported in this ROM. Skipping..."
else
      rm -rf $1/usr/keylayout/uinput-fpc.kl
      rm -rf $1/usr/keylayout/uinput-goodix.kl
      touch $1/usr/keylayout/uinput-fpc.kl
      touch $1/usr/keylayout/uinput-goodix.kl
fi