export PATH=/vendor/bin

################################################################
# Usage:
# xxx-restart-counter-sh /vendor/bin/sh init.vivo.fingerprint_restart_counter.sh biometrics-fingerprint-xxx #max_restart_times

reboot_times=`getprop vendor.fingerprint.reboottimes`
if [ -z "$reboot_times" ]; then
    reboot_times=0
fi

# default max restart times is 5.
max_restart_times=5
if [ -n $2 ]; then
    max_restart_times=$2
fi

let "max_restart_times = max_restart_times + 0"

#hwbinder_pid=`ps -A | grep vendor.vivo.hardware.biometrics.fingerprint | awk '{ print $2 }'`
#hwbinder_pid=`pgrep -f vendor.vivo.hardware.biometrics.fingerprint@2.0-service-fs9501`
#setprop vendor.fingerprint.hwpid "$hwbinder_pid"

let "reboot_times++"
if [ $reboot_times -gt $max_restart_times ]; then
    # send SIGTERM signal before stop the service to let
    # process do some clean since it will be force
    # killed when stop
    #if [ -n "$hwbinder_pid" ]; then
    #    kill -s 15 $hwbinder_pid
    #    usleep 50000 #microseconds
    #fi

    # ctl property set in this shell need qti_init_shell
    # has "ctl_default_prop:property_service set" permission
    # in qcom platform.
    setprop ctl.stop $1
else
    setprop vendor.fingerprint.reboottimes "$reboot_times"
    #setprop ctl.start $1
fi
