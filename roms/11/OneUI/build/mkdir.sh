#!/bin/bash
# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>
# Project Treble Experience by Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>

systemDir="$1"
if [ ! -d "$systemdir/omr" ]; then
   sudo mkdir -p "$systemdir/omr" > /dev/null 2>&1
   chmod 0755 "$systemdir/omr"
fi
if [ ! -d "$systemdir/prism" ]; then
   sudo mkdir -p "$systemdir/prism" > /dev/null 2>&1
   chmod 0755 "$systemdir/prism"
fi
if [ ! -d "$systemdir/optics" ]; then
   sudo mkdir -p "$systemdir/optics" > /dev/null 2>&1
   chmod 0755 "$systemdir/optics"
fi
if [ ! -d "$systemdir/spu" ]; then
   sudo mkdir -p "$systemdir/spu" > /dev/null 2>&1
   chmod 0755 "$systemdir/spu"
fi