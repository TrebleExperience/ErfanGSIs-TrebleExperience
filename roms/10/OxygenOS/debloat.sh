#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

rm -rf $1/etc/GeoIP2-City.mmdb
rm -rf $1/etc/apps/in

# RIL FIX
rm -rf $1/product/framework/op-telephony-common.jar

# Nuke OnePlus useless reserve apks
rm -rf $1/reserve/Calculator
rm -rf $1/reserve/OPSyncCenter
rm -rf $1/reserve/OnePlusPods
rm -rf $1/reserve/SmartHome
rm -rf $1/reserve/NewsArticle
rm -rf $1/reserve/OPWallet
rm -rf $1/reserve/QQReader
rm -rf $1/reserve/TencentVideo
rm -rf $1/reserve/GameCenter
rm -rf $1/reserve/NearmePlay
rm -rf $1/reserve/OPBackupRestore
rm -rf $1/reserve/OPNote
rm -rf $1/reserve/OPWallpaperResources
rm -rf $1/reserve/Reader
rm -rf $1/reserve/UCBrowser
rm -rf $1/reserve/GaodeChuxing
rm -rf $1/reserve/NeteaseCloudmusic
rm -rf $1/reserve/OPCommunity
rm -rf $1/reserve/OPRoamingAppRelease
rm -rf $1/reserve/OPWidget
rm -rf $1/reserve/SinaWeibo
rm -rf $1/reserve/CanvasResources
rm -rf $1/reserve/OPSoundRecorder
rm -rf $1/reserve/OPForum
rm -rf $1/reserve/Weather
rm -rf $1/reserve/SoundRecorder
rm -rf $1/reserve/alipay
rm -rf $1/reserve/amap
rm -rf $1/reserve/ctrip
rm -rf $1/reserve/YoudaoDict
rm -rf $1/reserve/TencentNews
rm -rf $1/reserve/JD
rm -rf $1/reserve/Meituan
rm -rf $1/reserve/NeteaseMail


# Nuke OnePlus useless app apks
rm -rf $1/app/GooglePay
rm -rf $1/app/Netflix_Activation
rm -rf $1/app/Netflix_Stub
rm -rf $1/app/OPYellowpage
rm -rf $1/app/OPWallpaperResources
rm -rf $1/app/OEMLogKit
rm -rf $1/app/OPBackup
rm -rf $1/app/QQBrowser
rm -rf $1/app/ARCore_stub
rm -rf $1/app/AntHalService
rm -rf $1/app/Calculator
rm -rf $1/app/CtsShimPrebuilt
rm -rf $1/app/EngineeringMode
rm -rf $1/app/EngSpecialTest
rm -rf $1/app/OPBreathMode
rm -rf $1/app/OPPush
rm -rf $1/app/OsuLogin
rm -rf $1/app/PhotosOnline
rm -rf $1/app/Rftoolkit
rm -rf $1/app/oem_tcma
rm -rf $1/app/aptxals
rm -rf $1/app/LogKitSdService
rm -rf $1/app/OPBugReportLite
rm -rf $1/app/OPCommonLogTool
rm -rf $1/app/OPIntelliService
rm -rf $1/app/OPTelephonyDiagnoseManager
rm -rf $1/app/OemAutoTestServer
rm -rf $1/app/OpLogkit
rm -rf $1/app/SmscPlugger
rm -rf $1/app/OPInstantTranslation
rm -rf $1/app/Calendar
rm -rf $1/app/Exchange2
rm -rf $1/app/NFCTestMode
rm -rf $1/app/NxpNfcNci
rm -rf $1/app/NxpSecureElement
rm -rf $1/app/OPFindMyPhoneUtils
rm -rf $1/app/OposAds
rm -rf $1/app/QColor
rm -rf $1/app/SensorTestTool
rm -rf $1/app/SoterService
rm -rf $1/app/SoundRecorder
rm -rf $1/app/nearme
rm -rf $1/app/heytap_mcs_cn
rm -rf $1/app/WifiRfTestApk
rm -rf $1/app/baidushurufa
rm -rf $1/app/ARCore_stub
rm -rf $1/app/CompanionDeviceManager
rm -rf $1/app/aptxals
rm -rf $1/app/aptxui


# Nuke OnePlus useless priv-app apks
rm -rf $1/priv-app/OnePlusCamera
rm -rf $1/priv-app/OnePlusGallery
rm -rf $1/priv-app/Velvet
rm -rf $1/priv-app/CtsShimPrivPrebuilt
rm -rf $1/priv-app/HotwordEnrollmentXGoogleWCD9340
rm -rf $1/priv-app/HotwordEnrollmentOKGoogleWCD9340
rm -rf $1/priv-app/subsdm
rm -rf $1/priv-app/TSDM
rm -rf $1/priv-app/TagGoogle
rm -rf $1/priv-app/ONS
rm -rf $1/priv-app/LocalTransport
rm -rf $1/priv-app/Houston
rm -rf $1/priv-app/OPAppCategoryProvider
rm -rf $1/priv-app/OPDeviceManager
rm -rf $1/priv-app/OPDeviceManagerProvider
rm -rf $1/priv-app/AutoNaviNLP
rm -rf $1/priv-app/BlockedNumberProvider
rm -rf $1/priv-app/CallLogBackup
rm -rf $1/priv-app/EmergencyInfo
rm -rf $1/priv-app/FusedLocation
rm -rf $1/priv-app/IFAAService
rm -rf $1/priv-app/NearmeBrowser
rm -rf $1/priv-app/OPFindMyPhone
rm -rf $1/priv-app/OPMarket
rm -rf $1/priv-app/OPVoiceAssistant
rm -rf $1/priv-app/OPVoiceWakeUp
rm -rf $1/priv-app/Tag
rm -rf $1/priv-app/StatementService
rm -rf $1/priv-app/Wallet
rm -rf $1/priv-app/BuiltInPrintService
rm -rf $1/priv-app/RcsSDK
rm -rf $1/priv-app/Shell
rm -rf $1/priv-app/ProxyHandler


# Nuke OnePlus useless product/app apks
rm -rf $1/product/app/TmoEngMode
rm -rf $1/product/app/embms
rm -rf $1/product/app/ModuleMetadataGooglePrebuilt
rm -rf $1/product/app/colorservice
rm -rf $1/product/app/DeviceInfo
rm -rf $1/product/app/QdcmFF
rm -rf $1/product/app/talkback
rm -rf $1/product/app/Chrome
rm -rf $1/product/app/GoogleAssistant
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/app/Photos
rm -rf $1/product/app/WebViewGoogle
rm -rf $1/product/app/com.google.mainline.telemetry
rm -rf $1/product/app/Calculator
rm -rf $1/product/app/Drive
rm -rf $1/product/app/YTMusic
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/Duo
rm -rf $1/product/app/Maps
rm -rf $1/product/app/TrichromeLibrary
rm -rf $1/product/app/YouTube
rm -rf $1/product/app/Gmail2
rm -rf $1/product/app/GooglePay
rm -rf $1/product/app/Videos
rm -rf $1/product/app/com.google.android.modulemetadata
rm -rf $1/product/app/Music2

# Nuke OnePlus useless product/priv-app apks
rm -rf $1/product/priv-app/AndroidAutoStub
rm -rf $1/product/priv-app/GoogleFeedback
rm -rf $1/product/priv-app/LiveCaption
rm -rf $1/product/priv-app/QAS_DVC_MSP
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/HotwordEnrollmentXGoogleHEXAGON
rm -rf $1/product/priv-app/OobConfig
rm -rf $1/product/priv-app/Turbo
rm -rf $1/product/priv-app/HotwordEnrollmentOKGoogleHEXAGON

# Nuke OnePlus useless india/app apks
rm -rf $1/india/app/HeytapIdProvider
rm -rf $1/india/app/Nearme
rm -rf $1/india/app/OPMemberShip
rm -rf $1/india/app/OPSilentInstaller
rm -rf $1/india/app/heytap_mcs_in

# Nuke OnePlus useless india/priv-app apks
rm -rf $1/india/priv-app/CloudService
rm -rf $1/india/priv-app/IndiaOPRoamingServiceRelease
rm -rf $1/india/priv-app/OPWorkLifeBalance

# Nuke OnePlus useless india/reserve apks
rm -rf $1/india/reserve/EpicGameApp
rm -rf $1/india/reserve/IndiaOPRoamingAppRelease
rm -rf $1/india/reserve/OPNote
