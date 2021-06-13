#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Copy NotchKiller overlay
cp -frp $thispath/overlay/* $1/product/overlay/