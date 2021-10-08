#!/bin/bash

# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>
# Project TrebleExperience by Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>

# Core variables, do not edit.
LOCALDIR=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`
tempdirname="tmp"
tempdir="$LOCALDIR/$tempdirname"
systemdir="$tempdir/system"
toolsdir="$LOCALDIR/tools"
romsdir="$LOCALDIR/roms"
prebuiltdir="$LOCALDIR/prebuilt"
scriptsdir="$LOCALDIR/scripts"
sourcepath=$1
romtype=$2
outputtype=$3
novndk=$4

# Util functions
usage() {
echo "Usage: $0 <Path to GSI system> <Firmware type> <Output type> <Extra VNDK> [Output Dir]"
    echo -e "\tPath to GSI system: Mount GSI and set mount point"
    echo -e "\tFirmware type: Firmware mode"
    echo -e "\tOutput type: AB or Aonly"
    echo -e "\tExtra VNDK: Use it to not include extra VNDK, with false & true args"
    echo -e "\tOutput Dir: set output dir"
}

# Need at least 4 args
if [ "$4" == "" ]; then
    echo "-> ERROR!"
    echo " - Enter all needed parameters"
    usage
    exit 1
fi

# Check output arg
if [ "$5" == "" ]; then
    echo "-> Create out dir"
    outdirname="out"
    outdir="$LOCALDIR/$outdirname"
    mkdir -p "$outdir"
else
    outdir="$5"
fi

# Check if have special name.
if [[ $romtype == *":"* ]]; then
    romtypename=`echo "$romtype" | cut -d ":" -f 2`
    romtype=`echo "$romtype" | cut -d ":" -f 1`
else
    romtypename=$romtype
fi

# Init variables for ROM check
flag=false
roms=("$LOCALDIR"/roms/*/*)

# Check ROM type
for dir in "${roms[@]}"
do
    rom=`echo "$dir" | rev | cut -d "/" -f 1 | rev`
    if [ "$rom" == "$romtype" ]; then
        flag=true
    fi
done

# If flag variable is false, then the ROM isn't even supported.
if [ "$flag" == "false" ]; then
    echo "-> Heyaa! $romtype is not a supported ROM! Please review the list of supported ROMs."
    exit 1
fi

# Re-init variable for layout check
flag=false

# Check layout type
case "$outputtype" in
    *"AB"*) flag=true ;;
    *"Aonly"*) flag=true ;;
esac

# If flag variable is false, then the layout type isn't even supported.
if [ "$flag" == "false" ]; then
    echo "-> Hey, $outputtype is not supported type, supported types:"
    echo " - AB"
    echo " - Aonly"
    exit 1
fi

# Detect Source type, AB or not
sourcetype="Aonly"
if [[ -e "$sourcepath/system" ]]; then
    sourcetype="AB"
fi

# GSI process message
echo "-> Initializing process, creating temporary directory..."
rm -rf $tempdir
mkdir -p "$systemdir"

# Check layout type (I guess I'll drop it soon.)
if [ "$sourcetype" == "Aonly" ]; then
    echo "-> Warning: Aonly source detected, using P AOSP rootdir"
    cd "$systemdir"
    tar xf "$prebuiltdir/ABrootDir.tar"
    cd "$LOCALDIR"
    echo "-> Making copy of source rom to temp..."
    ( cd "$sourcepath" ; sudo tar cf - . ) | ( cd "$systemdir/system" ; sudo tar xf - ) &> /dev/null
    cd "$LOCALDIR"
    sed -i "/ro.build.system_root_image/d" "$systemdir/system/build.prop"
    sed -i "/ro.build.ab_update/d" "$systemdir/system/build.prop"
    echo "ro.build.system_root_image=false" >> "$systemdir/system/build.prop"
else
    echo "-> Making copy of source rom to temp..."
    ( cd "$sourcepath" ; sudo tar cf - . ) | ( cd "$systemdir" ; sudo tar xf - ) &> /dev/null
    cd "$LOCALDIR"
    sed -i "/ro.build.system_root_image/d" "$systemdir/system/build.prop"
    sed -i "/ro.build.ab_update/d" "$systemdir/system/build.prop"
    echo "ro.build.system_root_image=true" >> "$systemdir/system/build.prop"
fi

# Detect is the src treble ro.treble.enabled=true
istreble=`cat $systemdir/system/build.prop | grep ro.treble.enabled | cut -d "=" -f 2`
if [[ ! "$istreble" == "true" ]]; then
    if [ ! -f "$LOCALDIR/working/vendor.img" ]; then
        echo "-> Hey, the source is not treble supported."
        exit 1
    else
        echo "-> Treble source detected but with disabled treble prop"
    fi
fi

# Detect Source API level
if grep -q ro.build.version.release_or_codename $systemdir/system/build.prop; then
    sourcever=`grep ro.build.version.release_or_codename $systemdir/system/build.prop | cut -d "=" -f 2`
else
    sourcever=`grep ro.build.version.release $systemdir/system/build.prop | cut -d "=" -f 2`
fi

if [ $(echo $sourcever | cut -d "." -f 2) == 0 ]; then
    sourcever=$(echo $sourcever | cut -d "." -f 1)
fi

# Re-init variable for Android version
flag=false

# Check Android version
case "$sourcever" in
    *"9"*) flag=true ;;
    *"10"*) flag=true ;;
    *"11"*) flag=true ;;
    *"12"*) flag=true ;;
esac

# I need to say something?
if [ "$flag" == "false" ]; then
    echo "-> $sourcever is not supported."
    exit 1
fi

# Detect rom folder again
if [[ ! -d "$romsdir/$sourcever/$romtype" ]]; then
    echo "-> $romtype is not a supported ROM for Android $sourcever. Please review the list of supported ROMs."
    exit 1
fi

if [ "$sourcetype" == "Aonly" ]; then
    if [[ "$sourcever" == "11" || "$sourcever" == "12" ]]; then
        echo "-> Building a GSI as system-as-system is not possible in Android R/S, reconsider building with AB ramdisk."
        exit 1
    fi
fi

# Detect arch
if [[ ! -f "$systemdir/system/lib64/libandroid.so" ]]; then
    echo "-> A64/ARM32 ROM detected! Can't build due missing A64/ARM32 VNDK/Libraries for it."
    exit 1
fi

# Init date var first
date=`date +%Y%m%d`

# Get build display id & model
displayid=$(grep -oP "(?<=^ro.build.display.id=).*" -hs $systemdir/system/build.prop | head -1)
[[ -z "$displayid" ]] && displayid=$(grep -oP "(?<=^ro.system.build.id=).*" -hs $systemdir/system/build.prop | head -1)
[[ -z "$displayid" ]] && displayid=$(grep -oP "(?<=^ro.build.id=).*" -hs $systemdir/system/build.prop | head -1)
displayid=`echo $displayid | sed "s/ /-/g"`
codename=$(grep -oP "(?<=^ro.product.vendor.device=).*" -hs "$LOCALDIR/working/vendor/build.prop" | head -1)
[[ -z "${codename}" ]] && codename=$(grep -oP "(?<=^ro.product.system.device=).*" -hs $systemdir/system/build.prop | head -1)
[[ -z "${codename}" ]] && codename=$(grep -oP "(?<=^ro.product.device=).*" -hs $systemdir/system/build.prop | head -1)
[[ -z "${codename}" ]] && codename=Generic

# Debloat thing
outputtreename="trebleExp[$romtypename]-$codename-[GSI+SGSI]-$displayid-$sourcever-$date-System-Tree.txt"
outputtree="$outdir/$outputtreename"

if [ ! -f "$outputtree" ]; then
    echo "-> Creating system tree..."
    tree $systemdir >> "$outputtree" 2> "$outputtree"
    echo " - Done!"
fi

# Debloat
if [[ -f $romsdir/$sourcever/$romtype/$romtypename/debloat.sh || -f $romsdir/$sourcever/$romtype/debloat.sh ]]; then
    echo "-> De-bloating"
    $romsdir/$sourcever/$romtype/debloat.sh "$systemdir/system" 2>/dev/null
    $romsdir/$sourcever/$romtype/$romtypename/debloat.sh "$systemdir/system" 2>/dev/null
fi

# Start patching
echo "-> Patching started..."
$scriptsdir/fixsymlinks.sh "$systemdir/system" 2>/dev/null
$scriptsdir/nukeABstuffs.sh "$systemdir/system" 2>/dev/null

# Check if extra VNDK has been requested
if [[ $novndk == "false" ]]; then
    echo "-> Extra VNDK requested, copying VNDK from Android $sourcever into GSI"
    $prebuiltdir/vendor_vndk/make$sourcever.sh "$systemdir/system" 2>/dev/null
else
    echo "-> No extra VNDK requested, skipping the VNDK process..."
fi

# Patching moment
$prebuiltdir/$sourcever/make.sh "$systemdir/system" "$romsdir/$sourcever/$romtype" 2>/dev/null
$prebuiltdir/$sourcever/makeroot.sh "$systemdir" "$romsdir/$sourcever/$romtype" 2>/dev/null
$prebuiltdir/common/make.sh "$systemdir/system" "$romsdir/$sourcever/$romtype" 2>/dev/null
[[ -f $LOCALDIR/tmp/FATALERROR ]] && exit 1
$romsdir/$sourcever/$romtype/make.sh "$systemdir/system" 2>/dev/null
$romsdir/$sourcever/$romtype/makeroot.sh "$systemdir" 2>/dev/null
if [ ! "$romtype" == "$romtypename" ]; then
    $romsdir/$sourcever/$romtype/$romtypename/make.sh "$systemdir/system" 2>/dev/null
    $romsdir/$sourcever/$romtype/$romtypename/makeroot.sh "$systemdir" 2>/dev/null
fi
if [ "$outputtype" == "Aonly" ] && [ ! "$romtype" == "$romtypename" ]; then
    $romsdir/$sourcever/$romtype/$romtypename/makeA.sh "$systemdir/system" 2>/dev/null
fi
if [ "$outputtype" == "Aonly" ]; then
    $prebuiltdir/$sourcever/makeA.sh "$systemdir/system" 2>/dev/null
    $romsdir/$sourcever/$romtype/makeA.sh "$systemdir/system" 2>/dev/null
fi

# Resign to AOSP keys
if [[ ! -e $romsdir/$sourcever/$romtype/$romtypename/DONTRESIGN ]]; then
    if [[ ! -e $romsdir/$sourcever/$romtype/DONTRESIGN ]]; then
        echo "-> Resigning to AOSP keys, just wait."
        ispython2=`python -c 'import sys; print("%i" % (sys.hexversion<0x03000000))'`
        if [ $ispython2 -eq 0 ]; then
            python2=python2
        else
            python2=python
        fi
        $python2 $toolsdir/ROM_resigner/resign.py "$systemdir/system" $toolsdir/ROM_resigner/AOSP_security > $tempdir/resign.log 2>&1
        $prebuiltdir/resigned/make.sh "$systemdir/system" 2>/dev/null
    fi
fi

# Fixing environ
if [ "$outputtype" == "Aonly" ]; then
    if [[ ! $(ls "$systemdir/system/etc/init/" | grep *environ*) ]]; then
        echo "-> Generating environ.rc"
        echo "# AUTOGENERATED FILE BY ERFANGSI TOOLS" > "$systemdir/system/etc/init/init.treble-environ.rc"
        echo "on init" >> "$systemdir/system/etc/init/init.treble-environ.rc"
        cat "$systemdir/init.environ.rc" | grep BOOTCLASSPATH >> "$systemdir/system/etc/init/init.treble-environ.rc"
        cat "$systemdir/init.environ.rc" | grep SYSTEMSERVERCLASSPATH >> "$systemdir/system/etc/init/init.treble-environ.rc"
    fi
fi

# Out info
outputname="trebleExp[$romtypename]-$codename-[GSI+SGSI]-$displayid-$outputtype-$sourcever-$date"
outputimagename="$outputname".img
outputtextname="$outputname".txt
outputvendoroverlaysname="trebleExp[$romtypename]-$codename-[GSI+SGSI]-$displayid-$sourcever-$date-VendorOverlays.tar.gz"
outputodmoverlaysname="trebleExp[$romtypename]-$codename-[GSI+SGSI]-$displayid-$sourcever-$date-ODMOverlays.tar.gz"
output="$outdir/$outputimagename"
outputvendoroverlays="$outdir/$outputvendoroverlaysname"
outputodmoverlays="$outdir/$outputodmoverlaysname"
outputinfo="$outdir/$outputtextname"

# Get info
if $(cat $systemdir/system/build.prop | grep -qo 'qssi'); then
    echo "-> QSSI build detected! Trying to get the correct device info."
    if [ -f "$LOCALDIR/working/vendor.img" ]; then
        $scriptsdir/getinfo.sh "$systemdir/system" "$LOCALDIR/working/vendor" true > "$outputinfo"
    else
        echo " - The vendor image doesn't exist, isn't possible to get the device's codename, model instead of QSSI props."
        $scriptsdir/getinfo.sh "$systemdir/system" /dev/null false > "$outputinfo"
    fi
else
    $scriptsdir/getinfo.sh "$systemdir/system" "$LOCALDIR/working/vendor" false > "$outputinfo"
fi

# Getting system size and add approximately 5% on it just for free space
systemsize=`du -sk $systemdir | awk '{$1*=1024;$1=int($1*1.05);printf $1}'`
bytesToHuman() {
    b=${1:-0}; d=''; s=0; S=(Bytes {K,M,G,T,P,E,Z,Y}iB)
    while ((b > 1024)); do
        d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
        b=$((b / 1024))
        let s++
    done
    echo "$b$d ${S[$s]}"
}
echo "Raw Image Size: $(bytesToHuman $systemsize)" >> "$outputinfo"

echo "-> Creating Image (This may take a while to finish): $outputimagename"

# Use ext4fs to make image in P or older!
if [ "$sourcever" == "9" ]; then
    useold="--old"
fi

# Build the GSI image
if [ ! -f "$romsdir/$sourcever/$romtype/build/file_contexts" ]; then
    echo "-> Note: Custom security contexts not found for this ROM, errors or SELinux problem may appear"
    $scriptsdir/mkimage.sh $systemdir $outputtype $systemsize $output false $useold > $tempdir/mkimage.log || rm -rf $output
else
    echo "-> Note: Custom security contexts found!"
    $scriptsdir/mkimage.sh $systemdir $outputtype $systemsize $output $romsdir/$sourcever/$romtype/build $useold > $tempdir/mkimage.log || rm -rf $output
fi

# Check if the output image has been built
if [ -f "$output" ]; then
   # Builded
   echo "-> Created image ($outputtype): $outputimagename | Size: $(bytesToHuman $systemsize)"
else
   # Oops... Error found
   echo "-> Error: Output image for $outputimagename ($outputtype) doesn't exists!"
   exit 1
fi

# Overlays
if [ -f "$LOCALDIR/output/.tmp" ]; then
    mv "$LOCALDIR/output/.tmp" "$outputvendoroverlays"
else
    if [[ -d "$LOCALDIR/working/vendor/overlay" && ! -f "$outputvendoroverlays" ]]; then
        mkdir -p "$LOCALDIR/output/vendorOverlays"
        cp -frp working/vendor/overlay/* "output/vendorOverlays" >> /dev/null 2>&1
        tar -zcvf "$outputvendoroverlays" "output/vendorOverlays" >> /dev/null 2>&1
        rm -rf "output/vendorOverlays"
    fi
fi
if [ -f "$LOCALDIR/output/.otmp" ]; then
    mv "$LOCALDIR/output/.otmp" "$outputodmoverlays"
fi

echo "-> Done! Delete temporary folder."
rm -rf "$tempdir"
