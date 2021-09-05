#!/bin/bash

# Merge S-P by Velosh @ Treble-Experience
# License: GPL3

# Main var
DYNAMIC=false

### Initial vars
PROJECT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
WORKING="$PROJECT_DIR/working"

SYSTEM_NEW_DIR="$WORKING/system_new"
SYSTEM_NEW_IMAGE="$WORKING/system_new.img"
SYSTEM_NEW=false

SYSTEM_DIR="$WORKING/system"
SYSTEM_IMAGE="$WORKING/system.img"

SYSTEM_OTHER_DIR="$WORKING/system_other"
SYSTEM_OTHER_IMAGE="$WORKING/system_other.img"
SYSTEM_OTHER=false

PRODUCT_DIR="$WORKING/product"
PRODUCT_IMAGE="$WORKING/product.img"
PRODUCT=false

ODM_DIR="$WORKING/odm"
ODM_IMAGE="$WORKING/odm.img"
ODM=false

ONEPLUS=false
RESERVE_DIR="$WORKING/reserve"
RESERVE_IMAGE="$WORKING/reserve.img"
INDIA_DIR="$WORKING/india"
INDIA_IMAGE="$WORKING/india.img"
OPPRODUCT_DIR="$WORKING/opproduct"
OPPRODUCT_IMAGE="$WORKING/opproduct.img"

SYSTEM_EXT_DIR="$WORKING/system_ext"
SYSTEM_EXT_IMAGE="$WORKING/system_ext.img"
SYSTEM_EXT=false

VENDOR_DIR="$WORKING/vendor"
VENDOR_IMAGE="$WORKING/vendor.img"
OVERLAYS_VENDOR=false

MIUI=false

if [ "${EUID}" -ne 0 ]; then
   echo "-> Run as root!"
fi

MOUNT() {
   if $(sudo mount -o loop "$1" "$2" >/dev/null 2>&1); then
      GOOD=true
   elif $(sudo mount -o ro "$1" "$2" >/dev/null 2>&1); then
      GOOD=true
   else
      echo "-> Failed to mount $3 image, abort!"
      exit 1
   fi
}

usage() {
   echo "Usage: $0 <Path to firmware>"
   echo -e "\tPath to firmware: the zip!"
   echo -e "\t--ext: Merge system_ext partition into system"
   echo -e "\t--odm: Merge odm_feature_list (OnePlus) into system & try to get odm overlays"
   echo -e "\t--product: Merge product partition into system"
   echo -e "\t--overlays: Take the overlays from /vendor and put them in a temporary folder and compress at the end of the GSI process"
   echo -e "\t--oneplus: Merge oneplus partitions into system (OxygenOS/HydrogenOS only)"
   echo -e "\t--pixel: Merge Pixel partitions into system (Pixel/Generic from Google only)"
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
   --miui)
      MIUI=true
      SYSTEM_NEW=true
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
set -- "${POSITIONAL[@]}"

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

bash "${PROJECT_DIR}/zip2img.sh" "$1" "$WORKING"

if [ "$SYSTEM_NEW" == true ]; then
   if [ -f "$SYSTEM_IMAGE" ]; then
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
      echo "-> System Image doesn't exists, abort!"
      exit 1
   fi
fi

if [ "$PRODUCT" == true ]; then
   if [ -f "$PRODUCT_IMAGE" ]; then
      if [ -d "$PRODUCT_DIR" ]; then
         if [ -d "$PRODUCT_DIR/etc/" ]; then
            sudo umount "$PRODUCT_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

if [[ $OVERLAYS_VENDOR == true || $MIUI == true ]]; then
   if [ -f "$VENDOR_IMAGE" ]; then
      if [ -d "$VENDOR_DIR" ]; then
         if [ -d "$VENDOR_DIR/etc/" ]; then
            sudo umount "$VENDOR_DIR/"
         fi
      fi
   fi
fi

if [ "$ODM" == true ]; then
   if [ -f "$ODM_IMAGE" ]; then
      if [ -d "$ODM_DIR" ]; then
         if [ -d "$ODM_DIR/etc/" ]; then
            sudo umount "$ODM_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

if [ "$ONEPLUS" == true ]; then
   if [ -f "$OPPRODUCT_IMAGE" ]; then
      if [ -d "$OPPRODUCT_DIR" ]; then
         if [ -d "$OPPRODUCT_DIR/etc/" ]; then
            sudo umount "$OPPRODUCT_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$RESERVE_IMAGE" ]; then
      if [ -d "$RESERVE_DIR" ]; then
         if [ -d "$RESERVE_DIR/*" ]; then
            sudo umount "$RESERVE_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$INDIA_IMAGE" ]; then
      if [ -d "$INDIA_DIR" ]; then
         if [ -d "$INDIA_DIR/*app*/" ]; then
            sudo umount "$INDIA_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

if [ "$SYSTEM_OTHER" == true ]; then
   if [ -f "$SYSTEM_OTHER_IMAGE" ]; then
      if [ -d "$SYSTEM_OTHER_DIR" ]; then
         if [ -d "$SYSTEM_OTHER_DIR/etc/" ]; then
            sudo umount "$SYSTEM_OTHER_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

if [ "$SYSTEM_EXT" == true ]; then
   if [ -f "$SYSTEM_EXT_IMAGE" ]; then
      if [ -d "$SYSTEM_EXT_DIR" ]; then
         if [ -d "$SYSTEM_EXT_DIR/etc/" ]; then
            sudo umount "$SYSTEM_EXT_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
fi

if [[ "$DYNAMIC" == false && "$MIUI" == false ]]; then
   echo "-> Abort due non-dynamic firmware or the options were not selected correctly."
   exit 1
else
   if [ "$SYSTEM_NEW" == true ]; then
      if [ -f "$SYSTEM_NEW_IMAGE" ]; then
         if [ -d "$SYSTEM_NEW_DIR" ]; then
            if [ -d "$SYSTEM_NEW_DIR/dev/" ]; then
               sudo umount "$SYSTEM_NEW_DIR/"
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

if [[ "$OVERLAYS_VENDOR" == true || "$MIUI" == true ]]; then
   if [ -f "$VENDOR_IMAGE" ]; then
      if [ ! -d "$VENDOR_DIR/" ]; then
         mkdir $VENDOR_DIR
      fi
      MOUNT $VENDOR_IMAGE $VENDOR_DIR "Vendor"
   fi
fi

if [ "$SYSTEM_NEW" == true ]; then
   cp -vrp $SYSTEM_DIR/* $SYSTEM_NEW_DIR/ >/dev/null 2>&1 && sync
   umount $SYSTEM_DIR/
fi

if [ "$PRODUCT" == true ]; then
   if [ -f "$PRODUCT_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/product $SYSTEM_NEW_DIR/system/product
      mkdir -p $SYSTEM_NEW_DIR/system/product
      cp -vrp $PRODUCT_DIR/* $SYSTEM_NEW_DIR/system/product/ >/dev/null 2>&1
      ln -s /system/product/ $SYSTEM_NEW_DIR/product
      sync
   fi
fi

if [ "$PRODUCT" == true ]; then
   if [ -f "$PRODUCT_IMAGE" ]; then
      sudo umount $PRODUCT_DIR/
   fi
fi

if [ "$ODM" == true ]; then
   if [ -f "$ODM_IMAGE" ]; then
      if [ -f "$ODM_DIR/etc/odm_feature_list" ]; then
         cp -r "$ODM_DIR/etc/odm_feature_list" "$SYSTEM_NEW_DIR/system/etc/odm_feature_list"
      fi
      if [ -d "$ODM_DIR/overlay" ]; then
         mkdir -p "$WORKING/odmOverlays"
         cp -vrp $ODM_DIR/overlay/* "$WORKING/odmOverlays" >/dev/null 2>&1
         rm -rf "$WORKING/odmOverlays/home"
         tar -zcvf "$WORKING/odmOverlays.gz" "$WORKING/odmOverlays" >/dev/null 2>&1
         rm -rf $WORKING/odmOverlays/
         if [ ! -d "$PROJECT_DIR/output/" ]; then
            mkdir "$PROJECT_DIR/output/"
         fi
         mv "$WORKING/odmOverlays.gz" "$PROJECT_DIR/output/.otmp"
      fi
   fi
fi

if [ "$ODM" == true ]; then
   if [ -f "$ODM_IMAGE" ]; then
      sudo umount $ODM_DIR/
   fi
fi

if [ "$SYSTEM_OTHER" == true ]; then
   if [ -f "$SYSTEM_OTHER_IMAGE" ]; then
      cp -vrp $SYSTEM_OTHER_DIR/* system/ >/dev/null 2>&1 && sync
   fi
fi

if [ "$SYSTEM_OTHER" == true ]; then
   if [ -f "$SYSTEM_OTHER_IMAGE" ]; then
      sudo umount $SYSTEM_OTHER_DIR/
   fi
fi

if [ "$ONEPLUS" == true ]; then
   if [ -f "$OPPRODUCT_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/oneplus $SYSTEM_NEW_DIR/system/oneplus
      mkdir -p $SYSTEM_NEW_DIR/system/oneplus
      cp -vrp $OPPRODUCT_DIR/* $SYSTEM_NEW_DIR/system/oneplus/ >/dev/null 2>&1
      ln -s /system/oneplus/ $SYSTEM_NEW_DIR/oneplus
      sync
      if [ -f "$RESERVE_IMAGE" ]; then
         rm -rf $SYSTEM_NEW_DIR/system/reserve
         mkdir -p $SYSTEM_NEW_DIR/system/reserve
         cp -vrp $RESERVE_DIR/* $SYSTEM_NEW_DIR/system/reserve/ >/dev/null 2>&1
         sync
      fi
      if [ -f "$INDIA_IMAGE" ]; then
         rm -rf $SYSTEM_NEW_DIR/system/india
         mkdir -p $SYSTEM_NEW_DIR/system/india
         cp -vrp $INDIA_DIR/* $SYSTEM_NEW_DIR/system/india/ >/dev/null 2>&1
         sync
      fi
   fi
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
      rm -rf $SYSTEM_NEW_DIR/system_ext $SYSTEM_NEW_DIR/system/system_ext
      mkdir -p $SYSTEM_NEW_DIR/system/system_ext
      cp -vrp $SYSTEM_EXT_DIR/* $SYSTEM_NEW_DIR/system/system_ext/ >/dev/null 2>&1
      ln -s /system/system_ext/ $SYSTEM_NEW_DIR/system_ext
      sync
   fi
fi

if [ "$SYSTEM_EXT" == true ]; then
   if [ -f "$SYSTEM_EXT_IMAGE" ]; then
      sudo umount $SYSTEM_EXT_DIR/
   fi
fi

if [[ "$OVERLAYS_VENDOR" == true || "$MIUI" == true ]]; then
   if [ -f "$VENDOR_IMAGE" ]; then
      if [[ -d "$VENDOR_DIR/overlay" && "$OVERLAYS_VENDOR" == true ]]; then
         mkdir -p "$WORKING/vendorOverlays"
         cp -vrp $VENDOR_DIR/overlay/* "$WORKING/vendorOverlays" >/dev/null 2>&1
         rm -rf "$WORKING/vendorOverlays/home"
         tar -zcvf "$WORKING/vendorOverlays.gz" "$WORKING/vendorOverlays" >/dev/null 2>&1
         rm -rf $WORKING/vendorOverlays/
         if [ ! -d "$PROJECT_DIR/output/" ]; then
            mkdir "$PROJECT_DIR/output/"
         fi
         mv "$WORKING/vendorOverlays.gz" "$PROJECT_DIR/output/.tmp"
      fi
      if [[ -d "$VENDOR_DIR/etc/device_features" && "$MIUI" == true ]]; then
         if [ ! -d "$SYSTEM_NEW_DIR/system/etc/device_features" ]; then
            cp -frp "$VENDOR_DIR/etc/device_features" "$SYSTEM_NEW_DIR/system/etc" && sync
         fi
      fi
   fi
fi

if [[ "$OVERLAYS_VENDOR" == true || "$MIUI" == true ]]; then
   if [ -f "$VENDOR_IMAGE" ]; then
      sudo umount $VENDOR_DIR/
   fi
fi

if [ "$SYSTEM_NEW" == true ]; then
   sudo umount $SYSTEM_NEW_DIR/
fi

mv $WORKING/system_new.img $WORKING/system.tmp
sudo rm -rf $SYSTEM_DIR $SYSTEM_NEW_DIR $PRODUCT_DIR $SYSTEM_IMAGE $SYSTEM_OTHER_DIR $SYSTEM_OTHER_IMAGE $PRODUCT_IMAGE $SYSTEM_EXT_DIR $SYSTEM_EXT_IMAGE $OPPRODUCT_DIR $OPPRODUCT_IMAGE $ODM_DIR $ODM_IMAGE $VENDOR_DIR

if [ "$SYSTEM_NEW" == true ]; then
   mv $WORKING/system.tmp $WORKING/system.img
fi
