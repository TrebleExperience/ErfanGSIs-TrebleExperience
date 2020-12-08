export PATH=/vendor/bin

if [ -f /sys/fp_id/fp_id ]; then
    fp_module=`cat /sys/fp_id/fp_id` 2> /dev/null
    setprop vendor.fingerprint.boot "$fp_module"
fi
