#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# debloat
rm -rf $1/app/datastatusnotification
rm -rf $1/app/QAS_DVC_MSP_VZW
rm -rf $1/app/VZWAPNLib
rm -rf $1/priv-app/CNEService
rm -rf $1/priv-app/DMService
rm -rf $1/priv-app/VzwOmaTrigger
rm -rf $1/priv-app/qcrilmsgtunnel

# SUPER DEBLOAT

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
