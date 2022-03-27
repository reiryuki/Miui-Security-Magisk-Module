(

MODPATH=${0%/*}
API=`getprop ro.build.version.sdk`

# debug
exec 2>$MODPATH/debug.log
set -x

# property
resetprop --delete ro.product.mod_device
#resetprop ro.product.miname cepheus

# wait
sleep 60

# function
grant_permission() {
UID=`pm list packages -U | grep $PKG | sed -n -e "s/package:$PKG uid://p"`
pm grant $PKG android.permission.READ_EXTERNAL_STORAGE
pm grant $PKG android.permission.WRITE_EXTERNAL_STORAGE
pm grant $PKG android.permission.ACCESS_MEDIA_LOCATION
appops set --uid $UID LEGACY_STORAGE allow
appops set $PKG READ_EXTERNAL_STORAGE allow
appops set $PKG WRITE_EXTERNAL_STORAGE allow
appops set $PKG ACCESS_MEDIA_LOCATION allow
appops set $PKG READ_MEDIA_AUDIO allow
appops set $PKG READ_MEDIA_VIDEO allow
appops set $PKG READ_MEDIA_IMAGES allow
appops set $PKG WRITE_MEDIA_AUDIO allow
appops set $PKG WRITE_MEDIA_VIDEO allow
appops set $PKG WRITE_MEDIA_IMAGES allow
if [ "$API" -gt 29 ]; then
  appops set $PKG MANAGE_EXTERNAL_STORAGE allow
  appops set $PKG NO_ISOLATED_STORAGE allow
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
}

# grant
PKG=com.miui.securitycenter
pm grant $PKG android.permission.READ_PHONE_STATE
pm grant $PKG android.permission.ACCESS_COARSE_LOCATION
pm grant $PKG android.permission.CALL_PHONE
pm grant $PKG android.permission.READ_CONTACTS
pm grant $PKG android.permission.CAMERA
pm grant $PKG android.permission.READ_CALENDAR
pm grant $PKG android.permission.WRITE_CALENDAR
#pm grant $PKG android.permission.READ_SMS
#pm grant $PKG android.permission.SEND_SMS
#pm grant $PKG android.permission.RECEIVE_SMS
pm grant $PKG android.permission.READ_CALL_LOG
pm grant $PKG android.permission.WRITE_CALL_LOG
appops set $PKG SYSTEM_ALERT_WINDOW allow
appops set $PKG GET_USAGE_STATS allow
grant_permission

# grant
PKG=com.miui.guardprovider
pm grant $PKG android.permission.READ_PHONE_STATE
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
if pm list packages | grep -Eq $PKG; then
  pm grant $PKG android.permission.READ_PHONE_STATE
  pm grant $PKG android.permission.ACCESS_FINE_LOCATION
  pm grant $PKG android.permission.ACCESS_COARSE_LOCATION
  pm grant $PKG android.permission.ACCESS_BACKGROUND_LOCATION
  grant_permission
fi

# grant
PKG=com.miui.android.settings
if pm list packages | grep -Eq $PKG; then
  pm grant $PKG android.permission.ACCESS_FINE_LOCATION
  pm grant $PKG android.permission.ACCESS_COARSE_LOCATION
  pm grant $PKG android.permission.READ_PHONE_STATE
  pm grant $PKG android.permission.CALL_PHONE
  pm grant $PKG android.permission.CAMERA
  grant_permission
fi

# grant
PKG=com.miui.powerkeeper
if pm list packages | grep -Eq $PKG; then
  grant_permission
fi

# disable
FILE=$MODPATH/disabler.sh
if [ -f $FILE ]; then
  sh $FILE
  mv -f $FILE $FILE.txt
fi

) 2>/dev/null


