#!/bin/bash

### [<SQUASHED>] Merge SGSI patches
# Drop some props
sed -i "/media.settings.xml/d" $1/build.prop
### [<SQUASHED/>] Merge SGSI patches

# Try to fix data mobile issue in some vendors
sed -i "/telephony.lteOnCdmaDevice/d" $1/build.prop
