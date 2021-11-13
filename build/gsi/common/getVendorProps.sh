#!/bin/bash -e

# Copyright (C) 2021 Xiaoxindada <2245062854@qq.com>
# Project Treble Experience by Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com> <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>

# Core variables, don't edit.
LOCALDIR=`cd "$( dirname $0 )" && pwd`
TMPFILE="$LOCALDIR/v.prop"
VENDOR_DIR="$1"
SYSTEM_DIR="$2"

# Copy tmp vendor build.prop.
rm -rf $LOCAL/vendor.prop
cp -frp $VENDOR_DIR/build.prop $LOCAL/vendor.prop

# Do minor changes before.
sed -i '/#end/d' $LOCAL/vendor.prop
echo "#end" >> $LOCAL/vendor.prop

# Start the process.
start=$((`grep -n '# ADDITIONAL VENDOR BUILD PROPERTIES' $LOCAL/vendor.prop | cut -d ":" -f 1`+2))
end=$((`grep -n '#end' $LOCAL/vendor.prop | sed 's/:#end//g' `-1))
sed -n ${start},${end}p $LOCAL/vendor.prop > $TMPFILE

# Check the result.
if [[ -z $(grep '[^[:space:]]' $TMPFILE) ]]; then
    echo " - Failed! It looks like there are no additional properties in the vendor's build.prop."
    rm -rf $TMPFILE $LOCAL/vendor.prop
else
    echo " - Additional vendor properties obtained successfully! Process completed."

    # Make it clean (& natural)
    sed -i '1 i\# ADDITIONAL VENDOR BUILD PROPERTIES (Obtained automatically via build/gsi/common/getVendorProps.sh)' $TMPFILE
    sed -i '1 i\\n' $TMPFILE

    # Common drops: Necessary!
    sed -i '/ro.control_privapp_permissions/d' $TMPFILE
    sed -i '/debug.sf/d' $TMPFILE
    sed -i '/vendor.display/d' $TMPFILE
    sed -i '/sys.haptic/d' $TMPFILE
    sed -i '/hbm/d' $TMPFILE
    sed -i '/ro.oem_unlock.pst/d' $TMPFILE
    sed -i '/ro.frp.pst/d' $TMPFILE
    sed -i '/ro.build.expect/d' $TMPFILE
    sed -i '/ro.sf.lcd_density/d' $TMPFILE
    sed -i '/vendor.audio/d' $TMPFILE
    sed -i '/log/d' $TMPFILE
    sed -i '/opengles.version/d' $TMPFILE
    sed -i '/vendor.perf/d' $TMPFILE
    sed -i '/vendor.media/d' $TMPFILE
    sed -i '/debug.media/d' $TMPFILE
    sed -i '/ro.telephony.iwlan_operation_mode/d' $TMPFILE
    sed -i '/ro.apex.updatable/d' $TMPFILE
    sed -i '/external_storage/d' $TMPFILE
    sed -i '/ro.expect.recovery_id/d' $TMPFILE
    sed -i '/^\s*$/d' $TMPFILE

    # Do '# end' at final
    sed -i -e '$a# end' $TMPFILE

    # Cat it to system now
    cat $TMPFILE >> $SYSTEM_DIR/build.prop
    rm -rf $TMPFILE $LOCAL/vendor.prop
fi