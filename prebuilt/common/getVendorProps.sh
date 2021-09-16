#!/bin/bash -e

# Copyright (C) 2021 Xiaoxindada <2245062854@qq.com>
# Project Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>

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
    cat $TMPFILE >> $SYSTEM_DIR/build.prop
    rm -rf $TMPFILE $LOCAL/vendor.prop
fi