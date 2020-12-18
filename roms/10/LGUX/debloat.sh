#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Debloat 1
rm -rf $1/priv-app/Keep
rm -rf $1/priv-app/ARCoreStub
rm -rf $1/app/LensStub
rm -rf $1/app/GoogleNews
rm -rf $1/app/GOoglePay
rm -rf $1/app/Youtube
rm -rf $1/priv-app/Maps
rm -rf $1/priv-app/Velvet
rm -rf $1/priv-app/VsCamera
rm -rf $1/app/YouTube
rm -rf $1/app/Photos
rm -rf $1/app/Messages
rm -rf $1/app/Drive
rm -rf $1/app/Drive2
rm -rf $1/app/Gmail2
rm -rf $1/app/Translate
rm -rf $1/app/Duo
rm -rf $1/app/Videos
rm -rf $1/app/Music2
rm -rf $1/app/Keep
rm -rf $1/app/GoogleTTS
rm -rf $1/app/talkback
rm -rf $1/app/Maps
rm -rf $1/app/Velvet

# Debloat 2
rm -rf $1/product/app/CalculatorGoogle
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/Drive
rm -rf $1/product/app/Duo
rm -rf $1/product/app/Gmail2
rm -rf $1/product/app/Maps
rm -rf $1/product/app/Youtube
rm -rf $1/product/app/Keep
rm -rf $1/product/priv-app/Turbo
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/Wellbeing

