#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# bloats basic
rm -rf $1/preinstall/*

# Product
rm -rf $1/product/app/CalculatorGoogle
rm -rf $1/product/app/CalendarGoogle
rm -rf $1/product/app/Drive
rm -rf $1/product/app/Duo
rm -rf $1/product/app/Gmail2
rm -rf $1/product/app/Maps
rm -rf $1/product/app/Youtube
rm -rf $1/product/priv-app/Turbo
rm -rf $1/product/priv-app/Velvet
rm -rf $1/product/priv-app/Wellbeing

# priv-app
rm -rf $1/priv-app/facebook-installer/
rm -rf $1/priv-app/facebook-services/
