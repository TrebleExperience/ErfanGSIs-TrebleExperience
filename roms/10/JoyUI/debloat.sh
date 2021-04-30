#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

rm -rf $1/presetapp/*-timestamp
rm -rf $1/presetapp/AfterSaleService
rm -rf $1/presetapp/BSForum
rm -rf $1/presetapp/BSMall
# rm -rf $1/presetapp/Calculator
rm -rf $1/presetapp/Discovery
rm -rf $1/presetapp/h5_gamehall
rm -rf $1/presetapp/migamecenter
rm -rf $1/presetapp/mi_mall
rm -rf $1/presetapp/MiuiCompass
rm -rf $1/presetapp/MiuiEmail
rm -rf $1/presetapp/miweather
rm -rf $1/presetapp/xpbrowser
rm -rf $1/presetapp/Zs3DNotepad
rm -rf $1/priv-app/mibrowser
rm -rf $1/priv-app/MiuiSuperMarket
rm -rf $1/priv-app/MsgTransfer
rm -rf $1/priv-app/MiuiCamera
rm -rf $1/priv-app/ZsRecorder
rm -rf $1/priv-app/Cloneit
rm -rf $1/priv-app/MiuiVideo
rm -rf $1/app/ScreenRecorder
rm -rf $1/app/baiduime
