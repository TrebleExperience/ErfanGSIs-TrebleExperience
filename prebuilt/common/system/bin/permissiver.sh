#!/system/bin/sh

setenforce 0

# HACK: vel-shf.sh enabler for a20s
cd /vendor/bin
sh vel-shf.sh

# Patch anti-kang

mount -o remount,rw /
if [[ $(grep "ro.build.display.id" ../build.prop) ]]; then
    displayid="ro.build.display.id"
elif [[ $(grep "ro.system.build.id" ../build.prop) ]]; then
    displayid="ro.system.build.id"
elif [[ $(grep "ro.build.id" ../build.prop) ]]; then
    displayid="ro.build.id"
fi

displayid2=$(echo "$displayid" | sed 's/\./\\./g')
bdisplay=$(grep "$displayid" ../build.prop | sed 's/\./\\./g; s:/:\\/:g; s/\,/\\,/g; s/\ /\\ /g')
sed -i "s/$bdisplay/$displayid2=Built\.with\.ErfanGSI\.Tools\.YuMiGSIs/" ../build.prop
mount -o remount,ro /
