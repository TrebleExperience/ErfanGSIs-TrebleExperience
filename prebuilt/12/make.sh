#!/bin/bash

systempath=$1
romdir=$2
thispath=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Drop apex prop
sed -i '/ro.apex.updatable/d' $1/build.prop
sed -i '/ro.apex.updatable/d' $1/product/build.prop
sed -i '/ro.apex.updatable/d' $1/system_ext/build.prop

# Deal with non-flattened apex
$thispath/../../scripts/apex_extractor.sh $1/apex
echo "ro.apex.updatable=true" >> $1/product/etc/build.prop

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

# Append file_context
cat $thispath/file_contexts >> $1/etc/selinux/plat_file_contexts

# Minor changes
if $(grep -q 'ro.product.property_source_order=' $1/build.prop); then
    sed -i '/ro.product.property\_source\_order\=/d' $1/build.prop
    echo "ro.product.property_source_order=system,product,system_ext,vendor,odm" >> $1/build.prop
fi

# Fix vendor CAF sepolicies
$thispath/../../scripts/sepolicy_prop_remover.sh $1/etc/selinux/plat_property_contexts "device/qcom/sepolicy" >$1/../../plat_property_contexts
mv $1/../../plat_property_contexts $1/etc/selinux/plat_property_contexts
sed -i "/typetransition location_app/d" $1/etc/selinux/plat_sepolicy.cil

# GSI always generate dex pre-opt in system image
echo "ro.cp_system_other_odex=0" >> $1/product/etc/build.prop

# GSI disables non-AOSP nnapi extensions on product partition
echo "ro.nnapi.extensions.deny_on_product=true" >> $1/product/etc/build.prop

# TODO(b/136212765): the default for LMK
echo "ro.lmk.kill_heaviest_task=true" >> $1/product/etc/build.prop
echo "ro.lmk.kill_timeout_ms=100" >> $1/product/etc/build.prop
echo "ro.lmk.use_minfree_levels=true" >> $1/product/etc/build.prop

#sudo sed -i "s|/dev/uinput               0660   uhid       uhid|/dev/uinput               0660   system     bluetooth|" $1/etc/ueventd.rc

# Disable bpfloader
rm -rf $1/etc/init/bpfloader.rc
echo "bpf.progs_loaded=1" >> $1/product/etc/build.prop

# Bypass SF validateSysprops
echo "ro.surface_flinger.vsync_event_phase_offset_ns=-1" >> $1/product/etc/build.prop
echo "ro.surface_flinger.vsync_sf_event_phase_offset_ns=-1" >> $1/product/etc/build.prop
echo "debug.sf.high_fps_late_app_phase_offset_ns=" >> $1/product/etc/build.prop
echo "debug.sf.early_phase_offset_ns=" >> $1/product/etc/build.prop
echo "debug.sf.early_gl_phase_offset_ns=" >> $1/product/etc/build.prop
echo "debug.sf.early_app_phase_offset_ns=" >> $1/product/etc/build.prop
echo "debug.sf.early_gl_app_phase_offset_ns=" >> $1/product/etc/build.prop
echo "debug.sf.high_fps_late_sf_phase_offset_ns=" >> $1/product/etc/build.prop
echo "debug.sf.high_fps_early_phase_offset_ns=" >> $1/product/etc/build.prop
echo "debug.sf.high_fps_early_gl_phase_offset_ns=" >> $1/product/etc/build.prop
echo "debug.sf.high_fps_early_app_phase_offset_ns=" >> $1/product/etc/build.prop
echo "debug.sf.high_fps_early_gl_app_phase_offset_ns=" >> $1/product/etc/build.prop

# Minor changes
sed -i '/software.version/d' $1/etc/selinux/plat_property_contexts
sed -i '/ro.build.fingerprint    u:object_r:fingerprint_prop:s0/d' $1/etc/selinux/plat_property_contexts

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
