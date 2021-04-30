#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

cp -fpr $thispath/overlay/* $1/product/overlay/
