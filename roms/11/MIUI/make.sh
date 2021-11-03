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

# Check if device_features exists
if [ ! -d "$1/etc/device_features" ]; then
    echo "-> Device Features doesn't exists! Trying to get from firmware's vendor..."
    # If doens't exists: Check if device_features exists
    if [ -d "$thispath/../../../working/vendor/etc/device_features" ]; then
        cp -frp "$thispath/../../../working/vendor/etc/device_features" "$1/etc/"
        echo " - Done!"
    else
        echo " - Failed! Vendor seems unmounted or Device Features doesn't exists."
    fi
fi

# Check if this build is MISSI (MIUI Single System Image)
if $(cat $1/build.prop | grep -qo 'missi'); then
    echo "-> MISSI build detected! Trying to fix some props..."

    if [ -d "$thispath/../../../working/vendor/etc/device_features" ]; then
        brand=$(cat $thispath/../../../working/vendor/build.prop | grep 'ro.product.vendor.brand')
        device=$(cat $thispath/../../../working/vendor/build.prop | grep 'ro.product.vendor.device')
        manufacturer=$(cat $thispath/../../../working/vendor/build.prop | grep 'ro.product.vendor.manufacturer')
        model=$(cat $thispath/../../../working/vendor/build.prop | grep 'ro.product.vendor.model')
        mame=$(cat $thispath/../../../working/vendor/build.prop | grep 'ro.product.vendor.name')
        marketname=$(cat $thispath/../../../working/vendor/build.prop | grep 'ro.product.vendor.marketname')

        [[ $(cat $1/build.prop | grep "# Device fixed info") ]] && echo " - Seems there's already exists a device info patch, override it." && sed -i '/# Device fixed info/d' $1/build.prop

        sed -i '/ro.product.system./d' $1/build.prop

        echo "" >> $1/build.prop
        echo "# System & MIUI props fixed "
        echo "$brand" >> $1/build.prop
        echo "$device" >> $1/build.prop
        echo "$manufacturer" >> $1/build.prop
        echo "$model" >> $1/build.prop
        echo "$mame" >> $1/build.prop
        echo "$marketname" >> $1/build.prop
        echo "" >> $1/build.prop

        sed -i 's/ro.product.vendor./ro.product.system./g' $1/build.prop

        echo " - Done!"
    else
        echo " - Failed! Vendor seems unmounted."
    fi
fi

# Cat own rw-system.add.sh
cat $thispath/rw-system.add.sh >> $1/bin/rw-system.sh