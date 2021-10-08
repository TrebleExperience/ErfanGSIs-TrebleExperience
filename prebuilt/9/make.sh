#!/bin/bash

systempath=$1
romdir=$2
thispath=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Copy system stuffs
rsync -ra $thispath/system/ $systempath

# Nuke dpi prop
sed -i 's/ro.sf.lcd/#&/' $1/build.prop

# Always enable CdmaLTEPhone
sed -i '/telephony.lteOnCdmaDevice/d' $1/build.prop
echo "telephony.lteOnCdmaDevice=1" >> $1/build.prop

# Drop some props (again)
sed -i '/vendor.display/d' $1/build.prop
sed -i '/vendor.perf/d' $1/build.prop
sed -i '/debug.sf/d' $1/build.prop
sed -i '/persist.sar.mode/d' $1/build.prop
sed -i '/opengles.version/d' $1/build.prop

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

## Brightness fix
# Some systems are using custom light services, don't apply this patch on those roms
if [ -f $romdir/DONTPATCHLIGHT ]; then
    echo "-> Patching lights for brightness fix is not supported in this rom. Skipping..."
else
    echo "-> Start Patching Light Services for Brightness Fix..."
    $thispath/brightnessfix/make.sh "$systempath"
fi
