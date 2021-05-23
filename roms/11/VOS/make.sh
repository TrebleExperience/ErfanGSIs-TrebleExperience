#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

# drop VinServiceApp (disable system warning)
rm -rf $1/priv-app/VinServiceApp
rm -rf $1/priv-app/VDefense
