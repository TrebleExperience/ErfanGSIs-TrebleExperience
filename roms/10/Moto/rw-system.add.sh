if [ "$vndk" -ge 28 ]; then
    mount -o bind /system/bin/wpa_supplicant /vendor/bin/hw/wpa_supplicant || true
fi
