#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# my_product
rm -rf $1/../my_product/decouping_wallpaper/common/* # Drop common walls

# my_region
rm -rf $1/../my_region/app/Browser
rm -rf $1/../my_region/app/KeKePay
rm -rf $1/../my_region/app/OcrScanner
rm -rf $1/../my_region/app/OcrService
rm -rf $1/../my_region/del-app/*
rm -rf $1/../my_region/priv-app/KeKeThemeSpace

# my_preload
rm -rf $1/../my_preload/app/GoogleContacts
rm -rf $1/../my_preload/app/GooglePayIndia
rm -rf $1/../my_preload/app/Google_Lens_app
rm -rf $1/../my_preload/app/Messages
rm -rf $1/../my_preload/app/Photos_app
rm -rf $1/../my_preload/app/facebook-*
rm -rf $1/../my_preload/del-app/Drive
rm -rf $1/../my_preload/del-app/Duo
rm -rf $1/../my_preload/del-app/Facebook
rm -rf $1/../my_preload/del-app/GoogleNews
rm -rf $1/../my_preload/del-app/GoogleOne
rm -rf $1/../my_preload/del-app/Podcasts
rm -rf $1/../my_preload/del-app/Videos
rm -rf $1/../my_preload/del-app/YTMusic
rm -rf $1/../my_preload/del-app/realme_Link_exp
rm -rf $1/../my_preload/priv-app/GoogleDialer
rm -rf $1/../my_preload/priv-app/facebook-*

# my_heytap
rm -rf $1/../my_heytap/app/ARCore_stub
rm -rf $1/../my_heytap/app/CalendarGoogle
rm -rf $1/../my_heytap/app/Chrome
rm -rf $1/../my_heytap/app/Gmail2
rm -rf $1/../my_heytap/app/GoogleTTS
rm -rf $1/../my_heytap/app/Keep
rm -rf $1/../my_heytap/app/Maps
rm -rf $1/../my_heytap/app/YouTube
rm -rf $1/../my_heytap/app/talkback
rm -rf $1/../my_heytap/priv-app/AndroidAutoStub
rm -rf $1/../my_heytap/priv-app/Velvet
rm -rf $1/../my_heytap/priv-app/Wellbeing

# my_stock
rm -rf $1/../my_stock/app/KeKePay
rm -rf $1/../my_stock/app/KeKePay
rm -rf $1/../my_stock/app/Music
rm -rf $1/../my_stock/app/OppoWeather2
rm -rf $1/../my_stock/app/SecurePay
rm -rf $1/../my_stock/app/WellbeingAssistant
rm -rf $1/../my_stock/del-app/OppoVideoEditor
rm -rf $1/../my_stock/priv-app/Contacts
rm -rf $1/../my_stock/priv-app/KeKeUserCenter
rm -rf $1/../my_stock/priv-app/Mms
rm -rf $1/../my_stock/priv-app/OppoBootReg
rm -rf $1/../my_stock/priv-app/OppoGallery2
rm -rf $1/../my_stock/priv-app/SOSHelper
rm -rf $1/../my_stock/priv-app/VideoGallery