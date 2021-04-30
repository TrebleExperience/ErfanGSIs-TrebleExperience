#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

rm -rf $1/priv-app/GoogleCameraGo
rm -rf $1/priv-app/TagGoogle
rm -rf $1/product/app/arcore
rm -rf $1/product/app/CalculatorGooglePrebuilt
rm -rf $1/product/app/CalendarGooglePrebuilt
rm -rf $1/product/app/Drive
rm -rf $1/product/app/LocationHistoryPrebuilt
rm -rf $1/product/app/Music
rm -rf $1/product/app/Photos
rm -rf $1/product/app/PrebuiltBugle
rm -rf $1/product/app/PrebuiltDeskClockGoogle
rm -rf $1/product/app/PrebuiltGmail
rm -rf $1/product/app/talkback
rm -rf $1/product/priv-app/AndroidAutoStubPrebuilt
rm -rf $1/product/priv-app/GoogleDialer
rm -rf $1/product/priv-app/RecorderPrebuilt
rm -rf $1/product/priv-app/SafetyHubPrebuilt
rm -rf $1/product/priv-app/TurboPrebuilt
rm -rf $1/product/priv-app/WellbeingPrebuilt
rm -rf $1/system_ext/priv-app/GoogleFeedback
