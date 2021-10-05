#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Use 11: RealmeUI's debloat
bash $thispath/../../11/RealmeUI/debloat.sh $1

# System Ext
rm -rf $1/system_ext/app/Athena
rm -rf $1/system_ext/app/CrashBox
rm -rf $1/system_ext/app/FidoAsm
rm -rf $1/system_ext/app/LogKit
rm -rf $1/system_ext/app/OplusEngineerCamera
rm -rf $1/system_ext/app/OplusEngineerMode
rm -rf $1/system_ext/app/SafeCenter
rm -rf $1/system_ext/app/aptxui

# my_stock
rm -rf $1/../my_stock/app/ADS
rm -rf $1/../my_stock/app/Aod
rm -rf $1/../my_stock/app/AssistantScreen
rm -rf $1/../my_stock/app/ChildrenSpace
rm -rf $1/../my_stock/app/CloudService
rm -rf $1/../my_stock/app/CodeBook
rm -rf $1/../my_stock/app/ColorAccessibilityAssistant
rm -rf $1/../my_stock/app/FindMyPhoneClient2
rm -rf $1/../my_stock/app/IFlySpeechService
rm -rf $1/../my_stock/app/Karaoke
rm -rf $1/../my_stock/app/MapComFrame
rm -rf $1/../my_stock/app/OplusSecurityKeyboard
rm -rf $1/../my_stock/app/OppoOperationManual
rm -rf $1/../my_stock/app/PhoneNOArea
rm -rf $1/../my_stock/app/Pictorial
rm -rf $1/../my_stock/app/ShareScreen
rm -rf $1/../my_stock/app/SmartEngine
rm -rf $1/../my_stock/app/SmartLock
rm -rf $1/../my_stock/app/VariUiEngine
rm -rf $1/../my_stock/app/WifiSecureDetect
rm -rf $1/../my_stock/priv-app/AccessoryFramework
rm -rf $1/../my_stock/priv-app/DCS
rm -rf $1/../my_stock/priv-app/FindMyPhone
rm -rf $1/../my_stock/priv-app/HeyCast
rm -rf $1/../my_stock/priv-app/HeySynergy
rm -rf $1/../my_stock/priv-app/MyDevices
rm -rf $1/../my_stock/priv-app/NumberRecognition
rm -rf $1/../my_stock/priv-app/OPSynergy
rm -rf $1/../my_stock/priv-app/OShare
rm -rf $1/../my_stock/priv-app/OplusScreenRecorder
rm -rf $1/../my_stock/priv-app/SceneService
rm -rf $1/../my_stock/priv-app/Screenshot

# my_stock: Drop useless apks
rm -rf $1/../my_stock/del-app/*

# my_heytap
rm -rf $1/../my_heytap/app/ARCore
rm -rf $1/../my_heytap/app/Browser
rm -rf $1/../my_heytap/app/FinShellWallet
rm -rf $1/../my_heytap/app/GlobalSearch
rm -rf $1/../my_heytap/app/Instant
rm -rf $1/../my_heytap/app/KeKePay
rm -rf $1/../my_heytap/app/KeKePay
rm -rf $1/../my_heytap/app/Music
rm -rf $1/../my_heytap/priv-app/HeyTapSpeechAssist

# my_heytap: Drop useless apks
rm -rf $1/../my_heytap/del-app/*

# my_product
rm -rf $1/../my_product/priv-app/SystemClone
rm -rf $1/../my_product/priv-app/OVoiceManagerService2Mic
rm -rf $1/../my_product/app/SystemClone
rm -rf $1/../my_product/app/OVoiceManagerService2Mic

# my_region
rm -rf $1/../my_product/app/DigitalWellBeing
rm -rf $1/../my_product/app/OppoTranslationService

# my_product: Drop useless apks
rm -rf $1/../my_product/del-app/*

# my_heytap: Drop some walls
rm -rf $1/../my_heytap/decouping_wallpaper/default/liveWallpaper/*