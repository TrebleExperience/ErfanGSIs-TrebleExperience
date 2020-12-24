#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

## New debloat
rm -rf $1/app/ARCore_stub
rm -rf $1/app/BackupAndRestore
rm -rf $1/app/BTtestmode
rm -rf $1/app/NewSoundRecorder
rm -rf $1/app/BuiltInPrintService
rm -rf $1/app/Calculator2
rm -rf $1/app/Clock
rm -rf $1/app/ChildrenSpace
rm -rf $1/app/com.facebook.appmanager-common_us
rm -rf $1/app/CtsShimPrebuilt
rm -rf $1/app/EmailPartnerProvider
rm -rf $1/app/GooglePrintRecommendationService
rm -rf $1/app/GameSpace
rm -rf $1/app/NXPNfcNci
rm -rf $1/app/OcrService
rm -rf $1/app/OppoCamera
rm -rf $1/app/OppoDCS
rm -rf $1/app/OppoMusic
rm -rf $1/app/OcrScanner
rm -rf $1/app/Stk
rm -rf $1/app/KeKePay
rm -rf $1/app/SecurePay
rm -rf $1/app/SecureElement
rm -rf $1/app/SafeCenter
rm -rf $1/priv-app/Browser
rm -rf $1/priv-app/com.facebook.services-common_us
rm -rf $1/priv-app/com.facebook.system-common_us
rm -rf $1/priv-app/CtsShimPrivPrebuilt
rm -rf $1/priv-app/ModemTestMode
rm -rf $1/priv-app/NewSoundRecorder
rm -rf $1/priv-app/KeKeMarket
rm -rf $1/priv-app/SmartDrive
rm -rf $1/priv-app/OppoBootReg
rm -rf $1/priv-app/OppoGallery2
rm -rf $1/priv-app/VideoGallery
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/Gmail2
rm -rf $1/product/app/GoogleLocationHistory
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/app/Keep
rm -rf $1/product/app/Maps
rm -rf $1/product/app/talkback
rm -rf $1/product/app/YouTube
rm -rf $1/product/priv-app/AndroidAutoStub
rm -rf $1/product/priv-app/GoogleFeedback
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/Wellbeing

### Bonus: Remove facebook shits
rm -rf $1/media/theme/default/com.facebook.katana/
rm -rf $1/etc/sysconfig/facebook-hiddenapi-package-whitelist.xml

### Bonus: Remove cringe zip
rm -rf $1/sysmd5.zip

### Bonus: Remove dump apks
rm -rf $1/reserve/
