#!/bin/bash
# Project OEM-GSI Porter by Erfan Abdi <erfangplus@gmail.com>
# Project Treble Experience by Hitalo <hitalo331@outlook.com> and Velosh <daffetyxd@gmail.com>

systemDir="$1"
if [ ! -d "$systemdir/xrom" ]; then
   sudo mkdir -p "$systemdir/xrom" > /dev/null 2>&1
   chmod 0755 "$systemdir/xrom"
fi
if [ ! -d "$systemdir/asdf" ]; then
   sudo mkdir -p "$systemdir/asdf" > /dev/null 2>&1
   chmod 0755 "$systemdir/asdf"
fi
if [ ! -d "$systemdir/APD" ]; then
   sudo mkdir -p "$systemdir/APD" > /dev/null 2>&1
   chmod 0755 "$systemdir/APD"
fi
if [ ! -d "$systemdir/ADF" ]; then
   sudo mkdir -p "$systemdir/ADF" > /dev/null 2>&1
   chmod 0755 "$systemdir/ADF"
fi
if [ ! -d "$systemdir/motor_fw1" ]; then
   sudo mkdir -p "$systemdir/motor_fw1" > /dev/null 2>&1
   chmod 0755 "$systemdir/motor_fw1"
fi

if [ ! -d "$systemdir/motor_fw2" ]; then
   sudo mkdir -p "$systemdir/motor_fw2" > /dev/null 2>&1
   chmod 0755 "$systemdir/motor_fw2"
fi
