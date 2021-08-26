#!/bin/bash
# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>
# Project TrebleExperience by riansouzasantos <riansart@yahoo.com>, Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>

systemDir="$1"
if [ ! -d "$systemdir/vgc" ]; then
   sudo mkdir -p "$systemdir/vgc" > /dev/null 2>&1
   chmod 0755 "$systemdir/vgc"
fi