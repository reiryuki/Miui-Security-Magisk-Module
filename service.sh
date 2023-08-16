MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`

# log
exec 2>$MODPATH/debug.log
set -x

# property
PROP=`getprop ro.product.device`
resetprop --delete ro.security.mod_device
#gresetprop ro.security.mod_device "$PROP"_global
resetprop ro.miui.ui.version.code 14

# wait
until [ "`getprop sys.boot_completed`" == "1" ]; do
  sleep 10
done

# settings
DES=system
NAME=status_bar_notification_style
SET=`settings get $DES $NAME`
VAL=1
if [ "$SET" == null ] || [ "$SET" == 0 ]; then
  settings put $DES $NAME $VAL
fi

# function
grant_permission() {
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
if [ "$API" -ge 29 ]; then
  pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION 2>/dev/null
  appops set $PKG ACCESS_MEDIA_LOCATION allow
fi
if [ "$API" -ge 33 ]; then
  pm grant $PKG android.permission.READ_MEDIA_AUDIO
  pm grant $PKG android.permission.READ_MEDIA_VIDEO
  pm grant $PKG android.permission.READ_MEDIA_IMAGES
  appops set $PKG ACCESS_RESTRICTED_SETTINGS allow
fi
appops set $PKG LEGACY_STORAGE allow
appops set $PKG READ_EXTERNAL_STORAGE allow
appops set $PKG WRITE_EXTERNAL_STORAGE allow
appops set $PKG READ_MEDIA_AUDIO allow
appops set $PKG READ_MEDIA_VIDEO allow
appops set $PKG READ_MEDIA_IMAGES allow
appops set $PKG WRITE_MEDIA_AUDIO allow
appops set $PKG WRITE_MEDIA_VIDEO allow
appops set $PKG WRITE_MEDIA_IMAGES allow
if [ "$API" -ge 30 ]; then
  appops set $PKG MANAGE_EXTERNAL_STORAGE allow
  appops set $PKG NO_ISOLATED_STORAGE allow
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
if [ "$API" -ge 31 ]; then
  appops set $PKG MANAGE_MEDIA allow
fi
PKGOPS=`appops get $PKG`
UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 userId= | sed 's|    userId=||g'`
if [ "$UID" -gt 9999 ]; then
  appops set --uid "$UID" LEGACY_STORAGE allow
  if [ "$API" -ge 29 ]; then
    appops set --uid "$UID" ACCESS_MEDIA_LOCATION allow
  fi
  UIDOPS=`appops get --uid "$UID"`
fi
}

# grant
PKG=com.miui.securitycenter
if [ "$API" -ge 33 ]; then
  pm grant $PKG android.permission.POST_NOTIFICATIONS
fi
pm grant $PKG android.permission.READ_PHONE_STATE
pm grant $PKG android.permission.ACCESS_FINE_LOCATION
pm grant $PKG android.permission.ACCESS_COARSE_LOCATION
pm grant $PKG android.permission.ACCESS_BACKGROUND_LOCATION
pm grant $PKG android.permission.CALL_PHONE
pm grant $PKG android.permission.READ_CONTACTS
pm grant $PKG android.permission.CAMERA
pm grant $PKG android.permission.READ_CALENDAR
pm grant $PKG android.permission.WRITE_CALENDAR
pm grant $PKG android.permission.READ_SMS
#pm grant $PKG android.permission.SEND_SMS
#pm grant $PKG android.permission.RECEIVE_SMS
pm grant $PKG android.permission.READ_CALL_LOG
pm grant $PKG android.permission.WRITE_CALL_LOG
appops set $PKG SYSTEM_ALERT_WINDOW allow
appops set $PKG GET_USAGE_STATS allow
appops set $PKG WRITE_SETTINGS allow
grant_permission
APP=SecurityCenter
NAME=android.permission.READ_CALL_LOG
NAME2=android.permission.READ_SMS
NAME3=android.permission.ACCESS_BACKGROUND_LOCATION
if ! dumpsys package $PKG | grep "$NAME: granted=true"\
|| ! dumpsys package $PKG | grep "$NAME2: granted=true"\
|| ! dumpsys package $PKG | grep "$NAME3: granted=true"; then
  FILE=`find $MODPATH/system -type f -name $APP.apk`
  if pm install -g -i com.android.vending $FILE; then
    pm uninstall -k $PKG
  fi
fi

# grant
PKG=com.miui.guardprovider
pm grant $PKG android.permission.READ_PHONE_STATE
pm grant $PKG android.permission.ACCESS_FINE_LOCATION
pm grant $PKG android.permission.ACCESS_COARSE_LOCATION
appops set $PKG WRITE_SETTINGS allow
grant_permission

# grant
PKG=com.miui.securityadd
#pm grant $PKG android.permission.RECEIVE_SMS
#pm grant $PKG android.permission.SEND_SMS
pm grant $PKG android.permission.READ_PHONE_STATE
pm grant $PKG android.permission.CAMERA
pm grant $PKG android.permission.GET_ACCOUNTS
appops set $PKG SYSTEM_ALERT_WINDOW allow
grant_permission

# grant
PKG=com.miui.cleanmaster
pm grant $PKG android.permission.ACCESS_COARSE_LOCATION
pm grant $PKG android.permission.READ_CALENDAR
pm grant $PKG android.permission.READ_PHONE_STATE
pm grant $PKG android.permission.ACCESS_FINE_LOCATION
pm grant $PKG android.permission.WRITE_CALENDAR
pm grant $PKG android.permission.RECORD_AUDIO
appops set $PKG GET_USAGE_STATS allow
grant_permission

# grant
PKG=com.lbe.security.miui
if pm list packages | grep $PKG; then
  pm grant $PKG android.permission.READ_PHONE_STATE
  pm grant $PKG android.permission.ACCESS_FINE_LOCATION
  pm grant $PKG android.permission.ACCESS_COARSE_LOCATION
  pm grant $PKG android.permission.ACCESS_BACKGROUND_LOCATION
  grant_permission
fi

# grant
PKG=com.miui.powerkeeper
if pm list packages | grep $PKG; then
  grant_permission
fi

# disable
FILE=$MODPATH/disabler.sh
if [ -f $FILE ]; then
  . $FILE
  mv -f $FILE $FILE.txt
fi











