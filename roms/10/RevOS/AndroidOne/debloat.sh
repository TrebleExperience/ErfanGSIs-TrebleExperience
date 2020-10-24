#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

rm -rf $1/app/MiFmRadio
rm -rf $1/app/MiuiBugReport

rm -rf $1/priv-app/MiuiCamera
