#!/bin/bash

# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

AB=true
AONLY=true
MOUNTED=false
CLEAN=false
DYNAMIC=false
LOCK="$PROJECT_DIR/cache/.lock"

echo "-> Warning: That Fork is VelanGSIs (a.k.a: YuMiGSIs), originally from ErfanGSIs"
echo " - You can edit the tool but read the NOTICE!"

if [ -f "$LOCK" ]; then
    echo "-> Stop, wait for the other job to finish before you can start another one."
    exit 1
else
    mkdir -p "$PROJECT_DIR/cache/"
    touch "$LOCK"
    echo "-> Making patch: Cleaning and removing folders that are used to make GSI to avoid problems"
    if [ -d "$PROJECT_DIR/working/system/" ]; then
        sudo umount "$PROJECT_DIR/working/system/"
    fi
    if [ -d "$PROJECT_DIR/tools/ROM_resigner/tmp/" ]; then
        sudo rm -rf "$PROJECT_DIR/tools/ROM_resigner/tmp/"
    fi
    sudo rm -rf "$PROJECT_DIR/cache/" "$PROJECT_DIR/tmp/" "$PROJECT_DIR/working/"
fi

usage()
{
    echo "Usage: [--help|-h|-?] [--dynamic|-d] [--ab|-b] [--aonly|-a] [--mounted|-m] [--cleanup|-c] $0 <Firmware link> <Firmware type> [Other args]"
    echo -e "\tFirmware link: Firmware download link or local path"
    echo -e "\tFirmware type: Firmware mode"
    echo -e "\t--dynamic: Use this option only if the firmware contains dynamic partitions"
    echo -e "\t--ab: Build only AB"
    echo -e "\t--aonly: Build only A-Only"
    echo -e "\t--cleanup: Cleanup downloaded firmware"
    echo -e "\t--help: To show this info"
}

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    --dynamic|-d)
    DYNAMIC=true
    shift
    ;;
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
    aria2c -x16 -j$(nproc) -U "Mozilla/5.0" -d "$PROJECT_DIR/input" -o "$ACTUAL_ZIP_NAME" ${URL} > /dev/null 2>&1 || wget -U "Mozilla/5.0" ${URL} -O "$ZIP_NAME" > /dev/null 2>&1
}

MOUNT()
{
    mkdir -p "$PROJECT_DIR/working/system"
    if [ $(uname) == Linux ]; then
        sudo mount -o ro "$1" "$PROJECT_DIR/working/system"
    elif [ $(uname) == Darwin ]; then
        fuse-ext2 "$1" "$PROJECT_DIR/working/system"
    fi
}

UMOUNT()
{
    sudo umount "$1"
}

LEAVE()
{
    UMOUNT "$PROJECT_DIR/working/system"
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
       "$PROJECT_DIR"/dynamic.sh "$URL" --odm --product --ext --oneplus --overlays
    elif [ $DYNAMIC == false ] ; then
       "$PROJECT_DIR"/zip2img.sh "$URL" "$PROJECT_DIR/working" || exit 1
    fi
    if [ $CLEAN == true ]; then
        rm -rf "$ZIP_NAME"
    fi
    MOUNT "$PROJECT_DIR/working/system.img"
    URL="$PROJECT_DIR/working/system"
fi

if [ $AB == true ]; then
   "$PROJECT_DIR"/make.sh "${URL}" "${SRCTYPE}" AB "$PROJECT_DIR/output" ${@} || LEAVE
fi

if [ -d "$PROJECT_DIR/tools/ROM_resigner/tmp/" ]; then
   sudo rm -rf "$PROJECT_DIR/tools/ROM_resigner/tmp/"
fi

if [ $AONLY == true ]; then
    "$PROJECT_DIR"/make.sh "${URL}" "${SRCTYPE}" Aonly "$PROJECT_DIR/output" ${@} || LEAVE
fi

UMOUNT "$PROJECT_DIR/working/system"
rm -rf "$PROJECT_DIR/working"

echo "-> Porting ${SRCTYPENAME} GSI done on: $PROJECT_DIR/output"

if [[ -f "$PROJECT_DIR/private_utils.sh" ]]; then
    . "$PROJECT_DIR/private_utils.sh"
    UPLOAD "$PROJECT_DIR/output" ${SRCTYPENAME} ${AB} ${AONLY} "${ORIGINAL_URL}"
fi

DEBUG=false
if [ $DEBUG == true ]; then
echo "AONLY = ${AONLY}"
echo "AB = ${AB}"
echo "MOUNTED = ${MOUNTED}"
echo "URL = ${URL}"
echo "SRCTYPE = ${SRCTYPE}"
echo "SRCTYPENAME = ${SRCTYPENAME}"
echo "OTHER = ${@}"
echo "ZIP_NAME = ${ZIP_NAME}"
fi
