#!/bin/bash

# Merge S-P by YukoSky @ Treble-Experience
# License: GPL3

echo "##############################"
echo "#                            #"
echo "# S(EXT)-P Merger by YukoSky #"
echo "#         v1.5-Alpha         #"
echo "#                            #"
echo "##############################"
echo ""

### Initial vars
LOCALDIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
WORKING="$WORKING/working"
FE="$LOCALDIR/tools/firmware_extractor"

## Mount Point vars for system_new
SYSTEM_NEW="$WORKING/system_new"
SYSTEM_NEW_IMAGE="$WORKING/system_new.img"

## Mount Point vars for system
SYSTEM="$WORKING/system"
SYSTEM_IMAGE="$WORKING/super_2.img"

## Mount Point vars for product
PRODUCT="$WORKING/product"
PRODUCT_IMAGE="$WORKING/super_3.img"

## Mount Point vars for odm
ODM="$WORKING/odm"
ODM_IMAGE="$WORKING/super_5.img"

CREDITS() {
   # Just a comment in build.prop
   echo "" >> build.prop
   echo "#############################" >> build.prop
   echo "# Merged by S(EXT)-P Merger #" >> build.prop
   echo "#        By YukoSky         #" >> build.prop
   echo "#############################" >> build.prop
   echo "" >> build.prop
}

# super_2 (system)
echo "-> Check mount/etc for super_2 (system)"
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

# system_new.img
echo "-> Check mount/etc for system_new.img"
if [ -f "$SYSTEM_NEW_IMAGE" ]; then
   # Check for AB/Aonly in system_new
   if [ -d "$SYSTEM_NEW" ]; then
      if [ -d "$SYSTEM_NEW/dev/" ]; then
         echo " - SAR Mount detected in system_new, force umount!"
         sudo umount "$SYSTEM_NEW/"
      else
         if [ -d "$SYSTEM_NEW/etc/" ]; then
            echo " - Aonly Mount detected in system_new, force umount!"
            sudo umount "$SYSTEM_NEW/"
         fi
      fi
   fi
   echo " - Delete: system_new and mount point"
   sudo rm -rf $SYSTEM_NEW_IMAGE $SYSTEM_NEW/
   sudo dd if=/dev/zero of=$SYSTEM_NEW_IMAGE bs=4k count=2048576 > /dev/null 2>&1
   sudo tune2fs -c0 -i0 $SYSTEM_NEW_IMAGE > /dev/null 2>&1
   sudo mkfs.ext4 $SYSTEM_NEW_IMAGE > /dev/null 2>&1
   if [ ! -f "$SYSTEM_NEW_IMAGE" ]; then
      echo " - system_new don't exists, exit 1."
      exit 1
   fi
else
   echo " - system_new.img don't exists, create one..."
   sudo rm -rf $SYSTEM_NEW_IMAGE $SYSTEM_NEW/
   sudo dd if=/dev/zero of=$SYSTEM_NEW_IMAGE bs=4k count=2048576 > /dev/null 2>&1
   sudo tune2fs -c0 -i0 $SYSTEM_NEW_IMAGE > /dev/null 2>&1
   sudo mkfs.ext4 $SYSTEM_NEW_IMAGE > /dev/null 2>&1
   if [ ! -f "$SYSTEM_NEW_IMAGE" ]; then
      echo " - system_new don't exists, exit 1."
      exit 1
   fi
   echo " - Done: system_new"
fi

# product.img
echo "-> Check mount/etc for super_3 (product)"
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

# odm.img
echo "-> Check mount/etc for super_5 (odm)"
if [ -f "$ODM_IMAGE" ]; then
   # Check if odm is mounted
   if [ -d "$ODM" ]; then
      if [ -d "$ODM/etc/" ]; then
         echo " - Mount detected in odm, force umount!"
         sudo umount "$ODM/"
      fi
   fi
   echo " - Done: odm"
else
   echo " - odm don't exists, be careful!"
fi

echo "-> Starting process!"
echo " - Mount super_2 (system)"
if [ ! -d "$SYSTEM/" ]; then
   mkdir $SYSTEM
fi
sudo mount -o ro $SYSTEM_IMAGE $SYSTEM/

echo " - Mount system_new"
if [ ! -d "$SYSTEM_NEW/" ]; then
   mkdir $SYSTEM_NEW
fi
sudo mount -o loop $SYSTEM_NEW_IMAGE $SYSTEM_NEW/

echo " - Mount super_3 (product)"
if [ ! -d "$PRODUCT/" ]; then
   mkdir $PRODUCT
fi
sudo mount -o ro $PRODUCT_IMAGE $PRODUCT/

if [ -f "$ODM_IMAGE" ]; then
   echo " - Mount super_5 (odm)"
   if [ ! -d "$ODM/" ]; then
      mkdir $ODM
   fi
   sudo mount -o ro $ODM_IMAGE $ODM/
fi

echo "-> Copy super_2 (system) files to system_new"
cp -v -r -p $SYSTEM/* $SYSTEM_NEW/ > /dev/null 2>&1 && sync
if [ -d "$SYSTEM_NEW/dev/" ]; then
   cd $LOCALDIR/system_new/system/
   CREDITS
else
   if [ ! -f "$SYSTEM_NEW/build.prop" ]; then
      echo "-> Are you sure this is a Android image? Exit"
      exit 1
   fi
   cd $SYSTEM_NEW
   CREDITS
fi
echo "-> Umount system"
umount $SYSTEM/
cd $LOCALDIR

echo "-> Copy super_3 (product) files to system_new"
if [ -d "$SYSTEM_NEW/dev/" ]; then
   echo " - Using SAR method"
   cd $LOCALDIR/system_new/
   rm -rf product; cd system; rm -rf product
   mkdir -p product/
   cp -v -r -p $PRODUCT/* product/ > /dev/null 2>&1
   cd ../
   echo " - Fix symlink in product"
   ln -s /system/product/ product
   sync
   echo " - Fixed"
else
   if [ ! -f "$SYSTEM_NEW/build.prop" ]; then
      echo "-> Are you sure this is a Android image? Exit"
      exit 1
   fi
   cd $SYSTEM_NEW
   rm -rf product
   mkdir product && cd ../
   cp -v -r -p $PRODUCT/* $SYSTEM_NEW/product/ > /dev/null 2>&1 && sync
   cd $LOCALDIR
fi
cd $LOCALDIR

echo "-> Umount super_3 (product)"
sudo umount $PRODUCT/

if [ -f "$ODM_IMAGE" ]; then
   echo "-> Copy super_5 (odm) files to system_new"
   if [ -d "$SYSTEM_NEW/dev/" ]; then
      echo " - Using SAR method"
      cd $LOCALDIR/system_new/
      rm -rf odm; cd system; rm -rf odm
      mkdir -p odm/
      cp -v -r -p $ODM/* odm/ > /dev/null 2>&1
      cd ../
      echo " - Fix symlink in odm"
      ln -s /system/odm/ odm
      sync
      echo " - Fixed"
else
   if [ ! -f "$SYSTEM_NEW/build.prop" ]; then
      echo "-> Are you sure this is a Android image? Exit"
      exit 1
   fi
   cd $SYSTEM_NEW
   rm -rf odm
   mkdir odm && cd ../
   cp -v -r -p $ODM/* $SYSTEM_NEW/odm/ > /dev/null 2>&1 && sync
   cd $LOCALDIR
   fi
fi
cd $LOCALDIR

if [ -f "$ODM_IMAGE" ]; then
   echo "-> Umount odm"
   sudo umount $ODM/
fi

echo "-> Umount system_new"
sudo umount $SYSTEM_NEW/

mv $WORKING/system_new.img $WORKING/system.tmp
echo "-> Remove tmp folders and files"
sudo rm -rf $SYSTEM $SYSTEM_NEW $PRODUCT $SYSTEM_IMAGE $PRODUCT_IMAGE $ODM $ODM_IMAGE $WORKING/*.img

echo " - Compacting..."
mv system.tmp system.img
zip system.img.zip system.img
sudo rm -rf *.img

sudo rm -rf *.img

echo "-> Done, just run with url2GSI.sh"
