#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Delete recovery cache
rm -rf $1/recovery-from-boot.p

# Delete some apps
rm -rf $1/app/AppCenterIntl
rm -rf $1/app/Camera
rm -rf $1/app/IntlNews
rm -rf $1/app/NotePaper
rm -rf $1/priv-app/Browser
rm -rf $1/priv-app/Music
rm -rf $1/priv-app/Search
rm -rf $1/priv-app/FlymeDialer
rm -rf $1/priv-app/FlymeLab
rm -rf $1/priv-app/FlymeMusic
rm -rf $1/priv-app/FlymeGallery
rm -rf $1/priv-app/FlymeSoundRecorder
rm -rf $1/priv-app/Video

# Delete APKs from MzApp
rm -rf $1/MzApp/Calculator
rm -rf $1/MzApp/Email
rm -rf $1/MzApp/FlymeCalendar
rm -rf $1/MzApp/GoogleCalendarSyncAdapter
rm -rf $1/MzApp/Game*
rm -rf $1/MzApp/Life
rm -rf $1/MzApp/MzStore
rm -rf $1/MzApp/Reader
rm -rf $1/MzApp/ToolBox
rm -rf $1/MzApp/Weather

# Delete MzUpdate
rm -rf $1/app/MzUpdate

# Delete some google apps (aka GApps)
rm -rf $1/system_ext/priv-app/GoogleOneTimeInitializer
rm -rf $1/system_ext/priv-app/GoogleServicesFramework

# Delete qcril
rm -rf $1/system_ext/priv-app/qcrilmsgtunnel
