#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# FB Shits
rm -rf $1/app/Facebook*
rm -rf $1/priv-app/Facebook*

# Instagram
rm -rf $1/app/Instagram

# YT Music
rm -rf $1/app/YTMusic

# Yandex
rm -rf $1/priv-app/Yandex*

# Product
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/Drive
rm -rf $1/product/app/Duo
rm -rf $1/product/app/Gmail2
rm -rf $1/product/app/GoogleTTS
rm -rf $1/product/app/Maps
rm -rf $1/product/app/Youtube
rm -rf $1/product/priv-app/Turbo
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/Wellbeing
