#!/bin/bash

systempath=$1
romdir=$2
thispath=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

if [[ ! -d "$1/system_ext" || ! -d "$1/product" ]]; then
    echo "-> Abort! Important partitions are missing, critical problem."
    touch $thispath/../../tmp/FATALERROR
    exit 1
fi

# Drop apex prop
sed -i '/ro.apex.updatable/d' $1/build.prop
sed -i '/ro.apex.updatable/d' $1/product/build.prop

# Deal with non-flattened apex
$thispath/../../../scripts/apex_extractor.sh $1/apex
$thispath/../../../scripts/apex_extractor.sh $1/system_ext/apex
echo "ro.apex.updatable=false" >> $1/product/build.prop

# Nuke dpi prop
sed -i 's/ro.sf.lcd/#&/' $1/build.prop
sed -i 's/ro.sf.lcd/#&/' $1/product/build.prop
sed -i 's/ro.sf.lcd/#&/' $1/system_ext/build.prop

# Always enable CdmaLTEPhone
sed -i '/telephony.lteOnCdmaDevice/d' $1/build.prop
sed -i '/telephony.lteOnCdmaDevice/d' $1/product/build.prop
sed -i '/telephony.lteOnCdmaDevice/d' $1/system_ext/build.prop
echo "telephony.lteOnCdmaDevice=1" >> $1/build.prop
echo "telephony.lteOnCdmaDevice=1" >> $1/product/build.prop
echo "telephony.lteOnCdmaDevice=1" >> $1/system_ext/build.prop

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
sed -i '/ro.control_privapp_permissions/d' $1/system_ext/build.prop

# Copy system files
rsync -ra $thispath/system/ $systempath

# Cat own rw-system
cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh

# Overlays
if [ ! -d  $1/product/overlay ]; then
    mkdir -p $1/product/overlay
    chmod 0755 $1/product/overlay
    chown root:root $1/product/overlay
fi

# Copy navigation bar aosp overlays
if [ -f $romdir/NOAOSPOVERLAY ]; then
    echo "-> Using AOSP overlays isn't supported in this rom. Skipping..."
else
    cp -fpr $thispath/aosp_overlay/* $1/product/overlay/
fi

if [ -f $romdir/NODEVICEOVERLAY ]; then
    echo "-> Using device specific overlays is not supported in this rom. Skipping..."
else
    cp -fpr $thispath/overlay/* $1/product/overlay/
fi

# Append file_context
cat $thispath/file_contexts >> $1/etc/selinux/plat_file_contexts

# Disable Codec2
sed -i "s/android.hardware.media.c2/android.hardware.erfan.c2/g" $1/etc/vintf/manifest.xml
rm -rf $1/etc/vintf/manifest/manifest_media_c2_software.xml

# Minor changes
if $(grep -q 'ro.product.property_source_order=' $1/build.prop); then
    sed -i '/ro.product.property\_source\_order\=/d' $1/build.prop
    echo "ro.product.property_source_order=system,product,system_ext,vendor,odm" >> $1/build.prop
fi

# Fix vendor CAF sepolicies
$thispath/../../scripts/sepolicy_prop_remover.sh $1/etc/selinux/plat_property_contexts "device/qcom/sepolicy" > $1/../../plat_property_contexts
mv $1/../../plat_property_contexts $1/etc/selinux/plat_property_contexts
sed -i "/typetransition location_app/d" $1/etc/selinux/plat_sepolicy.cil

# GSI always generate dex pre-opt in system image
echo "ro.cp_system_other_odex=0" >> $1/product/build.prop

# GSI disables non-AOSP nnapi extensions on product partition
echo "ro.nnapi.extensions.deny_on_product=true" >> $1/product/build.prop

# TODO(b/136212765): the default for LMK
echo "ro.lmk.kill_heaviest_task=true" >> $1/product/build.prop
echo "ro.lmk.kill_timeout_ms=100" >> $1/product/build.prop
echo "ro.lmk.use_minfree_levels=true" >> $1/product/build.prop

# Minor changes
sed -i '/u:object_r:vendor_default_prop:s0/d' $1/etc/selinux/plat_property_contexts
sed -i '/software.version/d' $1/etc/selinux/plat_property_contexts
sed -i 's/sys.usb.config          u:object_r:system_radio_prop:s0//g' $1/etc/selinux/plat_property_contexts
sed -i 's/ro.build.fingerprint    u:object_r:fingerprint_prop:s0//g' $1/etc/selinux/plat_property_contexts

# Drop empty selinux mappings inside product and make minor changes
find $1/product/etc/selinux/mapping/ -type f -empty | xargs rm -rf
if [ -e $1/product/etc/selinux/mapping ]; then
    sed -i '/software.version/d' $1/product/etc/selinux/product_property_contexts
    sed -i '/vendor/d' $1/product/etc/selinux/product_property_contexts
    sed -i '/secureboot/d' $1/product/etc/selinux/product_property_contexts
    sed -i '/persist/d' $1/product/etc/selinux/product_property_contexts
    sed -i '/oem/d' $1/product/etc/selinux/product_property_contexts
fi

# Drop empty selinux mappings inside system_ext
find $1/system_ext/etc/selinux/mapping/ -type f -empty | xargs rm -rf
if [ -e $1/system_ext/etc/selinux/mapping ]; then
    sed -i '/software.version/d' $1/system_ext/etc/selinux/system_ext_property_contexts
    sed -i '/vendor/d' $1/system_ext/etc/selinux/system_ext_property_contexts
    sed -i '/secureboot/d' $1/system_ext/etc/selinux/system_ext_property_contexts
    sed -i '/persist/d' $1/system_ext/etc/selinux/system_ext_property_contexts
    sed -i '/oem/d' $1/system_ext/etc/selinux/system_ext_property_contexts
fi
