#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# System Ext
rm -rf $1/system_ext/app/LogKit
rm -rf $1/system_ext/app/NfcNci
rm -rf $1/system_ext/app/OV*
rm -rf $1/system_ext/app/OplusEng*
rm -rf $1/system_ext/app/OppoEng*
rm -rf $1/system_ext/app/uce*
rm -rf $1/system_ext/priv-app/OnePlusCamera
rm -rf $1/system_ext/priv-app/QAS*
rm -rf $1/system_ext/priv-app/dpm*

# my_stock
rm -rf $1/../my_stock/app/ADS
rm -rf $1/../my_stock/app/AIUnitService
rm -rf $1/../my_stock/app/Aod
rm -rf $1/../my_stock/app/AssistantScreen
rm -rf $1/../my_stock/app/Calendar
rm -rf $1/../my_stock/app/ChildrenSpace
rm -rf $1/../my_stock/app/Clock
rm -rf $1/../my_stock/app/CloudService
rm -rf $1/../my_stock/app/CodeBook
rm -rf $1/../my_stock/app/ColorAccessibilityAssistant
rm -rf $1/../my_stock/app/FindMyPhoneClient2
rm -rf $1/../my_stock/app/FloatAssistant
rm -rf $1/../my_stock/app/GameSpace
rm -rf $1/../my_stock/app/IFlySpeechService
rm -rf $1/../my_stock/app/Karaoke
rm -rf $1/../my_stock/app/MCS
rm -rf $1/../my_stock/app/MapComFrame
rm -rf $1/../my_stock/app/OplusSecurityKeyboard
rm -rf $1/../my_stock/app/OppoOperationManual
rm -rf $1/../my_stock/app/OppoSecurityKeyboard
rm -rf $1/../my_stock/app/PhoneNOArea
rm -rf $1/../my_stock/app/PhoneNOAreaInquireProvider
rm -rf $1/../my_stock/app/Pictorial
rm -rf $1/../my_stock/app/ShareScreen
rm -rf $1/../my_stock/app/SmartEngine
rm -rf $1/../my_stock/app/SmartLock
rm -rf $1/../my_stock/app/VariUiEngine
rm -rf $1/../my_stock/app/WifiSecureDetect
rm -rf $1/../my_stock/priv-app/FindMyPhone
rm -rf $1/../my_stock/priv-app/HeyCast
rm -rf $1/../my_stock/priv-app/HeySynergy
rm -rf $1/../my_stock/priv-app/KeKeUserCenter
rm -rf $1/../my_stock/priv-app/MyDevices
rm -rf $1/../my_stock/priv-app/NumberRecognition
rm -rf $1/../my_stock/priv-app/OPSynergy
rm -rf $1/../my_stock/priv-app/OShare
rm -rf $1/../my_stock/priv-app/OppoBootReg
rm -rf $1/../my_stock/priv-app/OppoDCS
rm -rf $1/../my_stock/priv-app/OppoGallery2
rm -rf $1/../my_stock/priv-app/SmartDrive
rm -rf $1/../my_stock/priv-app/VideoGallery

# my_region
rm -rf $1/../my_region/app/DigitalWellBeing
rm -rf $1/../my_region/app/OcrScanner
rm -rf $1/../my_region/app/OcrService
rm -rf $1/../my_region/app/OppoTranslationService

# my_region: Drop useless apks
rm -rf $1/../my_region/del-app/*

# my_stock: Drop useless apks
rm -rf $1/../my_stock/del-app/*

# my_heytap
rm -rf $1/../my_heytap/app/ARCore
rm -rf $1/../my_heytap/app/ARCore_stub
rm -rf $1/../my_heytap/app/Browser
rm -rf $1/../my_heytap/app/CalendarGoogle
rm -rf $1/../my_heytap/app/Chrome
rm -rf $1/../my_heytap/app/FinShellWallet
rm -rf $1/../my_heytap/app/GlobalSearch
rm -rf $1/../my_heytap/app/Gmail2
rm -rf $1/../my_heytap/app/GmsCore
rm -rf $1/../my_heytap/app/GoogleTTS
rm -rf $1/../my_heytap/app/Instant
rm -rf $1/../my_heytap/app/KeKePay
rm -rf $1/../my_heytap/app/Keep
rm -rf $1/../my_heytap/app/Maps
rm -rf $1/../my_heytap/app/SoundAmplifier
rm -rf $1/../my_heytap/app/TrichromeLibraryCN
rm -rf $1/../my_heytap/app/WebViewGoogleCN
rm -rf $1/../my_heytap/app/YouTube
rm -rf $1/../my_heytap/app/talkback
rm -rf $1/../my_heytap/app/talkback
rm -rf $1/../my_heytap/priv-app/AndroidAutoStub
rm -rf $1/../my_heytap/priv-app/HeyTapSpeechAssist
rm -rf $1/../my_heytap/priv-app/TagGoogle
rm -rf $1/../my_heytap/priv-app/Velvet
rm -rf $1/../my_heytap/priv-app/Wellbeing

# my_heytap: Drop useless apks
rm -rf $1/../my_heytap/del-app/*

# my_product
rm -rf $1/../my_product/app/OVoiceManagerService2Mic
rm -rf $1/../my_product/app/OVoiceManagerSkillService

# my_product: Drop useless apks
rm -rf $1/../my_product/del-app/*

# my_heytap: Drop some walls
rm -rf $1/../my_heytap/decouping_wallpaper/default/liveWallpaper/*