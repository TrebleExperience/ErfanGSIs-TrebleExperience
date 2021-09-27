#!/bin/bash

# Core variables, don't edit.
LOCALDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Get the blackshark init from /vendor
if [ -d $LOCALDIR/../../../working/vendor ]; then
    echo "-> Copying blackshark init scripts..."
    cp -frp $(find $LOCALDIR/../../../working/vendor -type f -name 'init.blackshark.rc') $1/etc/init/
    cp -frp $(find $LOCALDIR/../../../working/vendor -type f -name 'init.blackshark.common.rc') $1/etc/init/
    chmod 0644 $1/etc/init/init.blackshark*.rc
    echo " - Done."

    # Append file_context
    cat $thispath/file_contexts >> $1/etc/selinux/plat_file_contexts
fi
