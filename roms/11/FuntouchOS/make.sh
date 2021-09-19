#!/bin/bash

# Disable cpu platform verification
sed -i '/ro.vivo.product.solution/d' $1/build.prop
sed -i '/ro.vivo.product.platform/d' $1/build.prop

# Resolution
sed -i '/ro.vivo.lcm.xhd/d' $1/build.prop