#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Remove useless apks
rm -rf $1/app/AsusDeskClock
rm -rf $1/app/AtokIME
rm -rf $1/app/Facebook
rm -rf $1/app/FacebookMessenger
rm -rf $1/app/Instagram
rm -rf $1/app/JakartaBaca
rm -rf $1/app/NetflixActivation
rm -rf $1/app/Netflixstubplus
rm -rf $1/app/NextAppCore
rm -rf $1/app/mangaDeals
rm -rf $1/priv-app/AsusCalculator
rm -rf $1/priv-app/AsusCamera
rm -rf $1/priv-app/AsusDataTransfer
rm -rf $1/priv-app/AsusGallery
rm -rf $1/priv-app/AsusGallery
rm -rf $1/priv-app/FacebookInstaller
rm -rf $1/priv-app/FacebookNotificationServices
rm -rf $1/priv-app/GameBroadcaster
rm -rf $1/priv-app/LogUploader
rm -rf $1/priv-app/MyASUS
rm -rf $1/priv-app/NextApp
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
rm -rf $1/product/priv-app/AndroidAutoStub
rm -rf $1/product/priv-app/GoogleLens
rm -rf $1/product/priv-app/SearchSelector
rm -rf $1/product/priv-app/Turbo
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/Wellbeing