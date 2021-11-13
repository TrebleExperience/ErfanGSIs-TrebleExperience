#!/bin/bash
# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>
# Project Treble Experience by Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>

systemDir="$1"
if [ ! -d "$systemdir/my_carrier" ]; then
   sudo mkdir -p "$systemdir/my_carrier" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_carrier"
fi
if [ ! -d "$systemdir/my_company" ]; then
   sudo mkdir -p "$systemdir/my_company" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_company"
fi
if [ ! -d "$systemdir/my_custom" ]; then
   sudo mkdir -p "$systemdir/my_custom" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_custom"
fi
if [ ! -d "$systemdir/my_engineering" ]; then
   sudo mkdir -p "$systemdir/my_engineering" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_engineering"
fi
if [ ! -d "$systemdir/my_heytap" ]; then
   sudo mkdir -p "$systemdir/my_heytap" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_heytap"
fi
if [ ! -d "$systemdir/my_manifest" ]; then
   sudo mkdir -p "$systemdir/my_manifest" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_manifest"
fi
if [ ! -d "$systemdir/my_preload" ]; then
   sudo mkdir -p "$systemdir/my_preload" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_preload"
fi
if [ ! -d "$systemdir/my_product" ]; then
   sudo mkdir -p "$systemdir/my_product" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_product"
fi
if [ ! -d "$systemdir/my_region" ]; then
   sudo mkdir -p "$systemdir/my_region" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_region"
fi
if [ ! -d "$systemdir/my_stock" ]; then
   sudo mkdir -p "$systemdir/my_stock" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_stock"
fi
if [ ! -d "$systemdir/my_version" ]; then
   sudo mkdir -p "$systemdir/my_version" > /dev/null 2>&1
   chmod 0755 "$systemdir/my_version"
fi
if [ ! -d "$systemdir/special_preload" ]; then
   sudo mkdir -p "$systemdir/special_preload" > /dev/null 2>&1
   chmod 0755 "$systemdir/special_preload"
fi