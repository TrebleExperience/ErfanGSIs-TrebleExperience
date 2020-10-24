#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# small debloat
rm -rf $1/product/app/YouTube
rm -rf $1/app/ims
rm -rf $1/priv-app/qcrilmsgtunnel
rm -rf $1/product/app/GoogleCamera
rm -rf $1/product/app/NexusWallpapersStubPrebuilt2017
rm -rf $1/product/app/WallpapersBReel2017
rm -rf $1/product/priv-app/EuiccSupportPixel

# Some Unused Google Apps
rm -rf $1/product/app/Music2
rm -rf $1/product/app/Photos
rm -rf $1/product/app/Videos
rm -rf $1/product/app/CalculatorGooglePrebuilt
rm -rf $1/product/app/CalendarGooglePrebuilt
rm -rf $1/product/app/Camera2
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/app/LocationHistoryPrebuilt
rm -rf $1/product/app/MarkupGoogle
rm -rf $1/product/app/MicropaperPrebuilt
rm -rf $1/product/app/Photos
rm -rf $1/product/app/PrebuiltDeskClockGoogle
rm -rf $1/product/app/PrebuiltBugle
rm -rf $1/product/app/Velvet
rm -rf $1/product/app/TurboPrebuilt
rm -rf $1/product/app/TipsPrebuilt
rm -rf $1/product/app/WellbeingPrebuilt