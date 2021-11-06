#!/bin/bash

# Fix ringtone issue.
echo "# Fix ringtone issue
ro.config.mms_notification=Free.ogg
ro.config.notification_sms=Free.ogg
ro.config.notification_sim2=Free.ogg
ro.config.notification_sound=Meet.ogg
ro.config.alarm_alert=Spring.ogg
ro.config.ringtone=OnePlus_tune.ogg
ro.config.ringtone_sim2=OnePlus_tune.ogg
ro.config.calendar_sound=Cozy.ogg
" >> $1/build.prop
