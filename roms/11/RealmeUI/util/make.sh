#!/bin/bash

# Usage: <1: working folder path> <2: system tmp path>

# Based off on: https://github.com/xiaoxindada/SGSI-build-tool/blob/11/make/rom_make_patch/color/make.sh
OPARTITION="odm"
WORKING="$1"
SYSTEMDIR="$2"

# Mount util
MOUNT() {
    if $(sudo mount -o auto -t auto "$1" "$2" >/dev/null 2>&1); then
        GOOD=true
    elif $(sudo mount -o loop "$1" "$2" > /dev/null 2>&1); then
        GOOD=true
    elif $(sudo mount -o ro "$1" "$2" > /dev/null 2>&1); then
        GOOD=true
    elif $(sudo mount -o ro -t erofs "$1" "$2" > /dev/null 2>&1); then
        GOOD=true
    elif $(sudo mount -o loop -t erofs "$1" "$2" > /dev/null 2>&1); then
        GOOD=true
    else
        echo " - Failed to mount $3 image, abort!"
        exit 1
    fi
}

# [LOGGING]
echo " - Merging/patching some stuff..."

# Mount all images (Skipped my_*)
for partition in $OPARTITION; do
    if [ -f "$WORKING/$partition.img" ]; then
        [ ! -d "$WORKING/$partition" ] && mkdir -p "$WORKING/$partition"
        MOUNT $WORKING/$partition.img $WORKING/$partition "$partition"
    fi
done

# Initial vars
odmdir="$WORKING/$OPARTITION"
framework_dir="$odmdir/framework"
permissions_dir="$odmdir/etc/permissions"
jar_files="$(find $framework_dir -maxdepth 1 -type f -name "*oplus*jar")"
permissions_files="$(find $permissions_dir -maxdepth 1 -type f -name "*oplus*xml)")"

# Copy oppo jars
for oppo_jars in $jar_files; do
    oppo_jars="$(realpath $oppo_jars)"
    cp -frp $oppo_jars $SYSTEMDIR/system_ext/framework
done

# Copy oppo permissions
for oppo_permissions in $permissions_files; do
    oppo_permissions="$(realpath $oppo_permissions)"
    cp -frp $oppo_jars $SYSTEMDIR/system_ext/etc/permissions
done

# Drop some files
rm -rf $SYSTEMDIR/system_ext/framework/*"ufsplus"* $SYSTEMDIR/system_ext/etc/permissions/*"ufsplus"*

# Copy ORMS
core="$(realpath "$(find $odmdir -type f -name "orms_core_config.xml")")"
permission="$(realpath "$(find $odmdir -type f -name "orms_permission_config.xml")")"
cp -frp "$core" $SYSTEMDIR/system_ext/etc/permissions/
cp -frp "$permission" $SYSTEMDIR/system_ext/etc/permissions/

# Fix path
permissions_files="$(find $SYSTEMDIR/system_ext/etc/permissions -type f -name "*.xml")"
for patch_files in $permissions_files; do
    patch_files="$(realpath $patch_files)"
    sed -i "s#/odm/#/system/system_ext/#g" $patch_files
done

# Copy build.prop stuff to system
sed -i '/import/d' $odmdir/build.prop
echo "" >> $systemdir/build.prop
cat $odmdir/build.prop >> $systemdir/build.prop

# Done!
echo " - Done!"
