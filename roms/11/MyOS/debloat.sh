#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Drop useless apks
rm -rf $1/app/DtsUltra
rm -rf $1/app/DualSta
rm -rf $1/app/EMode
rm -rf $1/app/LiveWallpaper_*
rm -rf $1/app/MusicPlayerMFV
rm -rf $1/app/Recorder_MFV
rm -rf $1/app/UmeBrowser
rm -rf $1/app/VideoPlayer_MFV
rm -rf $1/priv-app/AIEngine_MFV
rm -rf $1/priv-app/CameraBurn
rm -rf $1/priv-app/EasyMode_MFV
rm -rf $1/priv-app/Gallery_OCR_*
rm -rf $1/priv-app/GameModeAdapter_MFV
rm -rf $1/priv-app/GooglePlayServicesUpdater # Again, why CN version has shits like that?
rm -rf $1/priv-app/HaloBaseApp_Baidu
rm -rf $1/priv-app/IntelliText_MFV
rm -rf $1/priv-app/KidsZoneAdapter_MFV
rm -rf $1/priv-app/MiBoard
rm -rf $1/priv-app/NfcAccess_MFV
rm -rf $1/priv-app/PhotoEditor_MFV
rm -rf $1/priv-app/Search_MFV
rm -rf $1/priv-app/SmartCast_MFV
rm -rf $1/priv-app/VideoEditor_MFV
rm -rf $1/priv-app/ZTE_Camera
rm -rf $1/priv-app/quickrt
rm -rf $1/priv-app/zteshare
rm -rf $1/product/app/Alarming_MFV
rm -rf $1/product/app/Calendar_MFV
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/priv-app/ConfigUpdater
rm -rf $1/system_ext/priv-app/xtra_t_app

# Drop MyOS shits.
rm -rf $1/partner-app/*