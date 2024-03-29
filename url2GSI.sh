#!/bin/bash

# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>
# Project Treble Experience by Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>

# Core variables, do not edit.
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
AB=true
AONLY=true
MOUNTED=false
NOVNDK=false
GAPPS=false
CLEAN=false
MERGE=false

# Check for partitions to validate if the merger usage is needed
PARTITIONS="system_ext product reserve india my_bigball my_carrier my_company my_engineering my_heytap my_manifest my_preload my_product my_region my_stock my_version"

# Lock for GSI process
LOCK="$PROJECT_DIR/cache/.lock"

# Downloader Util variable
DL="${PROJECT_DIR}/scripts/downloaders/dl.sh"

# Variable to chown the output folder
USERNAME=`who | awk '{print $1}'`

# Do an OS check, avoid Darwin as I cannot support it.
if [ $(uname) == Darwin ]; then
    echo "-> Darwin is no longer supported."
    exit 1
fi

# Always run as root
if [ "${EUID}" -ne 0 ]; then
    echo "-> Run as root!"
    exit 1
fi

# Welcome Message
echo "-> Note: This fork is derived from VeloshGSIs, the predecessor of the old TrebleExperience foundation (2019-2020, VegaGSIs)."
echo " - This branch is private, the public repository is available on TrebleExperience's GitHub."

# Util functions
usage() {
    echo "Usage: [--help|-h|-?] [--ab|-b] [--aonly|-a] [--cleanup|-c] [--merge|-m] [--no-vndks|-nv] [--gapps|-g] $0 <Firmware link> <Firmware type> [Other args]"
    echo -e "\tFirmware link: Firmware download link or local path"
    echo -e "\tFirmware type: Firmware mode"
    echo -e "\t--ab: Build only AB"
    echo -e "\t--aonly: Build only A-Only"
    echo -e "\t--cleanup: Cleanup downloaded firmware"
    echo -e "\t--merger: Merge partitions & others into system"
    echo -e "\t--novndk: Do not include extra VNDK"
    echo -e "\t--gapps: Add prebuilt GApps inside system"
    echo -e "\t--help: To show this info"
}

DOWNLOAD() {
    URL="$1"
    ZIP_NAME="$2"
    echo "-> Downloading firmware to: $ZIP_NAME"
    if echo "${URL}" | grep -q "mega.nz\|mediafire.com\|drive.google.com"; then
        ("${DL}" "${URL}" "$PROJECT_DIR/input" "$ACTUAL_ZIP_NAME") || exit 1
    else
        if echo "${URL}" | grep -q "1drv.ms"; then URL=${URL/ms/ws}; fi
        { type -p aria2c > /dev/null 2>&1 && aria2c -x16 -j$(nproc) -U "Mozilla/5.0" -d "$PROJECT_DIR/input" -o "$ACTUAL_ZIP_NAME" ${URL} > /dev/null 2>&1; } || { wget -U "Mozilla/5.0" ${URL} -O "$PROJECT_DIR/input/$ACTUAL_ZIP_NAME" > /dev/null 2>&1 || exit 1; }
        aria2c -x16 -j$(nproc) -U "Mozilla/5.0" -d "$PROJECT_DIR/input" -o "$ACTUAL_ZIP_NAME" ${URL} > /dev/null 2>&1 || {
            wget -U "Mozilla/5.0" ${URL} -O "$PROJECT_DIR/input/$ACTUAL_ZIP_NAME" > /dev/null 2>&1 || exit 1
        }
    fi
}

MOUNT() {
    mkdir -p "$PROJECT_DIR/working/$2"
    if $(sudo mount -o auto -t auto "$PROJECT_DIR/working/$1" "$PROJECT_DIR/working/$2" >/dev/null 2>&1); then
        echo "-> $3 image successfully mounted"
    elif $(sudo mount -o ro -t erofs "$PROJECT_DIR/working/$1" "$PROJECT_DIR/working/$2" >/dev/null 2>&1); then
        echo "-> $3 image successfully mounted with Enhanced Read-Only File System"
    elif $(sudo mount -o loop -t erofs "$PROJECT_DIR/working/$1" "$PROJECT_DIR/working/$2" >/dev/null 2>&1); then
        echo "-> $3 image successfully mounted with Enhanced Read-Only File System"
    elif $(sudo mount -o loop "$PROJECT_DIR/working/$1" "$PROJECT_DIR/working/$2" >/dev/null 2>&1); then
        echo "-> $3 image successfully mounted"
    elif $(sudo mount -o ro "$PROJECT_DIR/working/$1" "$PROJECT_DIR/working/$2" >/dev/null 2>&1); then
        echo "-> $3 image successfully mounted"
    else
        # If it fails again, abort
        echo "-> Failed to mount $3 image, try to check this manually, abort."
        exit 1
    fi
}

UMOUNT_ALL() {
    for partition in $(pwd)/working/*; do
        if [ -d "$partition" ]; then
            umount -f $partition >> /dev/null 2>&1 || true
            umount -l $partition >> /dev/null 2>&1 || true
        fi
    done
}

LEAVE() {
    UMOUNT_ALL
    rm -rf "$PROJECT_DIR/working"
    exit 1
}

# Need at least 2 args
if [[ ! -n $2 ]]; then
    echo "-> ERROR!"
    echo " - Enter all needed parameters"
    sudo rm -rf "$PROJECT_DIR/cache/" "$LOCK"
    usage
    exit
fi

# GSI Process lock
if [ -f "$LOCK" ]; then
    echo "-> Stop, wait for the other job to finish before you can start another one."
    exit 1
else
    mkdir -p "$PROJECT_DIR/cache/"
    touch "$LOCK"
    if [ ! -d "$1" ]; then
        echo "-> Warning: Unmounting all partitions inside working folder, deleting all temporary folders/files which are used to do GSI process..."
        UMOUNT_ALL
        sudo rm -rf "$PROJECT_DIR/working/"
    fi
    sudo rm -rf "$PROJECT_DIR/output/" "$PROJECT_DIR/cache/" "$PROJECT_DIR/tmp/"  "$PROJECT_DIR/tools/ROM_resigner/tmp/"
    sudo find . -type d -name "__pycache__" -exec rm -rf {} +
    sudo find . -type f -name "*.pyc" -exec rm -rf {} +
    echo " - Done."
fi

# Get the args
POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    --ab | -b)
        AONLY=false
        AB=true
        shift
        ;;
    --aonly | -a)
        AONLY=true
        AB=false
        shift
        ;;
    --cleanup | -c)
        CLEAN=true
        shift
        ;;
    --no-vndks | -nv)
        NOVNDK=true
        shift
        ;;
    --gapps | -g)
        GAPPS=true
        shift
        ;;
    --merge | -m)
        MERGE=true
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

# Get the URL and Firmware Type (Shift method)
URL=$1
shift
SRCTYPE=$1
shift

# Make a copy of URL variable
ORIGINAL_URL=$URL

# Check if has special firmware (eg: OxygenOS:HydrogenOS)
if [[ $SRCTYPE == *":"* ]]; then
    SRCTYPENAME=`echo "$SRCTYPE" | cut -d ":" -f 2`
else
    SRCTYPENAME=$SRCTYPE
fi

# Create input & working directory if it does not exist
mkdir -p "$PROJECT_DIR/input" "$PROJECT_DIR/working" "$PROJECT_DIR/output"

# If the URL variable is a directory (we expect that dir is a system image), then we'll use that path as GSI system image
if [[ -d "$URL" ]]; then
    MOUNTED=true
fi

# Create a dummy variable for ZIP_NAME
ZIP_NAME="$PROJECT_DIR/input/dummy"

# If the URL isn't a system image dir, make minor checks
if [ $MOUNTED == false ]; then
    if [[ "$URL" == "http"* ]]; then
        # URL detected
        RANDOMM=$(echo $RANDOM)
        ACTUAL_ZIP_NAME="$RANDOMM"_FIRMWARE.tgz
        ZIP_NAME="$PROJECT_DIR"/input/"$RANDOMM"_FIRMWARE.tgz
        DOWNLOAD "$URL" "$ZIP_NAME"
        URL="$ZIP_NAME"
    fi
    if [ "$MERGE" == true ]; then
       "$PROJECT_DIR"/scripts/merger.sh "$URL" || exit 1
    elif [ $MERGE == false ] ; then
       "$PROJECT_DIR"/zip2img.sh "$URL" "$PROJECT_DIR/working" || exit 1
    fi
    if [ $CLEAN == true ]; then
        rm -rf "$ZIP_NAME"
    fi
    if [ -f "$PROJECT_DIR/working/system.img" ]; then
        MOUNT "system.img" "system" "System"
        URL="$PROJECT_DIR/working/system"
        if [ -f "$PROJECT_DIR/working/vendor.img" ]; then
            MOUNT "vendor.img" "vendor" "Vendor"
        fi
    else
        echo "-> Error, System Image doesn't exists, abort!"
        exit 1
    fi
fi

if [ "$MERGE" == false ]; then
    for partition in $PARTITIONS; do
        if [ -f "$PROJECT_DIR/working/$partition.img" ]; then
            # If exists, then the merge usage is needed!
            echo " - Oops... Seems you forgot to enable merger argument (-m), there are existing partition(s) that need to be merged into the system partition. Abort."
            exit 1
        fi
    done
fi

# GSI process (AB)
if [ $AB == true ]; then
   "$PROJECT_DIR"/make.sh "${URL}" "${SRCTYPE}" AB ${NOVNDK} ${GAPPS} "$PROJECT_DIR/output" ${@} || LEAVE
fi

# Remove ROM_resigner tmp dir
if [ -d "$PROJECT_DIR/tools/ROM_resigner/tmp/" ]; then
   sudo rm -rf "$PROJECT_DIR/tools/ROM_resigner/tmp/"
fi

# GSI process (AB)
if [ $AONLY == true ]; then
    "$PROJECT_DIR"/make.sh "${URL}" "${SRCTYPE}" Aonly ${NOVNDK} ${GAPPS} "$PROJECT_DIR/output" ${@} || LEAVE
fi

# Force all partitions to be unmounted.
UMOUNT_ALL
sudo rm -rf "$PROJECT_DIR/cache/" "$PROJECT_DIR/tmp/" "$PROJECT_DIR/working/" "$PROJECT_DIR/tools/ROM_resigner/tmp/"

# We're lazy to run chown command
chown -R ${USERNAME}:${USERNAME} $PROJECT_DIR/output

# Done message
echo " > Done, ${SRCTYPENAME} ROM successfully ported, wait for Bo³+t to finish the process." | sed "s/-/ /g"
