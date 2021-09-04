#!/system/bin/sh
while true
do

rm -f /data/system/storage.xml
touch /data/system/storage.xml
chattr +i /data/system/storage.xml
sleep 1

done
