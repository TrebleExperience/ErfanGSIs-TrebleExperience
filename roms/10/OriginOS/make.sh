#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Copy system files
rsync -ra $thispath/system/ $systempath
