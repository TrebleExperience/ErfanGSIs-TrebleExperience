#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# AOSP libs
cp -fpr $thispath/overlay/* $1/product/overlay/

# Append file_context
echo "ro.config.ringtone=The_big_adventure.ogg" >> $1/product/etc/build.prop
echo "ro.config.notification_sound=Popcorn.ogg" >> $1/product/etc/build.prop
echo "ro.config.alarm_alert=Bright_morning.ogg" >> $1/product/etc/build.prop
echo "persist.sys.overlay.pixelrecents=true" >> $1/product/etc/build.prop
echo "qemu.hw.mainkeys=0" >> $1/product/etc/build.prop
echo "ro.opa.eligible_device=true" >> $1/product/etc/build.prop
echo "ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent" >> $1/product/etc/build.prop
echo "ro.com.android.dataroaming=false" >> $1/product/etc/build.prop
echo "ro.com.google.clientidbase=android-google" >> $1/product/etc/build.prop
echo "ro.error.receiver.system.apps=com.google.android.gms" >> $1/product/etc/build.prop
echo "ro.com.google.ime.theme_id=5" >> $1/product/etc/build.prop
echo "ro.com.google.ime.system_lm_dir=/product/usr/share/ime/google/d3_lms" >> $1/product/etc/build.prop

# Drop dataservice contexts
sed -i "/dataservice_app/d" $1/product/etc/selinux/product_seapp_contexts
sed -i "/dataservice_app/d" $1/system_ext/etc/selinux/system_ext_seapp_contexts

# Try to fix lag
sed -i "/sys.use_fifo_ui/d" $1/build.prop
sed -i "/debug.sf.latch_unsignaled/d" $1/build.prop

# Drop HbmSVManager which is crashing light hal
rm -rf $1/system_ext/priv-app/HbmSVManager

# Try to fix height ratio
sed -i "/ro.com.google.ime.height_ratio/d" $1/product/etc/build.prop
echo "ro.com.google.ime.height_ratio=1.0" >> $1/product/etc/build.prop

# Merge monet props stuff
sed -i "/persist.sysui.monet/d" $1/product/etc/build.prop
sed -i "/ro.boot.vendor.overlay.theme/d" $1/product/etc/build.prop
echo "" >> $1/product/etc/build.prop
echo "# Monet fix (Not fully)" >> $1/product/etc/build.prop
echo "persist.sysui.monet=true" >> $1/product/etc/build.prop
echo "ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural;com.google.android.systemui.gxoverlay" >> $1/product/etc/build.prop
