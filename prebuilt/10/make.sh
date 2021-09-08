#!/bin/bash

systempath=$1
romdir=$2
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Drop apex prop
sed -i '/ro.apex.updatable/d' $1/build.prop
sed -i '/ro.apex.updatable/d' $1/product/build.prop

# Nuke dpi prop
sed -i 's/ro.sf.lcd/#&/' $1/build.prop
sed -i 's/ro.sf.lcd/#&/' $1/product/build.prop

# Always enable CdmaLTEPhone
sed -i '/telephony.lteOnCdmaDevice/d' $1/build.prop
sed -i '/telephony.lteOnCdmaDevice/d' $1/product/build.prop
echo "telephony.lteOnCdmaDevice=1" >> $1/build.prop
echo "telephony.lteOnCdmaDevice=1" >> $1/product/build.prop

# Drop some props (again)
sed -i '/vendor.display/d' $1/build.prop
sed -i '/vendor.perf/d' $1/build.prop
sed -i '/debug.sf/d' $1/build.prop
sed -i '/persist.sar.mode/d' $1/build.prop
sed -i '/opengles.version/d' $1/build.prop

# Drop VNDK prop inside product
sed -i '/product.vndk.version/d' $1/product/build.prop

# Drop CAF media.settings
sed -i '/media.settings.xml/d' $1/build.prop

# Drop control privapp permissions
sed -i '/ro.control_privapp_permissions/d' $1/build.prop
sed -i '/ro.control_privapp_permissions/d' $1/product/build.prop

# Deal with non-flattened apex
$thispath/../../scripts/apex_extractor.sh $1/apex
echo "ro.apex.updatable=false" >> $1/product/build.prop

# Copy system files
rsync -ra $thispath/system/ $systempath

cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh
echo "persist.bluetooth.bluetooth_audio_hal.disabled=true" >> $1/build.prop

# Append file_context
cat $thispath/file_contexts >> $1/etc/selinux/plat_file_contexts

# Disable Codec2
sed -i "s/android.hardware.media.c2/android.hardware.erfan.c2/g" $1/etc/vintf/manifest.xml
rm -rf $1/etc/vintf/manifest/manifest_media_c2_software.xml

# Fix vendor CAF sepolicies
$thispath/../../scripts/sepolicy_prop_remover.sh $1/etc/selinux/plat_property_contexts "device/qcom/sepolicy" > $1/../../plat_property_contexts
mv $1/../../plat_property_contexts $1/etc/selinux/plat_property_contexts
sed -i "/typetransition location_app/d" $1/etc/selinux/plat_sepolicy.cil

# Diable reboot_on_failure Check
sed -i "/reboot_on_failure/d" $1/etc/init/hw/init.rc
sed -i "/reboot_on_failure/d" $1/etc/init/apexd.rc

## Init style wifi fix
# Some systems are using custom wifi services, don't apply this patch on those roms
if [ -f $romdir/DONTPATCHWIFI ]; then
    echo "-> Patching wifi-service for init style wifi is not supported in this rom. Skipping..."
else
    echo "-> Start Patching wifi-service for init style wifi..."
    $thispath/initstylewifi/make.sh "$systempath"
fi

## Brightness fix
# Some systems are using custom light services, don't apply this patch on those roms
if [ -f $romdir/DONTPATCHLIGHT ]; then
    echo "-> Patching lights for brightness fix is not supported in this rom. Skipping..."
else
    echo "-> Start Patching Light Services for Brightness Fix..."
    $thispath/brightnessfix/make.sh "$systempath"
fi

# Drop empty selinux mappings inside product and make minor changes
find $1/product/etc/selinux/mapping/ -type f -empty | xargs rm -rf
if [ -e $1/product/etc/selinux/mapping ]; then
    sed -i '/software.version/d' $1/product/etc/selinux/product_property_contexts
    sed -i '/vendor/d' $1/product/etc/selinux/product_property_contexts
    sed -i '/secureboot/d' $1/product/etc/selinux/product_property_contexts
    sed -i '/persist/d' $1/product/etc/selinux/product_property_contexts
    sed -i '/oem/d' $1/product/etc/selinux/product_property_contexts
fi
