#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# FB Shits
rm -rf $1/app/Facebook*
rm -rf $1/priv-app/Facebook*

# Instagram
rm -rf $1/app/Instagram

# YT Music
rm -rf $1/app/YTMusic

# Yandex
rm -rf $1/priv-app/Yandex*

# Product
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/Drive
rm -rf $1/product/app/Duo
rm -rf $1/product/app/Gmail2
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/app/Maps
rm -rf $1/product/app/Youtube
rm -rf $1/product/priv-app/Turbo
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/Wellbeing

# Debloat from Pie
rm -rf $1/priv-app/AsusGallery
rm -rf $1/priv-app/SmartReading
rm -rf $1/priv-app/AsusDataTransfer
rm -rf $1/priv-app/DisplayLink
rm -rf $1/priv-app/GameModeLiveWallpaper
rm -rf $1/priv-app/YandexBrowser
rm -rf $1/priv-app/YandexApp
rm -rf $1/priv-app/AsusCamera
rm -rf $1/app/Videos
rm -rf $1/app/GooglePay
rm -rf $1/app/Music2
rm -rf $1/app/Asphalt9
rm -rf $1/priv-app/AsusDataTransfer
rm -rf $1/app/BRApps
rm -rf $1/priv-app/AsusCamera
rm -rf $1/app/Netflixstubplus
rm -rf $1/app/NetflixActivation
rm -rf $1/priv-app/WeatherTime
rm -rf $1/priv-app/FacebookInstaller
rm -rf $1/priv-app/FacebookNotificationServices
rm -rf $1/priv-app/MyASUS
rm -rf $1/priv-app/AsusLocalBackup
rm -rf $1/app/AtokIME
rm -rf $1/app/JakartaBaca
rm -rf $1/app/talkback
rm -rf $1/app/mangaDeals
rm -rf $1/priv-app/LogUploader
rm -rf $1/priv-app/ZenUIHelp