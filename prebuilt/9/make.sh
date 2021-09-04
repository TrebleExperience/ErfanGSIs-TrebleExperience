#!/bin/bash

systempath=$1
romdir=$2
thispath=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Copy system stuffs
rsync -ra $thispath/system/ $systempath

## Brightness fix
# Some systems are using custom light services, don't apply this patch on those roms
if [ -f $romdir/DONTPATCHLIGHT ]; then
    echo "-> Patching lights for brightness fix is not supported in this rom. Skipping..."
else
    echo "-> Start Patching Light Services for Brightness Fix..."
    $thispath/brightnessfix/make.sh "$systempath"
fi
