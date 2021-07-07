#!/bin/bash

# Merge S-P by Velosh @ Treble-Experience
# License: GPL3

# Main var
DYNAMIC=false

### Initial vars
LOCALDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
WORKING="$LOCALDIR/working"

## Mount Point vars for system_new
SYSTEM_NEW_DIR="$WORKING/system_new"
SYSTEM_NEW_IMAGE="$WORKING/system_new.img"
SYSTEM_NEW=false

## Mount Point vars for system
SYSTEM_DIR="$WORKING/system"
SYSTEM_IMAGE="$WORKING/system.img"

## Mount Point vars for system_other
SYSTEM_OTHER_DIR="$WORKING/system_other"
SYSTEM_OTHER_IMAGE="$WORKING/system_other.img"
SYSTEM_OTHER=false

## Mount Point vars for product
PRODUCT_DIR="$WORKING/product"
PRODUCT_IMAGE="$WORKING/product.img"
PRODUCT=false

## Mount Point vars for odm
ODM_DIR="$WORKING/odm"
ODM_IMAGE="$WORKING/odm.img"
ODM=false

## Mount Point vars for oneplus partitions
ONEPLUS=false
RESERVE_DIR="$WORKING/reserve"
RESERVE_IMAGE="$WORKING/reserve.img"
INDIA_DIR="$WORKING/india"
INDIA_IMAGE="$WORKING/india.img"
OPPRODUCT_DIR="$WORKING/opproduct"
OPPRODUCT_IMAGE="$WORKING/opproduct.img"

## Mount Point vars for system_ext
SYSTEM_EXT_DIR="$WORKING/system_ext"
SYSTEM_EXT_IMAGE="$WORKING/system_ext.img"
SYSTEM_EXT=false

## Mount Point vars for vendor
VENDOR_DIR="$WORKING/vendor"
VENDOR_IMAGE="$WORKING/vendor.img"
OVERLAYS_VENDOR=false

if [ "${EUID}" -ne 0 ]; then
   echo "-> Run as root!"
fi

MOUNT() {
   if `sudo mount -o loop "$1" "$2" > /dev/null 2>&1`; then
      GOOD=true
   elif `sudo mount -o ro "$1" "$2" > /dev/null 2>&1`; then
      GOOD=true
   else
      # If it fails again, abort
      echo "-> Failed to mount $3 image, abort!"
      exit 1
   fi
}

CREDITS() {
   # Just a comment in build.prop
   echo "" >> build.prop
   echo "#############################" >> build.prop
   echo "# Merged by S(EXT)-P Merger #" >> build.prop
   echo "#         By Velosh         #" >> build.prop
   echo "#############################" >> build.prop
   echo "" >> build.prop
}

usage() {
   echo "Usage: $0 <Path to firmware>"
   echo -e "\tPath to firmware: the zip!"
   echo -e "\t--ext: Merge /system_ext partition in the system"
   echo -e "\t--odm: Merge /vendor/odm partition in the system (Recommended on Android 11)"
   echo -e "\t--product: Merge /product partition in the system"
   echo -e "\t--overlays: Take the overlays from /vendor and put them in a temporary folder and compress at the end of the process"
   echo -e "\t--oneplus: Merge oneplus partitions in the system (OxygenOS/HydrogenOS only)"
   echo -e "\t--pixel: Merge Pixel partitions in the system (Pixel/Generic from Google only)"
}

POSITIONAL=()
while [[ $# -gt 0 ]]; do
   key="$1"

   case $key in
   --product)
      PRODUCT=true
      SYSTEM_NEW=true
      shift
      ;;
   --odm)
      ODM=true
      SYSTEM_NEW=true
      shift
      ;;
   --ext)
      SYSTEM_EXT=true
      SYSTEM_NEW=true
      shift
      ;;
   --oneplus)
      ONEPLUS=true
      SYSTEM_NEW=true
      shift
      ;;
   --pixel)
      SYSTEM_OTHER=true
      shift
      ;;
   --overlays)
      OVERLAYS_VENDOR=true
      shift
      ;;
   --help | -h | -?)
      usage
      exit
      ;;
   *)
      POSITIONAL+=("$1")
      shift
      ;;
   esac
done
set -- "${POSITIONAL[@]}" # restore positional

if [ ! -d "$WORKING/" ]; then
   mkdir -p "$WORKING"
fi

if [[ ! -n $1 ]]; then
   echo "-> ERROR!"
   echo " - Enter all needed parameters"
   rm -rf "$WORKING"
   usage
   exit
fi

bash $LOCALDIR/zip2img.sh "$1" "$WORKING"

# system.img
if [ "$SYSTEM_NEW" == true ]; then
   if [ -f "$SYSTEM_IMAGE" ]; then
      # Check for AB/Aonly in system
      if [ -d "$SYSTEM_DIR" ]; then
         if [ -d "$SYSTEM_DIR/dev/" ]; then
            sudo umount "$SYSTEM_DIR/"
         else
            if [ -d "$SYSTEM_DIR/etc/" ]; then
               sudo umount "$SYSTEM_DIR/"
            fi
         fi
      fi
   else
      echo " -> System Image doesn't exists, abort!"
      exit 1
   fi
fi

# product.img
if [ "$PRODUCT" == true ]; then
   if [ -f "$PRODUCT_IMAGE" ]; then
      # Check if product is mounted
      if [ -d "$PRODUCT_DIR" ]; then
         if [ -d "$PRODUCT_DIR/etc/" ]; then
            sudo umount "$PRODUCT_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

# vendor.img
if [ $OVERLAYS_VENDOR == true ]; then
   if [ -f "$VENDOR_IMAGE" ]; then
      # Check if product is mounted
      if [ -d "$VENDOR_DIR" ]; then
         if [ -d "$VENDOR_DIR/etc/" ]; then
            sudo umount "$VENDOR_DIR/"
         fi
      fi
   fi
fi

# odm.img
if [ "$ODM" == true ]; then
   if [ -f "$ODM_IMAGE" ]; then
      # Check if odm is mounted
      if [ -d "$ODM_DIR" ]; then
         if [ -d "$ODM_DIR/etc/" ]; then
            sudo umount "$ODM_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

# OnePlus partitions
if [ "$ONEPLUS" == true ]; then
   if [ -f "$OPPRODUCT_IMAGE" ]; then
      # Check if opproduct is mounted
      if [ -d "$OPPRODUCT_DIR" ]; then
         if [ -d "$OPPRODUCT_DIR/etc/" ]; then
            sudo umount "$OPPRODUCT_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$RESERVE_IMAGE" ]; then
      # Check if reserve is mounted
      if [ -d "$RESERVE_DIR" ]; then
         if [ -d "$RESERVE_DIR/*" ]; then
            sudo umount "$RESERVE_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$INDIA_IMAGE" ]; then
      # Check if india is mounted
      if [ -d "$INDIA_DIR" ]; then
         if [ -d "$INDIA_DIR/*app*/" ]; then
            sudo umount "$INDIA_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

# system_other.img
if [ "$SYSTEM_OTHER" == true ]; then
   if [ -f "$SYSTEM_OTHER_IMAGE" ]; then
      # Check if system_other is mounted
      if [ -d "$SYSTEM_OTHER_DIR" ]; then
         if [ -d "$SYSTEM_OTHER_DIR/etc/" ]; then
            sudo umount "$SYSTEM_OTHER_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

# system_ext.img
if [ "$SYSTEM_EXT" == true ]; then
   if [ -f "$SYSTEM_EXT_IMAGE" ]; then
      # Check if product is mounted
      if [ -d "$SYSTEM_EXT_DIR" ]; then
         if [ -d "$SYSTEM_EXT_DIR/etc/" ]; then
            sudo umount "$SYSTEM_EXT_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

if [ "$DYNAMIC" == false ]; then
    echo "-> Abort due non-dynamic firmware or the options were not selected correctly."
    exit 1
else
    if [ "$SYSTEM_NEW" == true ]; then
        if [ -f "$SYSTEM_NEW_IMAGE" ]; then
            # Check for AB/Aonly in system_new
            if [ -d "$SYSTEM_NEW_DIR" ]; then
                if [ -d "$SYSTEM_NEW_DIR/dev/" ]; then
                    sudo umount "$SYSTEM_NEW_DIR/"
                else
                    if [ -d "$SYSTEM_NEW_DIR/etc/" ]; then
                        sudo umount "$SYSTEM_NEW_DIR/"
                    fi
                fi
            fi

            sudo rm -rf $SYSTEM_NEW_IMAGE $SYSTEM_NEW_DIR/
            sudo dd if=/dev/zero of=$SYSTEM_NEW_IMAGE bs=4k count=2048576 >/dev/null 2>&1
            sudo tune2fs -c0 -i0 $SYSTEM_NEW_IMAGE >/dev/null 2>&1
            sudo mkfs.ext4 $SYSTEM_NEW_IMAGE >/dev/null 2>&1

            if [ ! -f "$SYSTEM_NEW_IMAGE" ]; then
                echo " -> System New Image doesn't exists, abort!"
                exit 1
            fi
        else
            sudo rm -rf $SYSTEM_NEW_IMAGE $SYSTEM_NEW_DIR/
            sudo dd if=/dev/zero of=$SYSTEM_NEW_IMAGE bs=4k count=2048576 >/dev/null 2>&1
            sudo tune2fs -c0 -i0 $SYSTEM_NEW_IMAGE >/dev/null 2>&1
            sudo mkfs.ext4 $SYSTEM_NEW_IMAGE >/dev/null 2>&1
            
            if [ ! -f "$SYSTEM_NEW_IMAGE" ]; then
                echo " -> System New Image doesn't exists, abort!"
                exit 1
            fi
        fi
    fi
fi

if [ "$SYSTEM_NEW" == true ]; then
   if [ -f "$SYSTEM_IMAGE" ]; then
      if [ ! -d "$SYSTEM_DIR/" ]; then
         mkdir $SYSTEM_DIR
      fi
      MOUNT $SYSTEM_IMAGE $SYSTEM_DIR/ "System"
   fi
fi

if [ "$SYSTEM_NEW" == true ]; then
   if [ ! -d "$SYSTEM_NEW_DIR/" ]; then
      mkdir $SYSTEM_NEW_DIR
   fi
   MOUNT $SYSTEM_NEW_IMAGE $SYSTEM_NEW_DIR/ "System New"
fi

if [ "$PRODUCT" == true ]; then
   if [ -f "$PRODUCT_IMAGE" ]; then
      if [ ! -d "$PRODUCT_DIR/" ]; then
         mkdir $PRODUCT_DIR
      fi
      MOUNT $PRODUCT_IMAGE $PRODUCT_DIR/ "Product"
   fi
fi

if [ "$ODM" == true ]; then
   if [ -f "$ODM_IMAGE" ]; then
      if [ ! -d "$ODM_DIR/" ]; then
         mkdir $ODM_DIR
      fi
      MOUNT $ODM_IMAGE $ODM_DIR/ "ODM"
   fi
fi

if [ "$ONEPLUS" == true ]; then
   if [ -f "$OPPRODUCT_IMAGE" ]; then
      if [ ! -d "$OPPRODUCT_DIR/" ]; then
         mkdir $OPPRODUCT_DIR
      fi
      MOUNT $OPPRODUCT_IMAGE $OPPRODUCT_DIR/ "Opproduct"
   fi
   if [ -f "$RESERVE_IMAGE" ]; then
      if [ ! -d "$RESERVE_DIR/" ]; then
         mkdir $RESERVE_DIR
      fi
      MOUNT $RESERVE_IMAGE $RESERVE_DIR/ "Reserve"
   fi
   if [ -f "$INDIA_IMAGE" ]; then
      if [ ! -d "$INDIA_DIR/" ]; then
         mkdir $INDIA_DIR
      fi
      MOUNT $INDIA_IMAGE $INDIA_DIR/ "India"
   fi
fi

if [ "$SYSTEM_OTHER" == true ]; then
   if [ -f "$SYSTEM_OTHER_IMAGE" ]; then
      if [ ! -d "$SYSTEM_OTHER_DIR/" ]; then
         mkdir $SYSTEM_OTHER_DIR
      fi
      MOUNT $SYSTEM_OTHER_IMAGE $SYSTEM_OTHER_DIR/ "System Other"
   fi
fi

if [ "$SYSTEM_EXT" == true ]; then
   if [ -f "$SYSTEM_EXT_IMAGE" ]; then
      if [ ! -d "$SYSTEM_EXT_DIR/" ]; then
         mkdir $SYSTEM_EXT_DIR
      fi
      MOUNT $SYSTEM_EXT_IMAGE $SYSTEM_EXT_DIR/ "System Ext"
   fi
fi

if [ "$OVERLAYS_VENDOR" == true ]; then
   if [ -f "$VENDOR_IMAGE" ]; then
      if [ ! -d "$VENDOR_DIR/" ]; then
         mkdir $VENDOR_DIR
      fi
      MOUNT $VENDOR_IMAGE $VENDOR_DIR "Vendor"
   fi
fi

if [ "$SYSTEM_NEW" == true ]; then
   cp -v -r -p $SYSTEM_DIR/* $SYSTEM_NEW_DIR/ >/dev/null 2>&1 && sync
   if [ -d "$SYSTEM_NEW_DIR/dev/" ]; then
      cd $WORKING/system_new/system/
      CREDITS
   else
      cd $SYSTEM_NEW_DIR
      CREDITS
   fi
   umount $SYSTEM_DIR/
fi
cd $WORKING

if [ "$PRODUCT" == true ]; then
   if [ -f "$PRODUCT_IMAGE" ]; then
      if [ -d "$SYSTEM_NEW_DIR/dev/" ]; then
         cd $WORKING/system_new/
         rm -rf product
         cd system
         rm -rf product
         mkdir -p product/
         cp -v -r -p $PRODUCT_DIR/* product/ >/dev/null 2>&1
         cd ../
         ln -s /system/product/ product
         sync
      fi
   fi
   cd $WORKING
fi

if [ "$PRODUCT" == true ]; then
   if [ -f "$PRODUCT_IMAGE" ]; then
      sudo umount $PRODUCT_DIR/
   fi
fi

if [ "$ODM" == true ]; then
   if [ -f "$ODM_IMAGE" ]; then

      # Patch: Copy ODM Feature List of OnePlus
      if [ -f "$ODM_DIR/etc/odm_feature_list" ]; then
         cp -r "$ODM_DIR/etc/odm_feature_list" "$SYSTEM_NEW_DIR/system/etc/odm_feature_list"
      fi

      # Patch: Copy ODM overlays to temp folder (Recommended)
      if [ -d "$ODM_DIR/overlay" ]; then
         # If yes we'll copy overlays

         mkdir -p "$WORKING/odmOverlays"
         cp -v -r -p $ODM_DIR/overlay/* "$WORKING/odmOverlays" >/dev/null 2>&1

         cd "$WORKING/odmOverlays/"
         rm -rf home && cd ../
         tar -zcvf odmOverlays.tar.gz "$WORKING/odmOverlays" >/dev/null 2>&1

         rm -rf $WORKING/odmOverlays/

         if [ ! -d "$LOCALDIR/output/" ]; then
            mkdir "$LOCALDIR/output/"
         fi

         # Move to temp path, Erfan will recognize and rename
         mv "$WORKING/odmOverlays.tar.gz" "$LOCALDIR/output/.otmp"
      fi
   fi
   cd $WORKING
fi

if [ "$ODM" == true ]; then
   if [ -f "$ODM_IMAGE" ]; then
      sudo umount $ODM_DIR/
   fi
fi

if [ "$SYSTEM_OTHER" == true ]; then
   if [ -f "$SYSTEM_OTHER_IMAGE" ]; then
      if [ -d "$SYSTEM_NEW_DIR/dev/" ]; then
         cd $WORKING/system_new/
         cp -v -r -p $SYSTEM_OTHER_DIR/* system/ >/dev/null 2>&1 && sync
      fi
   fi
   cd $WORKING
fi

if [ "$SYSTEM_OTHER" == true ]; then
   if [ -f "$SYSTEM_OTHER_IMAGE" ]; then
      sudo umount $SYSTEM_OTHER_DIR/
   fi
fi

if [ "$ONEPLUS" == true ]; then
   if [ -f "$OPPRODUCT_IMAGE" ]; then
      if [ -d "$SYSTEM_NEW_DIR/dev/" ]; then
         cd $WORKING/system_new/
         rm -rf oneplus
         cd system
         rm -rf oneplus
         mkdir -p oneplus/
         cp -v -r -p $OPPRODUCT_DIR/* oneplus/ >/dev/null 2>&1
         cd ../
         ln -s /system/oneplus/ oneplus
         sync
      fi
      if [ -f "$RESERVE_IMAGE" ]; then
         if [ -d "$SYSTEM_NEW_DIR/dev/" ]; then
            cd $WORKING/system_new/system
            rm -rf reserve
            mkdir -p reserve/
            cp -v -r -p $RESERVE_DIR/* reserve/ >/dev/null 2>&1
            cd ../
            sync
         fi
      fi
      if [ -f "$INDIA_IMAGE" ]; then
         if [ -d "$SYSTEM_NEW_DIR/dev/" ]; then
            cd $WORKING/system_new/system
            rm -rf india
            mkdir -p india/
            cp -v -r -p $INDIA_DIR/* india/ >/dev/null 2>&1
            cd ../
            sync
         fi
      fi
   fi
   cd $WORKING
fi

if [ "$ONEPLUS" == true ]; then
   if [ -f "$OPPRODUCT_IMAGE" ]; then
      sudo umount $OPPRODUCT_DIR/
   fi
   if [ -f "$RESERVE_IMAGE" ]; then
      sudo umount $RESERVE_DIR/
   fi
   if [ -f "$INDIA_IMAGE" ]; then
      sudo umount $INDIA_DIR/
   fi
fi

if [ "$SYSTEM_EXT" == true ]; then
   if [ -f "$SYSTEM_EXT_IMAGE" ]; then
      if [ -d "$SYSTEM_NEW_DIR/dev/" ]; then
         cd $WORKING/system_new/
         rm -rf system_ext
         cd system
         rm -rf system_ext
         mkdir -p system_ext/
         cp -v -r -p $SYSTEM_EXT_DIR/* system_ext/ >/dev/null 2>&1
         cd ../
         ln -s /system/system_ext/ system_ext
         sync
      else
         cd $SYSTEM_NEW_DIR
         rm -rf system_ext
         mkdir system_ext && cd ../
         cp -v -r -p $SYSTEM_EXT/* $SYSTEM_NEW_DIR/system_ext/ >/dev/null 2>&1 && sync
         cd $WORKING
      fi
   fi
   cd $WORKING
fi

if [ "$SYSTEM_EXT" == true ]; then
   if [ -f "$SYSTEM_EXT_IMAGE" ]; then
      sudo umount $SYSTEM_EXT_DIR/
   fi
fi

if [ "$SYSTEM_NEW" == true ]; then
   sudo umount $SYSTEM_NEW_DIR/
fi

if [ "$OVERLAYS_VENDOR" == true ]; then
   if [ -f "$VENDOR_IMAGE" ]; then
      # Check if have anything in vendor
      if [ -d "$VENDOR_DIR/overlay" ]; then
         # If yes we'll copy overlays
         mkdir -p "$WORKING/vendorOverlays"
         cp -v -r -p $VENDOR_DIR/overlay/* vendorOverlays/ >/dev/null 2>&1
         cd "$WORKING/vendorOverlays/"
         rm -rf home && cd ../
         tar -zcvf vendorOverlays.gz vendorOverlays/ >/dev/null 2>&1
         rm -rf $WORKING/vendorOverlays/
         if [ ! -d "$LOCALDIR/output/" ]; then
            mkdir "$LOCALDIR/output/"
         fi
         mv "$WORKING/vendorOverlays.gz" "$LOCALDIR/output/.tmp"
      fi
   fi
fi

if [ "$OVERLAYS_VENDOR" == true ]; then
   if [ -f "$VENDOR_IMAGE" ]; then
      sudo umount $VENDOR_DIR/
   fi
fi

mv $WORKING/system_new.img $WORKING/system.tmp
sudo rm -rf $SYSTEM_DIR $SYSTEM_NEW_DIR $PRODUCT_DIR $SYSTEM_IMAGE $SYSTEM_OTHER_DIR $SYSTEM_OTHER_IMAGE $PRODUCT_IMAGE $SYSTEM_EXT_DIR $SYSTEM_EXT_IMAGE $OPPRODUCT_DIR $OPPRODUCT_IMAGE $ODM_DIR $ODM_IMAGE $VENDOR_DIR

if [ "$SYSTEM_NEW" == true ]; then
   mv system.tmp system.img
fi
