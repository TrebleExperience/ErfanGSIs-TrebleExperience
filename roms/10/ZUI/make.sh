#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Try to disable bootprof
echo "ro.bootprof.disable=1" >> $systempath/build.prop

# Copy erfan bootprof
cp -fpr $thispath/erfan $systempath/

# Edit bootprof path
sed -i "s|/proc/bootprof|/system/erfan/bootprof|g" $systempath/lib/libsurfaceflinger.so
sed -i "s|/proc/bootprof|/system/erfan/bootprof|g" $systempath/lib64/libsurfaceflinger.so
