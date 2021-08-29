#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Copy missing framework jar into system
rsync -ra $thispath/system/ $systempath

### [<SQUASHED>] Merge SGSI patches
# Drop some props
sed -i "/media.settings.xml/d" $1/build.prop
### [<SQUASHED/>] Merge SGSI patches

# Try to fix data mobile issue in some vendors
sed -i "/telephony.lteOnCdmaDevice/d" $1/build.prop
