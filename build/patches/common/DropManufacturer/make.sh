#!/bin/bash

# Project Treble Experience by Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>
# Written by Velosh <daffetyxd@gmail.com>

set +e

# Core variables, don't edit.
SYSTEMDIR="$1"
SERVICES="$SYSTEMDIR/framework/services.jar"

# Init tmp variable.
LOCALDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TMPDIR="$LOCALDIR/../../../tmp/services_tmp"
APKTOOL="$LOCALDIR/../../../tools/apktool/apktool.jar"
[[ -d "$TMPDIR" ]] && rm -rf "$TMPDIR"
mkdir -p $TMPDIR
cd $TMPDIR

# Start the process: Decompile & patch
echo "-> Trying to patch services.jar, wait a moment..."
java -jar $APKTOOL d $SERVICES --output $TMPDIR -f >> $TMPDIR/services.log 2>&1

# Check if ActivityManagerService.smali exists or no
if [ ! -f $TMPDIR/smali/com/android/server/am/ActivityManagerService.smali ]; then
    echo " - Fatal error! ActivityManagerService.smali file doens't exists, isn't possible to patch. Abort."
    exit 1
fi

# Start the process: Recompile
echo " - Patch process initialized, this may take some time."
sed -i "/invoke-virtual {v0}, Lcom\/android\/server\/wm\/ActivityTaskManagerInternal;->showSystemReadyErrorDialogsIfNeeded()V/d" $TMPDIR/smali/com/android/server/am/ActivityManagerService.smali >> /dev/null 2>&1
cd $TMPDIR && java -jar $APKTOOL b --output $TMPDIR/services.jar >> $TMPDIR/services.log 2>&1

if [[ $? -ge 1 ]]; then
    echo " - Failed to patch! Abort."
    exit 1
else
    # Double-check if we got true result
    if [ -f "$TMPDIR/services.jar" ]; then
        # Backup: Create a services.jar.bak as services.jar backup (if GSI fails to start due to dalvik security)
        cp -frp $SERVICES $SYSTEMDIR/framework/services.jar.bak

        mv $TMPDIR/services.jar $SYSTEMDIR/framework/services.jar
        chown root:root $SYSTEMDIR/framework/services.jar && chmod 0644 $SYSTEMDIR/framework/services.jar

        echo " - Patched services.jar successfully! The original services.jar file was saved (inside /system/framework) as: services.jar.bak (If GSI fails to start (or bootloop) due to dalvik security)"
    else
        echo " - Failed to patch! Abort."
        exit 1
    fi
fi
