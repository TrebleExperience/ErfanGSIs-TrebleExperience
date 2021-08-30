#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Drop useless apks
rm -rf $1/app/AutoAgingTest
rm -rf $1/app/DTSXULTRA
rm -rf $1/app/FactoryTestAdvanced
rm -rf $1/app/GoodixTest
rm -rf $1/app/NBVirtualGameHandle
rm -rf $1/app/NubiaFastPair
rm -rf $1/app/Stk
rm -rf $1/app/SystemUpdate_v1.1
rm -rf $1/app/TP_YulorePage_v1.0.0
rm -rf $1/app/ZNubiaEdge
rm -rf $1/app/nubia_Browser
rm -rf $1/app/nubia_Calendar_v1.0
rm -rf $1/app/nubia_DeskClock_NX*
rm -rf $1/app/nubia_DynamicWallpaper_651
rm -rf $1/app/nubia_GameHelperModule
rm -rf $1/app/nubia_GameHighlights
rm -rf $1/app/nubia_GameLauncher
rm -rf $1/app/nubia_NeoHybrid
rm -rf $1/app/nubia_PhoneManualIntegrate
rm -rf $1/app/nubia_neoPay
rm -rf $1/priv-app/AOD_v*.*_*-release
rm -rf $1/priv-app/Camera
rm -rf $1/priv-app/NBGalleryLockScreen
rm -rf $1/priv-app/NubiaGallery
rm -rf $1/priv-app/NubiaVideo
rm -rf $1/priv-app/PhotoEditor
rm -rf $1/priv-app/ZQuickSearchBox
rm -rf $1/priv-app/nubia_HaloVoice
rm -rf $1/priv-app/nubia_touping

# Since we've dropped AOD, time to drop AOD themes
rm -rf $1/system_ext/media/Settings/aod

# Drop some themes to save space
rm -rf $1/system_ext/media/theme/thememanager/default_king_of_glory
rm -rf $1/system_ext/media/theme/thememanager/default_white_mech

# W-what?!
rm -rf $1/product/priv-app/ConfigUpdater
rm -rf $1/product/priv-app/GooglePlayServicesUpdater

# Drop QCC (Always crashing)
rm -rf $1/system_ext/app/QCC/

# Drop chinese/nubia shits.
rm -rf $1/preset_apps/*