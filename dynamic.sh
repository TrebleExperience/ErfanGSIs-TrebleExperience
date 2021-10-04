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

OPPO=false
MY_ENGINEERING_IMAGE="$WORKING/my_engineering.img"
MY_ENGINEERING_DIR="$WORKING/my_engineering"
MY_COMPANY_IMAGE="$WORKING/my_company.img"
MY_COMPANY_DIR="$WORKING/my_company"
MY_PRODUCT_IMAGE="$WORKING/my_product.img"
MY_PRODUCT_DIR="$WORKING/my_product"
MY_CARRIER_IMAGE="$WORKING/my_carrier.img"
MY_CARRIER_DIR="$WORKING/my_carrier"
MY_CUSTOM_IMAGE="$WORKING/my_custom.img"
MY_CUSTOM_DIR="$WORKING/my_custom"
MY_PRELOAD_IMAGE="$WORKING/my_preload.img"
MY_PRELOAD_DIR="$WORKING/my_preload"
MY_MANIFEST_IMAGE="$WORKING/my_manifest.img"
MY_MANIFEST_DIR="$WORKING/my_manifest"
MY_REGION_IMAGE="$WORKING/my_region.img"
MY_REGION_DIR="$WORKING/my_region"
MY_ODM_IMAGE="$WORKING/my_odm.img"
MY_ODM_DIR="$WORKING/my_odm"
MY_STOCK_IMAGE="$WORKING/my_stock.img"
MY_STOCK_DIR="$WORKING/my_stock"
MY_VERSION_IMAGE="$WORKING/my_version.img"
MY_VERSION_DIR="$WORKING/my_version"
MY_OPERATOR_IMAGE="$WORKING/my_operator.img"
MY_OPERATOR_DIR="$WORKING/my_operator"
MY_COUNTRY_IMAGE="$WORKING/my_country.img"
MY_COUNTRY_DIR="$WORKING/my_country"
MY_HEYTAP_IMAGE="$WORKING/my_heytap.img"
MY_HEYTAP_DIR="$WORKING/my_heytap"

if [ "${EUID}" -ne 0 ]; then
   echo "-> Run as root!"
   exit 1
fi

MOUNT() {
   if $(sudo mount -o loop "$1" "$2" >/dev/null 2>&1); then
      GOOD=true
   elif $(sudo mount -o ro "$1" "$2" >/dev/null 2>&1); then
      GOOD=true
   elif $(sudo mount -o ro -t erofs "$1" "$2" >/dev/null 2>&1); then
      GOOD=true
   elif $(sudo mount -o loop -t erofs "$1" "$2" >/dev/null 2>&1); then
      GOOD=true
   else
      echo "-> Failed to mount $3 image, abort!"
      exit 1
   fi
}

UMOUNT_ALL() {
   for partition in "$(pwd)/working/*"; do
      if [ -d "$partition" ]; then
         umount -f $partition >> /dev/null 2>&1 || true
         umount -l $partition >> /dev/null 2>&1 || true
      fi
   done
   rm -rf "$(pwd)/working/*"
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
   echo -e "\t--miui: Copy device-features stuff from vendor into system"
   echo -e "\t--oppo: Merge oppo (RealmeUI for eg) partitions into system"
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
   --oppo)
      OPPO=true
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

# Umount all partitions
UMOUNT_ALL

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

if [ "$OPPO" == true ]; then
   if [ -f "$MY_COMPANY_IMAGE" ]; then
      if [ -d "$MY_COMPANY_DIR" ]; then
         if [ -d "$MY_COMPANY_DIR/etc/" ]; then
            sudo umount "$MY_COMPANY_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_ENGINEERING_IMAGE" ]; then
      if [ -d "$MY_ENGINEERING_DIR" ]; then
         if [ -d "$MY_ENGINEERING_DIR/etc" ]; then
            sudo umount "$MY_ENGINEERING_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_PRODUCT_IMAGE" ]; then
      if [ -d "$MY_PRODUCT_DIR" ]; then
         if [ -d "$MY_PRODUCT_DIR/etc/" ]; then
            sudo umount "$INDIA_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_CARRIER_IMAGE" ]; then
      if [ -d "$MY_CARRIER_DIR" ]; then
         if [ -d "$MY_CARRIER_DIR/etc/" ]; then
            sudo umount "$MY_CARRIER_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_CUSTOM_IMAGE" ]; then
      if [ -d "$MY_CUSTOM_DIR" ]; then
         if [ -d "$MY_CUSTOM_DIR/etc" ]; then
            sudo umount "$MY_CUSTOM_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_PRELOAD_IMAGE" ]; then
      if [ -d "$MY_PRELOAD_DIR" ]; then
         if [ -d "$MY_PRELOAD_DIR/etc/" ]; then
            sudo umount "$MY_PRELOAD_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_MANIFEST_IMAGE" ]; then
      if [ -d "$MY_MANIFEST_DIR" ]; then
         if [ -d "$MY_MANIFEST_DIR/etc/" ]; then
            sudo umount "$MY_MANIFEST_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_REGION_IMAGE" ]; then
      if [ -d "$MY_REGION_DIR" ]; then
         if [ -d "$MY_REGION_DIR/etc/" ]; then
            sudo umount "$MY_REGION_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_ODM_IMAGE" ]; then
      if [ -d "$MY_ODM_DIR" ]; then
         if [ -d "$MY_ODM_DIR/etc/" ]; then
            sudo umount "$MY_ODM_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_STOCK_IMAGE" ]; then
      if [ -d "$MY_STOCK_DIR" ]; then
         if [ -d "$MY_STOCK_DIR/etc/" ]; then
            sudo umount "$MY_STOCK_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_VERSION_IMAGE" ]; then
      if [ -d "$MY_VERSION_DIR" ]; then
         if [ -d "$MY_VERSION_DIR/etc/" ]; then
            sudo umount "$MY_VERSION_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_OPERATOR_IMAGE" ]; then
      if [ -d "$MY_OPERATOR_DIR" ]; then
         if [ -d "$MY_OPERATOR_DIR/etc/" ]; then
            sudo umount "$MY_OPERATOR_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_COUNTRY_IMAGE" ]; then
      if [ -d "$MY_COUNTRY_DIR" ]; then
         if [ -d "$MY_COUNTRY_DIR/etc/" ]; then
            sudo umount "$MY_COUNTRY_DIR/"
         fi
      fi
      DYNAMIC=true
   fi
   if [ -f "$MY_HEYTAP_IMAGE" ]; then
      if [ -d "$MY_HEYTAP_DIR" ]; then
         if [ -d "$MY_HEYTAP_DIR/etc/" ]; then
            sudo umount "$MY_HEYTAP_DIR/"
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

if [ "$OPPO" == true ]; then
   if [ -f "$MY_COMPANY_IMAGE" ]; then
      if [ ! -d "$MY_COMPANY_DIR/" ]; then
         mkdir $MY_COMPANY_DIR
      fi
      MOUNT $MY_COMPANY_IMAGE $MY_COMPANY_DIR/ "my_company"
   fi
   if [ -f "$MY_ENGINEERING_IMAGE" ]; then
      if [ ! -d "$MY_ENGINEERING_DIR/" ]; then
         mkdir $MY_ENGINEERING_DIR
      fi
      MOUNT $MY_ENGINEERING_IMAGE $MY_ENGINEERING_DIR/ "my_engineering"
   fi
   if [ -f "$MY_PRODUCT_IMAGE" ]; then
      if [ ! -d "$MY_PRODUCT_DIR/" ]; then
         mkdir $MY_PRODUCT_DIR
      fi
      MOUNT $MY_PRODUCT_IMAGE $MY_PRODUCT_DIR/ "my_product"
   fi
   if [ -f "$MY_CARRIER_IMAGE" ]; then
      if [ ! -d "$MY_CARRIER_DIR/" ]; then
         mkdir $MY_CARRIER_DIR
      fi
      MOUNT $MY_CARRIER_IMAGE $MY_CARRIER_DIR/ "my_carrier"
   fi
   if [ -f "$MY_CUSTOM_IMAGE" ]; then
      if [ ! -d "$MY_CUSTOM_DIR/" ]; then
         mkdir $MY_CUSTOM_DIR
      fi
      MOUNT $MY_CUSTOM_IMAGE $MY_CUSTOM_DIR/ "my_custom"
   fi
   if [ -f "$MY_PRELOAD_IMAGE" ]; then
      if [ ! -d "$MY_PRELOAD_DIR/" ]; then
         mkdir $MY_PRELOAD_DIR
      fi
      MOUNT $MY_PRELOAD_IMAGE $MY_PRELOAD_DIR/ "my_preload"
   fi
   if [ -f "$MY_MANIFEST_IMAGE" ]; then
      if [ ! -d "$MY_MANIFEST_DIR/" ]; then
         mkdir $MY_MANIFEST_DIR
      fi
      MOUNT $MY_MANIFEST_IMAGE $MY_MANIFEST_DIR/ "my_manifest"
   fi
   if [ -f "$MY_REGION_IMAGE" ]; then
      if [ ! -d "$MY_REGION_DIR/" ]; then
         mkdir $MY_REGION_DIR
      fi
      MOUNT $MY_REGION_IMAGE $MY_REGION_DIR/ "my_region"
   fi
   if [ -f "$MY_ODM_IMAGE" ]; then
      if [ ! -d "$MY_ODM_DIR/" ]; then
         mkdir $MY_ODM_DIR
      fi
      MOUNT $MY_ODM_IMAGE $MY_ODM_DIR/ "my_odm"
   fi
   if [ -f "$MY_STOCK_IMAGE" ]; then
      if [ ! -d "$MY_STOCK_DIR/" ]; then
         mkdir $MY_STOCK_DIR
      fi
      MOUNT $MY_STOCK_IMAGE $MY_STOCK_DIR/ "my_stock"
   fi
   if [ -f "$MY_VERSION_IMAGE" ]; then
      if [ ! -d "$MY_VERSION_DIR/" ]; then
         mkdir $MY_VERSION_DIR
      fi
      MOUNT $MY_VERSION_IMAGE $MY_VERSION_DIR/ "my_version"
   fi
   if [ -f "$MY_OPERATOR_IMAGE" ]; then
      if [ ! -d "$MY_OPERATOR_DIR/" ]; then
         mkdir $MY_OPERATOR_DIR
      fi
      MOUNT $MY_OPERATOR_IMAGE $MY_OPERATOR_DIR/ "my_operator"
   fi
   if [ -f "$MY_COUNTRY_IMAGE" ]; then
      if [ ! -d "$MY_COUNTRY_DIR/" ]; then
         mkdir $MY_COUNTRY_DIR
      fi
      MOUNT $MY_COUNTRY_IMAGE $MY_COUNTRY_DIR/ "my_country"
   fi
   if [ -f "$MY_HEYTAP_IMAGE" ]; then
      if [ ! -d "$MY_HEYTAP_DIR/" ]; then
         mkdir $MY_HEYTAP_DIR
      fi
      MOUNT $MY_HEYTAP_IMAGE $MY_HEYTAP_DIR/ "my_heytap"
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
   cp -frp $SYSTEM_DIR/* $SYSTEM_NEW_DIR/ >/dev/null 2>&1 && sync
   umount $SYSTEM_DIR/
fi

if [ "$PRODUCT" == true ]; then
   if [ -f "$PRODUCT_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/product $SYSTEM_NEW_DIR/system/product
      mkdir -p $SYSTEM_NEW_DIR/system/product
      cp -frp $PRODUCT_DIR/* $SYSTEM_NEW_DIR/system/product/ >/dev/null 2>&1
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
         cp -frp $ODM_DIR/overlay/* "$WORKING/odmOverlays" >/dev/null 2>&1
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
      cp -frp $SYSTEM_OTHER_DIR/* system/ >/dev/null 2>&1 && sync
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
      cp -frp $OPPRODUCT_DIR/* $SYSTEM_NEW_DIR/system/oneplus/ >/dev/null 2>&1
      ln -s /system/oneplus/ $SYSTEM_NEW_DIR/oneplus
      sync
   fi
   if [ -f "$RESERVE_IMAGE" ]; then
      [[ ! -d $SYSTEM_NEW_DIR/system/reserve ]] && mkdir -p $SYSTEM_NEW_DIR/system/reserve
      cp -frp $RESERVE_DIR/* $SYSTEM_NEW_DIR/system/reserve/ >/dev/null 2>&1
      sync
   fi
   if [ -f "$INDIA_IMAGE" ]; then
      [[ ! -d $SYSTEM_NEW_DIR/system/india ]] && mkdir -p $SYSTEM_NEW_DIR/system/india
      cp -frp $INDIA_DIR/* $SYSTEM_NEW_DIR/system/india/ >/dev/null 2>&1
      sync
   fi
fi

if [ "$OPPO" == true ]; then
   if [ -f "$MY_COMPANY_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_company
      mkdir -p $SYSTEM_NEW_DIR/my_company
      chmod 0755 $SYSTEM_NEW_DIR/my_company
      chown -R root:root $SYSTEM_NEW_DIR/my_company
      cp -frp $MY_COMPANY_DIR/* $SYSTEM_NEW_DIR/my_company >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_ENGINEERING_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_engineering
      mkdir -p $SYSTEM_NEW_DIR/my_engineering
      chmod 0755 $SYSTEM_NEW_DIR/my_engineering
      chown -R root:root $SYSTEM_NEW_DIR/my_engineering
      cp -frp $MY_ENGINEERING_DIR/* $SYSTEM_NEW_DIR/my_engineering >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_PRODUCT_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_product
      mkdir -p $SYSTEM_NEW_DIR/my_product
      chmod 0755 $SYSTEM_NEW_DIR/my_product
      chown -R root:root $SYSTEM_NEW_DIR/my_product
      cp -frp $MY_PRODUCT_DIR/* $SYSTEM_NEW_DIR/my_product >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_CARRIER_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_carrier
      mkdir -p $SYSTEM_NEW_DIR/my_carrier
      chmod 0755 $SYSTEM_NEW_DIR/my_carrier
      chown -R root:root $SYSTEM_NEW_DIR/my_carrier
      cp -frp $MY_CARRIER_DIR/* $SYSTEM_NEW_DIR/my_carrier >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_CUSTOM_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_custom
      mkdir -p $SYSTEM_NEW_DIR/my_custom
      chmod 0755 $SYSTEM_NEW_DIR/my_custom
      chown -R root:root $SYSTEM_NEW_DIR/my_custom
      cp -frp $MY_CUSTOM_DIR/* $SYSTEM_NEW_DIR/my_custom >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_PRELOAD_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_preload
      mkdir -p $SYSTEM_NEW_DIR/my_preload
      chmod 0755 $SYSTEM_NEW_DIR/my_preload
      chown -R root:root $SYSTEM_NEW_DIR/my_preload
      cp -frp $MY_PRELOAD_DIR/* $SYSTEM_NEW_DIR/my_preload >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_MANIFEST_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_manifest
      mkdir -p $SYSTEM_NEW_DIR/my_manifest
      chmod 0755 $SYSTEM_NEW_DIR/my_manifest
      chown -R root:root $SYSTEM_NEW_DIR/my_manifest
      cp -frp $MY_MANIFEST_DIR/* $SYSTEM_NEW_DIR/my_manifest >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_REGION_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_region
      mkdir -p $SYSTEM_NEW_DIR/my_region
      chmod 0755 $SYSTEM_NEW_DIR/my_region
      chown -R root:root $SYSTEM_NEW_DIR/my_region
      cp -frp $MY_REGION_DIR/* $SYSTEM_NEW_DIR/my_region >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_ODM_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_odm
      mkdir -p $SYSTEM_NEW_DIR/my_odm
      chmod 0755 $SYSTEM_NEW_DIR/my_odm
      chown -R root:root $SYSTEM_NEW_DIR/my_odm
      cp -frp $MY_ODM_DIR/* $SYSTEM_NEW_DIR/my_odm >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_STOCK_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_stock
      mkdir -p $SYSTEM_NEW_DIR/my_stock
      chmod 0755 $SYSTEM_NEW_DIR/my_stock
      chown -R root:root $SYSTEM_NEW_DIR/my_stock
      cp -frp $MY_STOCK_DIR/* $SYSTEM_NEW_DIR/my_stock >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_VERSION_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_version
      mkdir -p $SYSTEM_NEW_DIR/my_version
      chmod 0755 $SYSTEM_NEW_DIR/my_version
      chown -R root:root $SYSTEM_NEW_DIR/my_version
      cp -frp $MY_VERSION_DIR/* $SYSTEM_NEW_DIR/my_version >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_OPERATOR_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_operator
      mkdir -p $SYSTEM_NEW_DIR/my_operator
      chmod 0755 $SYSTEM_NEW_DIR/my_operator
      chown -R root:root $SYSTEM_NEW_DIR/my_operator
      cp -frp $MY_OPERATOR_DIR/* $SYSTEM_NEW_DIR/my_operator >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_COUNTRY_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_country
      mkdir -p $SYSTEM_NEW_DIR/my_country
      chmod 0755 $SYSTEM_NEW_DIR/my_country
      chown -R root:root $SYSTEM_NEW_DIR/my_country
      cp -frp $MY_COUNTRY_DIR/* $SYSTEM_NEW_DIR/my_country >/dev/null 2>&1
      sync
   fi
   if [ -f "$MY_HEYTAP_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/my_heytap
      mkdir -p $SYSTEM_NEW_DIR/my_heytap
      chmod 0755 $SYSTEM_NEW_DIR/my_heytap
      chown -R root:root $SYSTEM_NEW_DIR/my_heytap
      cp -frp $MY_HEYTAP_DIR/* $SYSTEM_NEW_DIR/my_heytap >/dev/null 2>&1
      sync
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

if [ "$OPPO" == true ]; then
   if [ -f "$MY_COMPANY_IMAGE" ]; then
      sudo umount $MY_COMPANY_DIR/
   fi
   if [ -f "$MY_ENGINEERING_IMAGE" ]; then
      sudo umount $MY_ENGINEERING_DIR/
   fi
   if [ -f "$MY_PRODUCT_IMAGE" ]; then
      sudo umount $MY_PRODUCT_DIR/
   fi
   if [ -f "$MY_CARRIER_IMAGE" ]; then
      sudo umount $MY_CARRIER_DIR/
   fi
   if [ -f "$MY_CUSTOM_IMAGE" ]; then
      sudo umount $MY_CUSTOM_DIR/
   fi
   if [ -f "$MY_PRELOAD_IMAGE" ]; then
      sudo umount $MY_PRELOAD_DIR/
   fi
   if [ -f "$MY_MANIFEST_IMAGE" ]; then
      sudo umount $MY_MANIFEST_DIR/
   fi
   if [ -f "$MY_REGION_IMAGE" ]; then
      sudo umount $MY_REGION_DIR/
   fi
   if [ -f "$MY_ODM_IMAGE" ]; then
      sudo umount $MY_ODM_DIR/
   fi
   if [ -f "$MY_STOCK_IMAGE" ]; then
      sudo umount $MY_STOCK_DIR/
   fi
   if [ -f "$MY_VERSION_IMAGE" ]; then
      sudo umount $MY_VERSION_DIR/
   fi
   if [ -f "$MY_OPERATOR_IMAGE" ]; then
      sudo umount $MY_OPERATOR_DIR/
   fi
   if [ -f "$MY_COUNTRY_IMAGE" ]; then
      sudo umount $MY_COMPANY_DIR/
   fi
   if [ -f "$MY_HEYTAP_IMAGE" ]; then
      sudo umount $MY_HEYTAP_DIR/
   fi
fi

if [ "$SYSTEM_EXT" == true ]; then
   if [ -f "$SYSTEM_EXT_IMAGE" ]; then
      rm -rf $SYSTEM_NEW_DIR/system_ext $SYSTEM_NEW_DIR/system/system_ext
      mkdir -p $SYSTEM_NEW_DIR/system/system_ext
      cp -frp $SYSTEM_EXT_DIR/* $SYSTEM_NEW_DIR/system/system_ext/ >/dev/null 2>&1
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
         cp -frp $VENDOR_DIR/overlay/* "$WORKING/vendorOverlays" >/dev/null 2>&1
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
sudo rm -rf $SYSTEM_DIR $SYSTEM_NEW_DIR $PRODUCT_DIR $SYSTEM_IMAGE $SYSTEM_OTHER_DIR $SYSTEM_OTHER_IMAGE $PRODUCT_IMAGE $SYSTEM_EXT_DIR $SYSTEM_EXT_IMAGE $OPPRODUCT_DIR $OPPRODUCT_IMAGE $RESERVE_DIR $RESERVE_IMAGE $INDIA_DIR $INDIA_IMAGE $ODM_DIR $ODM_IMAGE $VENDOR_DIR $MY_COMPANY_IMAGE $MY_COMPANY_DIR $MY_ENGINEERING_IMAGE $MY_ENGINEERING_DIR $MY_PRODUCT_IMAGE $MY_PRODUCT_DIR

if [ "$SYSTEM_NEW" == true ]; then
   mv $WORKING/system.tmp $WORKING/system.img
fi
