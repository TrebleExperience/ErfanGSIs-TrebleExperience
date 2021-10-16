#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

rm -rf $1/app/QAS_DVC_MSP_VZW
rm -rf $1/app/VZWAPNLib
rm -rf $1/app/datastatusnotification
rm -rf $1/app/ims
rm -rf $1/app/vzw_msdc_api
rm -rf $1/etc/permissions/com.google.android.camera.experimental2017.xml
rm -rf $1/priv-app/CNEService
rm -rf $1/priv-app/DMService
rm -rf $1/priv-app/VzwOmaTrigger
rm -rf $1/priv-app/qcrilmsgtunnel
rm -rf $1/product/app/GoogleCamera
rm -rf $1/product/app/OemDmTrigger
rm -rf $1/product/app/VZWAPNLib
rm -rf $1/product/app/WallpapersBReel*
rm -rf $1/product/overlay/PixelDocumentsUIOverlay
rm -rf $1/product/priv-app/BetaFeedback
rm -rf $1/product/priv-app/ConnMO
rm -rf $1/product/priv-app/DCMO
rm -rf $1/product/priv-app/DevicePersonalizationPrebuiltPixel2020
rm -rf $1/product/priv-app/HelpRtcPrebuilt
rm -rf $1/product/priv-app/MyVerizonServices
rm -rf $1/product/priv-app/OTAConfigPrebuilt
rm -rf $1/product/priv-app/PrebuiltGmsCore/app_chimera
rm -rf $1/product/priv-app/PrebuiltGmsCoreQt/app_chimera
rm -rf $1/product/priv-app/Showcase
rm -rf $1/product/priv-app/SprintDM
rm -rf $1/product/priv-app/SprintDM
rm -rf $1/product/priv-app/SprintHM
rm -rf $1/product/priv-app/SprintHM
rm -rf $1/product/priv-app/WfcActivation
rm -rf $1/product_services/priv-app/PrebuiltGmsCorePi/app_chimera
rm -rf $1/system_ext/priv-app/MyVerizonServices
rm -rf $1/system_ext/priv-app/OBDM_Permissions
rm -rf $1/system_ext/priv-app/obdm_stub