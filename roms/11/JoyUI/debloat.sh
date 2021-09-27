#!/bin/bash

# Drop useless apks
rm -rf $1/data-app/*

# Drop some wallpaper apks
rm -rf $1/app/MiWallpaperEarth
rm -rf $1/app/MiWallpaperMars

# System
rm -rf $1/app/BSPay
rm -rf $1/app/BsLightApp
rm -rf $1/app/UmeBrowser
rm -rf $1/app/VoiceAssist
rm -rf $1/app/VoiceTrigger
rm -rf $1/app/baiduime
rm -rf $1/priv-app/Calendar
rm -rf $1/priv-app/MiuiCamera
rm -rf $1/priv-app/MiuiVideo
rm -rf $1/priv-app/MiuiVideo
rm -rf $1/priv-app/Music
rm -rf $1/priv-app/tencentappstore