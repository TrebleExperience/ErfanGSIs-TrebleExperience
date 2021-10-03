#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# Drop some google apps
rm -rf $1/product/app/Drive
rm -rf $1/product/app/Duo
rm -rf $1/product/app/Videos
rm -rf $1/product/app/YTMusic
rm -rf $1/product/priv-app/FilesGoogle
rm -rf $1/product/priv-app/GoogleDialer
rm -rf $1/product/priv-app/GoogleFeedback