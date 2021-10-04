#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Fix systemui crash because of FOD
echo "ro.hardware.fp.fod=true" >> $1/build.prop
echo "persist.vendor.sys.fp.fod.location.X_Y=445,1260" >> $1/build.prop
echo "persist.vendor.sys.fp.fod.size.width_height=190,190" >> $1/build.prop

# Copy system stuffs
rsync -ra $thispath/system/ $systempath

# Drop some things
sed -i 's/<bool name="support_round_corner">true/<bool name="support_round_corner">false/' $1/etc/device_features/*
sed -i "/ro.miui.notch/d" $1/build.prop

# Clear the miui promotion context that causes almost all models to bootloop or boot directly to recovery/fastboot/bl
sed -i '/miui.reverse.charge/d' $1/system_ext/etc/selinux/system_ext_property_contexts
sed -i '/ro.cust.test/d' $1/system_ext/etc/selinux/system_ext_property_contexts
sed -i '/miui.reverse.charge/d' $1/product/etc/selinux/product_property_contexts
sed -i '/ro.cust.test/d' $1/product/etc/selinux/product_property_contexts   

# Disable MIUI useless system performance analysis
rm -rf $1/xbin/system_perf_init

# Disable MIUI color inversion
sed -i '/ro.vendor.df.effect.conflict/d' $1/build.prop
sed -i '/persist.sys.df.extcolor.proc/d' $1/build.prop

# TODO: Testing only
# Disable display property in MIUI section
sed -i '/persist.sys.wfd.virtual/d' $1/build.prop
sed -i '/debug.sf.enable_hwc_vds/d' $1/build.prop
sed -i '/sys.displayfeature_hidl/d' $1/build.prop

# Disable MIUI QCA detection
sed -i '/sys,qca/d' $1/build.prop

# Disable MIUI paper mode
sed -i '/sys.paper_mode_max_level\=/d' $1/build.prop
sed -i '/sys.tianma/d' $1/build.prop
sed -i '/sys.huaxing/d' $1/build.prop
sed -i '/sys.shenchao/d' $1/build.prop

# MIUI resolution adaptation (same as LCD prop)
sed -i 's/persist.miui.density_v2/#&/' $1/build.prop
sed -i 's/persist.miui.density_v2/#&/' $1/product/build.prop
sed -i 's/persist.miui.density_v2/#&/' $1/system_ext/build.prop

# Cat own rw-system.add.sh
cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh