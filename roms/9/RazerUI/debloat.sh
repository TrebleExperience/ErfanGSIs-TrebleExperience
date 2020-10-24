  
#!/bin/bash

systempath=$1
thispath=`cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd`

rm -rf $1/app/CalendarGoogle
rm -rf $1/app/Drive
rm -rf $1/app/Duo
rm -rf $1/app/Gmail2
rm -rf $1/app/Maps
rm -rf $1/app/Music2
rm -rf $1/app/Photos
rm -rf $1/app/Videos
rm -rf $1/app/YouTube

rm -rf $1/priv-app/RazerChroma


# Drop razercam as it doesn't work properly
rm -rf $1/priv-app/RazerCamera
