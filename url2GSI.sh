#!/bin/bash

# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

AB=true
AONLY=true
MOUNTED=false
NOVNDK=false
CLEAN=false
DYNAMIC=false
LOCK="$PROJECT_DIR/cache/.lock"
DL="${PROJECT_DIR}/scripts/downloaders/dl.sh"
USERNAME=`who | awk '{print $1}'`

echo "-> Note: This fork is derived from VeloshGSIs, the predecessor of the old TrebleExperience foundation (2019-2020, VegaGSIs)."
echo " - This branch is private, the public repository is available on TrebleExperience's GitHub."

if [ $(uname) == Darwin ]; then
    echo "-> Darwin is no longer supported."
    exit 1
fi

if [ "${EUID}" -ne 0 ]; then
    echo "-> Run as root!"
    exit 1
fi

if [ -f "$LOCK" ]; then
    echo "-> Stop, wait for the other job to finish before you can start another one."
    exit 1
else
    mkdir -p "$PROJECT_DIR/cache/"
    touch "$LOCK"
    echo "-> Making patch: Cleaning and removing folders that are used to make GSI to avoid problems"
    if [ -d "$PROJECT_DIR/working/system/" ]; then
        sudo umount "$PROJECT_DIR/working/system/" > /dev/null 2>&1
    fi
    if [ -d "$PROJECT_DIR/working/vendor/" ]; then
        sudo umount "$PROJECT_DIR/working/vendor/" > /dev/null 2>&1
    fi
    if [ -d "$PROJECT_DIR/tools/ROM_resigner/tmp/" ]; then
        sudo rm -rf "$PROJECT_DIR/tools/ROM_resigner/tmp/"
    fi
    sudo rm -rf "$PROJECT_DIR/cache/" "$PROJECT_DIR/tmp/" "$PROJECT_DIR/working/"
fi

usage()
{
    echo "Usage: [--help|-h|-?] [--ab|-b] [--aonly|-a] [--mounted|-m] [--cleanup|-c] [--dynamic|-d] [--no-vndks|-nv] $0 <Firmware link> <Firmware type> [Other args]"
    echo -e "\tFirmware link: Firmware download link or local path"
    echo -e "\tFirmware type: Firmware mode"
    echo -e "\t--ab: Build only AB"
    echo -e "\t--aonly: Build only A-Only"
    echo -e "\t--cleanup: Cleanup downloaded firmware"
    echo -e "\t--dynamic: Use this option only if the firmware contains dynamic partitions"
    echo -e "\t--novndk: Do not include extra VNDK"
    echo -e "\t--help: To show this info"
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --ab|-b)
    AONLY=false
    AB=true
    shift
    ;;
    --aonly|-a)
    AONLY=true
    AB=false
    shift
    ;;
    --cleanup|-c)
    CLEAN=true
    shift
    ;;
    --no-vndks|-nv)
    NOVNDK=true
    shift
    ;;
    --dynamic|-d)
    DYNAMIC=true
    shift
    ;;
    --help|-h|-?)
    usage
    exit
    ;;
    *)
    POSITIONAL+=("$1")
    shift
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

if [[ ! -n $2 ]]; then
    echo "-> ERROR!"
    echo " - Enter all needed parameters"
    sudo rm -rf "$PROJECT_DIR/cache/" "$LOCK"
    usage
    exit
fi

URL=$1
shift
SRCTYPE=$1
shift

ORIGINAL_URL=$URL

if [[ $SRCTYPE == *":"* ]]; then
    SRCTYPENAME=`echo "$SRCTYPE" | cut -d ":" -f 2`
else
    SRCTYPENAME=$SRCTYPE
fi

DOWNLOAD()
{
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

MOUNT()
{
    mkdir -p "$PROJECT_DIR/working/$2"
    if `sudo mount -o ro "$PROJECT_DIR/working/$1" "$PROJECT_DIR/working/$2" > /dev/null 2>&1`; then
        echo "-> $3 image successfully mounted"
    elif `sudo mount -o loop "$PROJECT_DIR/working/$1" "$PROJECT_DIR/working/$2" > /dev/null 2>&1`; then
        echo "-> $3 image successfully mounted"
    else
        # If it fails again, abort
        echo "-> Failed to mount $3 image, try to check this manually"
        exit 1
    fi
}

UMOUNT()
{
    sudo umount "$1"
}

LEAVE()
{
    UMOUNT "$PROJECT_DIR/working/system"
    UMOUNT "$PROJECT_DIR/working/vendor" > /dev/null 2>&1
    rm -rf "$PROJECT_DIR/working"
    exit 1
}

# Create input & working directory if it does not exist
mkdir -p "$PROJECT_DIR/input" "$PROJECT_DIR/working" "$PROJECT_DIR/output"

if [[ -d "$URL" ]]; then
    MOUNTED=true
fi

ZIP_NAME="$PROJECT_DIR/input/dummy"
if [ $MOUNTED == false ]; then
    if [[ "$URL" == "http"* ]]; then
        # URL detected
        RANDOMM=$(echo $RANDOM)
        ACTUAL_ZIP_NAME="$RANDOMM"_FIRMWARE.tgz
        ZIP_NAME="$PROJECT_DIR"/input/"$RANDOMM"_FIRMWARE.tgz
        DOWNLOAD "$URL" "$ZIP_NAME"
        URL="$ZIP_NAME"
    fi
    if [ "$DYNAMIC" == true ]; then
       "$PROJECT_DIR"/dynamic.sh "$URL" --odm --product --ext --oneplus --overlays --pixel
    elif [ $DYNAMIC == false ] ; then
       "$PROJECT_DIR"/zip2img.sh "$URL" "$PROJECT_DIR/working" || exit 1
    fi
    if [ $CLEAN == true ]; then
        rm -rf "$ZIP_NAME"
    fi
    if [ -f "$PROJECT_DIR/working/system.img" ]; then
        MOUNT "system.img" "system" "System"
        URL="$PROJECT_DIR/working/system"
        if [ -f "$PROJECT_DIR/working/vendor.img" ]; then
            if [ ! -f "$PROJECT_DIR/output/.tmp" ]; then
                MOUNT "vendor.img" "vendor" "Vendor"
            fi
        fi
    else
        echo "-> Error, System Image doesn't exists, abort!"
        exit 1
    fi
fi

if [ $AB == true ]; then
   "$PROJECT_DIR"/make.sh "${URL}" "${SRCTYPE}" AB ${NOVNDK} "$PROJECT_DIR/output" ${@} || LEAVE
fi

if [ -d "$PROJECT_DIR/tools/ROM_resigner/tmp/" ]; then
   sudo rm -rf "$PROJECT_DIR/tools/ROM_resigner/tmp/"
fi

if [ $AONLY == true ]; then
    "$PROJECT_DIR"/make.sh "${URL}" "${SRCTYPE}" Aonly ${NOVNDK} "$PROJECT_DIR/output" ${@} || LEAVE
fi

UMOUNT "$PROJECT_DIR/working/system"
UMOUNT "$PROJECT_DIR/working/vendor" > /dev/null 2>&1
rm -rf "$PROJECT_DIR/working"

if [ ! $USERNAME == "root" ]; then
    chown -R ${USERNAME}:${USERNAME} $PROJECT_DIR/output
fi

echo "-> Porting ${SRCTYPENAME} GSI done on: $PROJECT_DIR/output"
