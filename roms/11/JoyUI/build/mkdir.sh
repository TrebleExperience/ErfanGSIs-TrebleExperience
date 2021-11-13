#!/bin/bash
# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>
# Project Treble Experience by Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>

systemDir="$1"
if [ ! -d "$systemdir/junk" ]; then
   sudo mkdir -p "$systemdir/junk" > /dev/null 2>&1
   chmod 0755 "$systemdir/junk"
fi