#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

rm -rf $1/../my_heytap/app/FinShellWallet
rm -rf $1/../my_heytap/app/GlobalSearch
rm -rf $1/../my_heytap/app/Instant
rm -rf $1/../my_heytap/app/InstantService
rm -rf $1/../my_heytap/app/Music
rm -rf $1/../my_heytap/decouping_wallpaper/default/liveWallpaper/*
rm -rf $1/../my_heytap/del-app/*
rm -rf $1/../my_heytap/priv-app/ConfigUpdater
rm -rf $1/../my_heytap/priv-app/GooglePlayServicesUpdater
rm -rf $1/../my_heytap/priv-app/HeyTapSpeechAssist
rm -rf $1/../my_heytap/priv-app/Music
rm -rf $1/../my_product/app/OVoiceManagerService2Mic
rm -rf $1/../my_product/app/OVoiceManagerSkillService
rm -rf $1/../my_product/del-app/*
rm -rf $1/../my_region/app/OcrScanner
rm -rf $1/../my_region/app/OcrService
rm -rf $1/../my_region/app/OppoTranslationService
rm -rf $1/../my_region/del-app/*
rm -rf $1/../my_stock/app/Aod
rm -rf $1/../my_stock/app/AssistantScreen
rm -rf $1/../my_stock/app/COSA
rm -rf $1/../my_stock/app/Calendar
rm -rf $1/../my_stock/app/ChildrenSpace
rm -rf $1/../my_stock/app/Clock
rm -rf $1/../my_stock/app/CodeBook
rm -rf $1/../my_stock/app/FloatAssistant
rm -rf $1/../my_stock/app/FocusMode
rm -rf $1/../my_stock/app/IFlySpeechService
rm -rf $1/../my_stock/app/MapComFrame
rm -rf $1/../my_stock/app/OppoCamera
rm -rf $1/../my_stock/app/Pictorial
rm -rf $1/../my_stock/app/SmartLock
rm -rf $1/../my_stock/del-app/*
rm -rf $1/../my_stock/priv-app/FindMyPhone
rm -rf $1/../my_stock/priv-app/OppoGallery2
rm -rf $1/../my_stock/priv-app/SmartDrive
rm -rf $1/../my_stock/priv-app/VideoGallery
rm -rf $1/system_ext/app/LogKit
rm -rf $1/system_ext/app/NfcNci
rm -rf $1/system_ext/app/OV*
rm -rf $1/system_ext/app/OplusEng*
rm -rf $1/system_ext/app/OppoEng*
rm -rf $1/system_ext/app/uce*
rm -rf $1/system_ext/priv-app/OnePlusCamera
rm -rf $1/system_ext/priv-app/QAS*
rm -rf $1/system_ext/priv-app/dpm*
