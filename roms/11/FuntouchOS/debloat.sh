#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Remove stock apks
rm -rf $1/app/ARCoreStub0
rm -rf $1/app/BBKFMRadio
rm -rf $1/app/BBKLOG
rm -rf $1/app/BBKMusic
rm -rf $1/app/BBKNotes
rm -rf $1/app/BBKSoundRecorder
rm -rf $1/app/BBSPTest
rm -rf $1/app/Calculator
rm -rf $1/app/Compass
rm -rf $1/app/EngineerCamera
rm -rf $1/app/Feedback
rm -rf $1/app/GameCube
rm -rf $1/app/GameWatch
rm -rf $1/app/GlobalSearch
rm -rf $1/app/GmailProvider
rm -rf $1/app/LogSystem
rm -rf $1/app/PlayAutoInstallStub
rm -rf $1/app/VideoEditor
rm -rf $1/app/VideoPlayer
rm -rf $1/app/VivoAssistant
rm -rf $1/app/VivoCamera
rm -rf $1/app/VivoGallery
rm -rf $1/app/VivoTips
rm -rf $1/app/VivoWebsite
rm -rf $1/app/vivoDemoVideo
rm -rf $1/app/vivoEngineerMode
rm -rf $1/app/vivogame
rm -rf $1/priv-app/LocalTransport
rm -rf $1/priv-app/ONS
rm -rf $1/priv-app/Omacp
rm -rf $1/priv-app/VivoBrowser
rm -rf $1/priv-app/VivoOffice
rm -rf $1/product/priv-app/SearchSelector

# Remove facebook apks
rm -rf $1/app/facebook-appmanager
rm -rf $1/priv-app/facebook-installer
rm -rf $1/priv-app/facebook-services

# Remove GApps apks
rm -rf $1/app/GoogleLens
rm -rf $1/app/GoogleLensTier
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/GoogleContacts
rm -rf $1/product/app/Chrome
rm -rf $1/product/app/Duo
rm -rf $1/product/app/Gmail2
rm -rf $1/product/app/GoogleAssistant
rm -rf $1/product/app/GooglePay
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/app/Keep
rm -rf $1/product/app/Maps
rm -rf $1/product/app/Photos
rm -rf $1/product/app/YTMusic
rm -rf $1/product/app/YouTube
rm -rf $1/product/app/talkback
rm -rf $1/product/priv-app/AndroidAutoStub
rm -rf $1/product/priv-app/GoogleDialer
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/Wellbeing

# Remove useless folder
rm -rf $1/data