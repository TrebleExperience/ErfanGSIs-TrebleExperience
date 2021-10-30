#!/bin/bash

systempath=$1
romdir=$2
thispath=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Copy system stuffs
rsync -ra $thispath/system/ $systempath

# Nuke dpi prop
sed -i 's/ro.sf.lcd/#&/' $1/build.prop

# Always enable CdmaLTEPhone
echo "# Always enable CdmaLTEPhone" >> $1/build.prop
echo "telephony.lteOnCdmaDevice=1" >> $1/build.prop
echo "" >> $1/build.prop

# Drop some props (again)
sed -i '/vendor.display/d' $1/build.prop
sed -i '/vendor.perf/d' $1/build.prop
sed -i '/debug.sf/d' $1/build.prop
sed -i '/persist.sar.mode/d' $1/build.prop
sed -i '/opengles.version/d' $1/build.prop

# Enable debugging
sed -i 's/persist.sys.usb.config=none/persist.sys.usb.config=adb/g' $1/build.prop
sed -i 's/ro.debuggable=0/ro.debuggable=1/g' $1/build.prop
sed -i 's/ro.adb.secure=1/ro.adb.secure=0/g' $1/build.prop
if [[ -f $1/product/build.prop ]]; then
    echo "# Force enable debugging" >> $1/product/build.prop
    echo "ro.force.debuggable=1" >> $1/product/build.prop
    echo "" >> $1/product/build.prop
else
    echo "# Force enable debugging" >> $1/build.prop
    echo "ro.force.debuggable=1" >> $1/build.prop
    echo "" >> $1/build.prop
fi

# Some systems are using custom light services, don't apply this patch on those roms
if [ -f $romdir/DONTPATCHLIGHT ]; then
    echo "-> Patching lights for brightness fix is not supported in this rom. Skipping..."
else
    echo "-> Start Patching Light Services for Brightness Fix..."
    $thispath/brightnessfix/make.sh "$systempath"
fi
