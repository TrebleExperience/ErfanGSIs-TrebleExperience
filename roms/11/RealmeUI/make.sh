#!/bin/bash

systempath=$1
thispath=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Copy system files
rsync -ra $thispath/system/ $systempath

# Append file_context
cat $thispath/file_contexts >> $1/etc/selinux/plat_file_contexts

# Fix oppo init
sed -i 's/on boot/on early-init/g' $1/../init.oppo.rc 2> /dev/null

# Delete redundant files/stuff
rm -rf $1/etc/selinux/*debug*
[[ -e $1/product/etc/selinux/mapping ]] && rm -rf $1/product/etc/selinux/*debug*
[[ -e $1/system_ext/etc/selinux/mapping ]] && rm -rf $1/system_ext/etc/selinux/*debug*
[[ -e $1/../my_product/vendor/firmware ]] && rm -rf $1/../my_product/vendor/firmware

# Push custom bp
echo "
# oppo custom partition path
ro.oppo.my_carrier_root=/my_carrier
ro.oppo.my_company_root=/my_company
ro.oppo.my_country_root=/my_region
ro.oppo.my_custom_root=/my_custom
ro.oppo.my_engineer_root=/my_engineering
ro.oppo.my_engineering_root=/my_engineering
ro.oppo.my_heytap_root=/my_heytap
ro.oppo.my_manifest_root=/my_manifest
ro.oppo.my_operator_root=/my_carrier
ro.oppo.my_preload_root=/my_preload
ro.oppo.my_product_root=/my_product
ro.oppo.my_region_root=/my_region
ro.oppo.my_special_preload_root=/special_preload
ro.oppo.my_stock_root=/my_stock
ro.oppo.my_version_root=/my_version
ro.oppo.oppo_custom_root=/my_company
ro.oppo.oppo_engineer_root=/my_engineering
ro.oppo.oppo_product_root=/my_product
ro.oppo.oppo_version_root=/my_version
" >> $1/build.prop

echo "
# oppo custom partition path
ro.oppo.my_carrier_root=/my_carrier
ro.oppo.my_company_root=/my_company
ro.oppo.my_country_root=/my_region
ro.oppo.my_custom_root=/my_custom
ro.oppo.my_engineer_root=/my_engineering
ro.oppo.my_engineering_root=/my_engineering
ro.oppo.my_heytap_root=/my_heytap
ro.oppo.my_manifest_root=/my_manifest
ro.oppo.my_operator_root=/my_carrier
ro.oppo.my_preload_root=/my_preload
ro.oppo.my_product_root=/my_product
ro.oppo.my_region_root=/my_region
ro.oppo.my_special_preload_root=/special_preload
ro.oppo.my_stock_root=/my_stock
ro.oppo.my_version_root=/my_version
ro.oppo.oppo_custom_root=/my_company
ro.oppo.oppo_engineer_root=/my_engineering
ro.oppo.oppo_product_root=/my_product
ro.oppo.oppo_version_root=/my_version
" >> $1/product/build.prop

# [DUMMY CODE ALERT] START
cp -frp $1/system_ext/build.prop $thispath
sed -i "/#end/d" $thispath/build.prop
echo "#end" >> $thispath/build.prop
master_date=$(cat $thispath/build.prop | grep "ro.build.master.date" | cut -d "=" -f 2)
sed -i "/ro.build.master.date\=$master_date/,/#end/d" $thispath/build.prop
echo "ro.build.master.date=$master_date" >> $thispath/build.prop
cp -frp $thispath/build.prop $1/system_ext/build.prop
rm -rf $thispath/build.prop

oppo_build_name=$(find $1/../ -type f -name "build.prop")
for oppo_builds in $oppo_build_name; do
    oppo_builds="$(realpath $oppo_builds)"
    if [ -e $oppo_builds ]; then
        sed -i '/ro.sf.lcd/d' $oppo_builds
        sed -i '/ro.display.brightness/d' $oppo_builds
    fi
done

# Fix screenshot service issue
sed -i '/persist.oplus.display.surfaceflinger.screenshot.cwb' $1/../my_product/build.prop

# import oppo custom build.prop (due custom partition path)
if [ -e $1/../my_product/build.prop ]; then
    echo "import /my_product/build.prop" >> $1/../my_product/build.prop
fi

# oppo custom build.prop merge
if [ -e $1/../my_manifest/build.prop ]; then
    sed -i "/security_patch\=/d" $1/../my_manifest/build.prop
    echo "" >> $1/build.prop
    cat $1/../my_manifest/build.prop >>$1/build.prop
    true > $1/../my_manifest/build.prop
fi
# [DUMMY CODE ALERT] END

# Run utils
bash $thispath/util/make.sh "$(realpath $thispath/../../../working)" "$systempath"
