#!/bin/bash

# Minimal Merge script written by Velosh <daffetyxd@gmail.com>
# License: GPLv3

# Core variables, don't edit.
PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
WORKING="$PROJECT_DIR/../working"
TMPDIR="$PROJECT_DIR/../tmp/merger"
TAG="merger.log"
DYNAMIC=false
FIRMWARE="$(realpath $1)"

# Delete tmp dir
rm -rf $TMPDIR

# Create tmp dir
[[ ! -d "$TMPDIR" ]] && mkdir -p $TMPDIR

# Dummy size
SIZE="2048576" # Size + (All partitions type: S, G, ONP & OPL)

# Variables for mount/merge
SPARTITIONS="system system_ext product" # System partitions
GPARTITIONS="system_other" # Pixel partitions (I'll change that name desc soon)
OPARTITIONS="vendor odm" # Partitions which have overlay stuff
ONPPARTITIONS="reserve india" # OnePlus partitions
OPLPARTITIONS="my_bigball my_carrier my_company my_engineering my_heytap my_manifest my_preload my_product my_region my_stock my_version" # Oplus (aka COS, RUI) shits
MPARTITION="$WORKING/system_new"

usage() {
   echo "Usage: $0 <Path to firmware>"
   echo -e "\tPath to firmware: the zip!"
}

MOUNT() {
   if $(sudo mount -o auto -t auto "$1" "$2" > /dev/null 2>&1); then
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

FATAL() {
   echo " - Error when copying content from an image to the system image, partition that was being copied to the system: $1"
   exit 1
}

UMOUNT() {
   for partition in $WORKING/*; do
      if [ -d "$partition" ]; then
         umount -f $partition >> /dev/null 2>&1 || true
         umount -l $partition >> /dev/null 2>&1 || true
      fi
   done
}

# Always run as root
if [ "${EUID}" -ne 0 ]; then
   echo "-> Run as root!"
   exit 1
fi

# Check param
if [[ ! -n $1 ]]; then
   echo "-> ERROR!"
   echo " - Enter all needed parameters"
   rm -rf "$WORKING"
   usage
   exit
fi

# Check if already exists a working folder
if [ -d "$WORKING" ]; then
   UMOUNT
   rm -rf $WORKING
fi

# Create working folder
if [ ! -d "$WORKING/" ]; then
   mkdir -p "$WORKING"
fi

# Run!
echo "-> Running MM Script (2.1)"
[ ! -f "$FIRMWARE" ] && echo " - Error! Isn't a file. Abort." && exit 1
bash "$PROJECT_DIR/../zip2img.sh" "$FIRMWARE" "$WORKING" || exit 1

# Check if there's a partition to merge.
for partition in $SPARTITIONS $GPARTITIONS $OPLPARTITIONS; do
   [ $partition == system ] && continue
   [ -f $WORKING/$partition.img ] && DYNAMIC=true && echo "- Detected a partiton which can be merged into system: $partition" >> "$TMPDIR/$TAG" 2>&1
done

if [ $DYNAMIC == false ]; then
   echo " - That firmware seems not dynamic. Abort."
   exit 1
fi

# Mount all images (but before, fix size)
for partition in $SPARTITIONS $GPARTITIONS $OPARTITIONS $OPLPARTITIONS $MPARTITION; do
   if [ -f "$WORKING/$partition.img" ]; then
      echo "- Fixing partition size, resizing & mounting: $partition" >> "$TMPDIR/$TAG" 2>&1
      [ ! -d "$WORKING/$partition" ] && mkdir -p "$WORKING/$partition"
      e2fsck -fy "$WORKING/$partition.img" >> "$TMPDIR/$TAG" 2>&1
      resize2fs -M "$WORKING/$partition.img" >> "$TMPDIR/$TAG" 2>&1
      MOUNT $WORKING/$partition.img $WORKING/$partition "$partition"
   fi
done

# OPARTITIONS = (partitions which have overlay stuff)
for partition in $OPARTITIONS; do
   [ $partition == vendor ] && name=".tmp"
   [ $partition == odm ] && name=".otmp"
   if [ -d $WORKING/$partition/overlay ]; then
      echo "- Detected ($partition) overlay partition, it's prefix: $name" >> "$TMPDIR/$TAG" 2>&1
      mkdir -p "$WORKING/${partition}Overlays"
      cp -frp $WORKING/$partition/overlay/* "$WORKING/${partition}Overlays"
      rm -rf "$WORKING/${partition}Overlays/home"
      tar -zcvf "$WORKING/${partition}Overlays.gz" "$WORKING/${partition}Overlays" > /dev/null 2>&1
      rm -rf $WORKING/${partition}Overlays/
      [ ! -d "$PROJECT_DIR/../output/" ] && mkdir "$PROJECT_DIR/../output/"
      mv "$WORKING/${partition}Overlays.gz" "$PROJECT_DIR/../output/$name"
   fi
done

# Calculate size (as dynamic)
for partition in $SPARTITIONS $GPARTITIONS $ONPPARTITIONS $OPLPARTITIONS; do
   if [ -f "$WORKING/$partition.img" ]; then
      SIZE="$(expr $SIZE + "$(du -k $WORKING/$partition.img | awk '{printf $1}')")"
   fi
done

# Create raw image & copy system content
sudo dd if=/dev/zero of=$MPARTITION.img bs=1024 count=$SIZE >> "$TMPDIR/$TAG" 2>&1
sudo tune2fs -c0 -i0 $MPARTITION.img >> "$TMPDIR/$TAG" 2>&1
sudo mkfs.ext4 $MPARTITION.img >> "$TMPDIR/$TAG" 2>&1
mkdir -p $MPARTITION && MOUNT $MPARTITION.img $MPARTITION "system_new"
cp -vfrp $WORKING/system/* $MPARTITION >> "$TMPDIR/$TAG" 2>&1 && umount -l $WORKING/system; rm -rf $WORKING/system.img $WORKING/system

# Merge odm_feature_list if exists (op-fwb)
if [ -f "$WORKING/odm.img" ]; then
   if [ -f "$WORKING/odm/etc/odm_feature_list" ]; then
      cp -frp "$WORKING/odm/etc/odm_feature_list" "$MPARTITION/system/etc/odm_feature_list"
   fi
fi

# SPARTITION = (AOSP partitions)
for partition in $SPARTITIONS; do
   [ $partition == system ] && continue
   if [ -f "$WORKING/$partition.img" ]; then
      echo "- Merging $partition into /system/$partition" >> "$TMPDIR/$TAG" 2>&1
      rm -rf $MPARTITION/$partition $MPARTITION/system/$partition && mkdir -p $MPARTITION/system/$partition
      cp -vfrp $WORKING/$partition/* $MPARTITION/system/$partition >> "$TMPDIR/$TAG" 2>&1 || FATAL "$partition"
      ln -s /system/$partition/ $MPARTITION/$partition
      umount -l $WORKING/$partition
      rm -rf $WORKING/$partition
      [ $partition == odm ] && continue
      rm -rf $WORKING/$partition.img
   fi
done

# GPARTITIONS = (Pixel partitions)
for partition in $GPARTITIONS; do
   if [ -f "$WORKING/$partition.img" ]; then
      echo "- Merging $partition into /" >> "$TMPDIR/$TAG" 2>&1
      cp -vfrp $WORKING/$partition/* $MPARTITION >> "$TMPDIR/$TAG" 2>&1 || FATAL "$partition"
      umount -l $WORKING/$partition && rm -rf $WORKING/$partition $WORKING/$partition.img
      # TODO(b/1): Drop useless system-other-odex-marker rootfs file
      [ -f $MPARTITION/system-other-odex-marker ] && rm -rf $MPARTITION/system-other-odex-marker
   fi
done

# ONPPARTITIONS = (OnePlus partitions/stuff)
for partition in $ONPPARTITIONS; do
   if [ -f "$WORKING/$partition.img" ]; then
      echo "- Merging $partition into /system/$partition" >> "$TMPDIR/$TAG" 2>&1
      cp -vfrp $WORKING/$partition/* $MPARTITION/system/$partition >> "$TMPDIR/$TAG" 2>&1 || FATAL "$partition"
      umount -l $WORKING/$partition
      rm -rf $WORKING/$partition
   fi
done

# OPLPARTITIONS = (Oplus partitions/stuff)
for partition in $OPLPARTITIONS; do
   if [ -f "$WORKING/$partition.img" ]; then
      echo "- Merging $partition into /$partition" >> "$TMPDIR/$TAG" 2>&1
      cp -vfrp $WORKING/$partition/* $MPARTITION/$partition >> "$TMPDIR/$TAG" 2>&1 || FATAL "$partition"
      umount -l $WORKING/$partition && rm -rf $WORKING/$partition $WORKING/$partition.img
   fi
done

# Umount all and resize the system_new image
UMOUNT

# Delete all folders
for partition in $SPARTITIONS $GPARTITIONS $OPARTITIONS $OPLPARTITIONS $MPARTITION; do
   if [ -d "$WORKING/$partition" ]; then
      rm -rf "$WORKING/$partition"
   fi
   [[ $partition == system || $partition == vendor ]] && continue
   [ -f $partition ] && rm -rf "$WORKING/$partition.img"
done

# Just for debugging/logging
file $MPARTITION.img >> "$TMPDIR/$TAG" 2>&1
du -h $MPARTITION.img >> "$TMPDIR/$TAG" 2>&1

# Fix/resize the system image
e2fsck -fy $MPARTITION.img >> "$TMPDIR/$TAG" 2>&1
resize2fs -M $MPARTITION.img >> "$TMPDIR/$TAG" 2>&1
mv $MPARTITION.img $WORKING/system.img && rm -rf $MPARTITION
