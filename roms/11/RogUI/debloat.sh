#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Drop some apks
rm -rf $1/app/Facebook*
rm -rf $1/app/Instagram
rm -rf $1/app/JakartaBaca
rm -rf $1/app/NextAppCore
rm -rf $1/app/TwinApps
rm -rf $1/app/TwinAppsService
rm -rf $1/priv-app/*LiveWallpaper*
rm -rf $1/priv-app/AsusCamera
rm -rf $1/priv-app/AsusDataTransfer
rm -rf $1/priv-app/AsusGallery
rm -rf $1/priv-app/Facebook*
rm -rf $1/priv-app/NextApp
rm -rf $1/priv-app/ROGAirTrigger
rm -rf $1/priv-app/ROGGameCenter
rm -rf $1/priv-app/SmartReading
rm -rf $1/priv-app/WeatherTime
rm -rf $1/priv-app/YandexApp
rm -rf $1/priv-app/YandexBrowser
rm -rf $1/product/app/ARCore
rm -rf $1/product/app/ASUSAR
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/Chrome
rm -rf $1/product/app/Gmail2
rm -rf $1/product/app/GooglePay
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/app/Maps
rm -rf $1/product/app/Messages
rm -rf $1/product/app/YTMusic
rm -rf $1/product/app/YouTube
rm -rf $1/product/app/talkback
rm -rf $1/product/priv-app/AndroidAutoStub
rm -rf $1/product/priv-app/GoogleLens
rm -rf $1/product/priv-app/SearchSelector
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/Wellbeing
rm -rf $1/system_ext/priv-app/EmergencyInfo
rm -rf $1/system_ext/priv-app/GoogleFeedback

# Drop some useless shits
rm -rf $1/etc/preload/*

# ZenUI debloat
rm -rf $1/app/ATOKIME
rm -rf $1/app/Amight
rm -rf $1/app/Facebook
rm -rf $1/app/FacebookMessenger
rm -rf $1/app/Instagram
rm -rf $1/app/JakartaBaca
rm -rf $1/app/NePlayer
rm -rf $1/app/NetflixActivation
rm -rf $1/app/Netflixstubplus
rm -rf $1/app/NextAppCore
rm -rf $1/app/OpenBeta
rm -rf $1/app/UNISONAIR
rm -rf $1/app/mangaDeals
rm -rf $1/app/slaservice
rm -rf $1/priv-app/AsusCalculator
rm -rf $1/priv-app/AsusCamera
rm -rf $1/priv-app/AsusContacts
rm -rf $1/priv-app/AsusDataTransfer
rm -rf $1/priv-app/AsusDeskClock
rm -rf $1/priv-app/AsusDialer
rm -rf $1/priv-app/AsusEmergencyHelp
rm -rf $1/priv-app/AsusGallery
rm -rf $1/priv-app/AsusGallery
rm -rf $1/priv-app/AsusGalleryBurst
rm -rf $1/priv-app/AsusSoundRecorder
rm -rf $1/priv-app/FacebookInstaller
rm -rf $1/priv-app/FacebookNotificationServices
rm -rf $1/priv-app/GameBroadcaster
rm -rf $1/priv-app/LogUploader
rm -rf $1/priv-app/MyASUS
rm -rf $1/priv-app/NextApp
rm -rf $1/priv-app/ONS
rm -rf $1/priv-app/ScreenRecorder
rm -rf $1/priv-app/TwinViewLauncher
rm -rf $1/priv-app/WeatherTime
rm -rf $1/priv-app/YandexApp
rm -rf $1/priv-app/YandexBrowser
rm -rf $1/priv-app/ZenUIHelp
rm -rf $1/product/app/ARCore
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/Chrome
rm -rf $1/product/app/Gmail2
rm -rf $1/product/app/GooglePay
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/app/Maps
rm -rf $1/product/app/Messages
rm -rf $1/product/app/YTMusic
rm -rf $1/product/app/YouTube
rm -rf $1/product/app/talkback
rm -rf $1/product/priv-app/Turbo