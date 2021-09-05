#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Remove useless apks
rm -rf $1/app/Calculador
rm -rf $1/app/CompanionDeviceManager
rm -rf $1/app/CtsShimPrebuilt
rm -rf $1/app/Email
rm -rf $1/app/FidoAuthen
rm -rf $1/app/FidoClient
rm -rf $1/app/GooglePrintRecommendation
rm -rf $1/app/IFAAService
rm -rf $1/app/Joyose
rm -rf $1/app/Lens
rm -rf $1/app/MiDrive
rm -rf $1/app/MiRadio
rm -rf $1/app/MiuiBugReport
rm -rf $1/app/MiuiCompass
rm -rf $1/app/MiuiVideoGlobal
rm -rf $1/app/ModemLog
rm -rf $1/app/NextPay
rm -rf $1/app/Notes
rm -rf $1/app/PacProcessor
rm -rf $1/app/PaymentService
rm -rf $1/app/SensorTestTool
rm -rf $1/app/XMSFKeeper
rm -rf $1/app/XiaomiServiceFramework
rm -rf $1/app/XiaomiSimActivateService
rm -rf $1/app/cit
rm -rf $1/app/wps-lite # Seems useless.
rm -rf $1/priv-app/Calendar
rm -rf $1/priv-app/CtsShimPrivPrebuilt # Again?
rm -rf $1/priv-app/LocalTransport
rm -rf $1/priv-app/MiBrowserGlobal
rm -rf $1/priv-app/MiMover
rm -rf $1/priv-app/MiService
rm -rf $1/priv-app/MiuiCamera
rm -rf $1/priv-app/MiuiGallery
rm -rf $1/priv-app/MiuiScanner
rm -rf $1/priv-app/Music
rm -rf $1/priv-app/ONS
rm -rf $1/priv-app/SoundRecorder
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/priv-app/AndroidAutoStub
rm -rf $1/product/priv-app/CarrierServices
rm -rf $1/product/priv-app/Velvet
rm -rf $1/system_ext/app/QCC
rm -rf $1/system_ext/app/QTIDiagServices
rm -rf $1/system_ext/app/com.qualcomm.qti.services.systemhelper
rm -rf $1/system_ext/priv-app/GoogleFeedback
