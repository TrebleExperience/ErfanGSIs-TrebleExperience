#!/bin/bash

# Merge S-P by YukoSky @ Treble-Experience
# License: GPL3

echo "#############################"
echo "#                           #"
echo "#   S-P Merger by YukoSky   #"
echo "#                           #"
echo "#############################"
echo ""

### Initial vars
LOCALDIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

## Mount Point vars for system_new
SYSTEM_NEW="$LOCALDIR/system_new"
SYSTEM_NEW_IMAGE="$LOCALDIR/system_new.img"

## Mount Point vars for system
SYSTEM="$LOCALDIR/system"
SYSTEM_IMAGE="$LOCALDIR/system.img"

## Mount Point vars for product
PRODUCT="$LOCALDIR/product"
PRODUCT_IMAGE="$LOCALDIR/product.img"

# system_new.img
echo "-> Check mount/etc for system_new.img"
if [ -f "$SYSTEM_NEW_IMAGE" ]; then
   # Check for AB/Aonly in system_new
   if [ -d "$SYSTEM_NEW" ]; then
      if [ -d "$SYSTEM_NEW/dev/" ]; then
         echo " - SAR Mount detected in system_new, force umount!"
         sudo "$SYSTEM_NEW/"
      else
         if [ -d "$SYSTEM_NEW/etc/" ]; then
            echo " - Aonly Mount detected in system_new, force umount!"
            sudo "$SYSTEM_NEW/"
         fi
      fi
   fi
   echo " - Delete: system_new and mount point"
   sudo rm -rf system_new.img system_new/
   sudo dd if=/dev/zero of=system_new.img bs=4k count=2048576 > /dev/null 2>&1
   sudo tune2fs -c0 -i0 system_new.img > /dev/null 2>&1
   sudo mkfs.ext4 system_new.img > /dev/null 2>&1
   if [ ! -f "$SYSTEM_NEW_IMAGE" ]; then
      echo " - system_new don't exists, exit 1."
      exit 1
   fi
else
   echo " - system_new.img don't exists, create one..."
   sudo rm -rf system_new.img system_new/
   sudo dd if=/dev/zero of=system_new.img bs=4k count=2048576 > /dev/null 2>&1
   sudo tune2fs -c0 -i0 system_new.img > /dev/null 2>&1
   sudo mkfs.ext4 system_new.img > /dev/null 2>&1
   if [ ! -f "$SYSTEM_NEW_IMAGE" ]; then
      echo " - system_new don't exists, exit 1."
      exit 1
   fi
   echo " - Done: system_new"
fi

# system.img
echo "-> Check mount/etc for system.img"
if [ -f "$SYSTEM_IMAGE" ]; then
   # Check for AB/Aonly in system
   if [ -d "$SYSTEM" ]; then
      if [ -d "$SYSTEM/dev/" ]; then
         echo " - SAR Mount detected in system, force umount!"
         sudo umount "$SYSTEM/"
      else
         if [ -d "$SYSTEM/etc/" ]; then
            echo " - Aonly Mount detected in system, force umount!"
            sudo umount "$SYSTEM/"
         fi
      fi
   fi
   echo " - Done: system"
else
   echo " - system don't exists, exit 1."
   exit 1
fi

# product.img
echo "-> Check mount/etc for product.img"
if [ -f "$PRODUCT_IMAGE" ]; then
   # Check if product is mounted
   if [ -d "$PRODUCT" ]; then
      if [ -d "$PRODUCT/etc/" ]; then
         echo " - Mount detected in product, force umount!"
         sudo umount "$PRODUCT/"
      fi
   fi
   echo " - Done: product"
else
   echo " - product don't exists, exit 1."
   exit 1
fi

echo "-> Starting process!"
echo " - Mount system"
if [ ! -d "$SYSTEM/" ]; then
   mkdir $SYSTEM
fi
sudo mount -o ro $SYSTEM_IMAGE $SYSTEM/

echo " - Mount system_new"
if [ ! -d "$SYSTEM_NEW/" ]; then
   mkdir $SYSTEM_NEW
fi
sudo mount -o loop $SYSTEM_NEW_IMAGE $SYSTEM_NEW/

echo " - Mount product"
if [ ! -d "$PRODUCT/" ]; then
   mkdir $PRODUCT
fi
sudo mount -o ro $PRODUCT_IMAGE $PRODUCT/

echo "-> Copy system files to system_new"
cp -v -r -p system/* system_new/ > /dev/null 2>&1 && sync
echo " - Umount system"
umount $SYSTEM/

echo "-> Copy product files to system_new"
cd $SYSTEM_NEW/; rm -rf product; cd system; rm -rf product; mkdir product
cd ../../
cp -v -r -p $PRODUCT/* $SYSTEM_NEW/system/product/ > /dev/null 2>&1 && sync

echo " - Umount product"
sudo umount $PRODUCT/

echo " - Umount system_new"
sudo umount $SYSTEM_NEW/

echo "-> Remove tmp folders and files"
sudo rm -rf $SYSTEM $SYSTEM_NEW $PRODUCT $SYSTEM_IMAGE $PRODUCT_IMAGE

echo " - Zip system_new.img"
zip system.img.zip $SYSTEM_NEW_IMAGE

echo "-> Done, just run with !jurl2gsi/url2GSI.sh."