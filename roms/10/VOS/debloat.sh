#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# New debloat
rm -rf $1/app/Duo
rm -rf $1/app/Drive
rm -rf $1/app/Gmail2
rm -rf $1/app/Maps
rm -rf $1/app/Photos
rm -rf $1/app/Videos
rm -rf $1/app/Youtube
rm -rf $1/priv-app/Velvet
rm -rf $1/priv-app/VsCamera
rm -rf $1/product/app/CalculatorGoogle
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/DeskClockGoogle
rm -rf $1/product/app/GoogleLocationHistory
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/app/Keep
rm -rf $1/product/app/talkback
rm -rf $1/product/app/WebViewGoogle
rm -rf $1/product/app/YTMusic
rm -rf $1/product/priv-app/AndroidAutoStub
rm -rf $1/product/priv-app/GoogleFeedback
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/Turbo
rm -rf $1/product/priv-app/Wellbeing
