#!/bin/bash

# Project Treble Experience by Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>
# Written by Velosh <daffetyxd@gmail.com>

# Core variables, don't edit.
LOCALDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SYSTEMDIR="$1"
ROMDIR="$2"
AVERSION="$3"

# DropManufacturer: Always patch services.jar to drop message from the manufacturer
#$LOCALDIR/DropManufacturer/make.sh $SYSTEMDIR $ROMDIR $AVERSION

# PlayStoreFSVerity: Try to fix non-verified device in non-gms GSIs
$LOCALDIR/PlayStoreFSVerity/make.sh $SYSTEMDIR $ROMDIR $AVERSION
