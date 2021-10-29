#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Copy system files
rsync -ra $thispath/system/ $systempath

# Append file_context
cat $thispath/file_contexts >> $1/etc/selinux/plat_file_contexts

# Drop some props (If have, but make sure)
sed -i "/ro.build.oplus_ext_partitions/d" $1/build.prop
sed -i "/ro.oppo.my_country_root/d" $1/build.prop
sed -i "/ro.oppo.my_engineer_root/d" $1/build.prop
sed -i "/ro.oppo.my_engineering_root/d" $1/build.prop
sed -i "/ro.oppo.my_manifest_root/d" $1/build.prop
sed -i "/ro.oppo.my_odm_root/d" $1/build.prop
sed -i "/ro.oppo.my_operator_root/d" $1/build.prop
sed -i "/ro.oppo.my_preload_root/d" $1/build.prop
sed -i "/ro.oppo.my_product_root/d" $1/build.prop
sed -i "/ro.oppo.my_region_root/d" $1/build.prop
sed -i "/ro.oppo.my_stock_root/d" $1/build.prop
sed -i "/ro.oppo.my_version_root/d" $1/build.prop
sed -i "/ro.oppo.oppo_custom_root/d" $1/build.prop
sed -i "/ro.oppo.oppo_engineer_root/d" $1/build.prop
sed -i "/ro.oppo.oppo_version_root/d" $1/build.prop

# Re-add props
echo "" >> $1/build.prop
echo "# TRY TO FORCE PROPS" >> $1/build.prop
echo "ro.oppo.my_country_root=/my_country" >> $1/build.prop
echo "ro.oppo.my_country_root=/my_region" >> $1/build.prop
echo "ro.oppo.my_engineer_root=/my_engineering" >> $1/build.prop
echo "ro.oppo.my_engineering_root=/my_engineering" >> $1/build.prop
echo "ro.oppo.my_manifest_root=/my_manifest" >> $1/build.prop
echo "ro.oppo.my_odm_root=/odm" >> $1/build.prop
echo "ro.oppo.my_operator_root=/my_carrier" >> $1/build.prop
echo "ro.oppo.my_preload_root=/my_preload" >> $1/build.prop
echo "ro.oppo.my_product_root=/my_product" >> $1/build.prop
echo "ro.oppo.my_region_root=/my_region" >> $1/build.prop
echo "ro.oppo.my_stock_root=/my_stock" >> $1/build.prop
echo "ro.oppo.my_version_root=/my_version" >> $1/build.prop
echo "ro.oppo.oppo_custom_root=/my_custom" >> $1/build.prop
echo "ro.oppo.oppo_engineer_root=/my_engineering" >> $1/build.prop
echo "ro.oppo.oppo_version_root=/my_version" >> $1/build.prop
echo "ro.build.oplus_ext_partitions=my_product my_engineering my_stock my_heytap my_region my_carrier my_preload my_company" >> $1/build.prop
