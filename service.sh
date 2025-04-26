MODPATH=${0%/*}

# log
exec 2>$MODPATH/debug.log
set -x

# var
API=`getprop ro.build.version.sdk`

# property
PROP=`getprop ro.product.device`
resetprop --delete ro.security.mod_device
#resetprop ro.security.mod_device "$PROP"_global
#resetprop -n log.tag.autodensity.debug.enable 1
resetprop -n ro.vendor.fps.switch.default true
resetprop -n ro.vendor.audio.dpaudio true
resetprop -n ro.vendor.audio.game.mode true
resetprop -n ro.vendor.audio.game.effect true
resetprop -n ro.vendor.audio.game.vibrate true
resetprop -n ro.vendor.audio.voice.change.support true
resetprop -n ro.vendor.audio.voice.change.version 2
resetprop -n ro.vendor.audio.voice.change.youme.support true
resetprop -n ro.vendor.audio.videobox.switch true
resetprop -n ro.vendor.video_box.version 2
resetprop -n ro.vendor.video.style.by.layer.support true
resetprop -n ro.vendor.media.video.frc.support true
resetprop -n ro.vendor.media.video.vpp.support true
resetprop -n ro.vendor.media.video.style.support true
resetprop -n ro.vendor.display.dynamic_refresh_rate true
resetprop -n ro.vendor.gcp.enable true
PROP=ro.vendor.touchfeature.type
if [ ! "`getprop $PROP`" ]; then
  resetprop -n $PROP 43
fi

# wait
until [ "`getprop sys.boot_completed`" == 1 ]; do
  sleep 10
done

# list
PKGS="`cat $MODPATH/package.txt`
       com.miui.cleanmaster:micleansdk
       com.miui.securitycenter.remote
       com.miui.securitycenter.bootaware
       com.miui.securitycenter:ui
       com.miui.securityadd.home"
for PKG in $PKGS; do
  magisk --denylist rm $PKG 2>/dev/null
  magisk --sulist add $PKG 2>/dev/null
done
if magisk magiskhide sulist; then
  for PKG in $PKGS; do
    magisk magiskhide add $PKG
  done
else
  for PKG in $PKGS; do
    magisk magiskhide rm $PKG
  done
fi

# settings
DES=system
NAME=status_bar_notification_style
SET=`settings get $DES $NAME`
VAL=1
if [ "$SET" == null ] || [ "$SET" == 0 ]; then
  settings put $DES $NAME $VAL
fi

# function
appops_set() {
appops set $PKG LEGACY_STORAGE allow
appops set $PKG READ_EXTERNAL_STORAGE allow
appops set $PKG WRITE_EXTERNAL_STORAGE allow
appops set $PKG READ_MEDIA_AUDIO allow
appops set $PKG READ_MEDIA_VIDEO allow
appops set $PKG READ_MEDIA_IMAGES allow
appops set $PKG WRITE_MEDIA_AUDIO allow
appops set $PKG WRITE_MEDIA_VIDEO allow
appops set $PKG WRITE_MEDIA_IMAGES allow
if [ "$API" -ge 29 ]; then
  appops set $PKG ACCESS_MEDIA_LOCATION allow
fi
if [ "$API" -ge 30 ]; then
  appops set $PKG MANAGE_EXTERNAL_STORAGE allow
  appops set $PKG NO_ISOLATED_STORAGE allow
  appops set $PKG AUTO_REVOKE_PERMISSIONS_IF_UNUSED ignore
fi
if [ "$API" -ge 31 ]; then
  appops set $PKG MANAGE_MEDIA allow
fi
if [ "$API" -ge 33 ]; then
  appops set $PKG ACCESS_RESTRICTED_SETTINGS allow
fi
if [ "$API" -ge 34 ]; then
  appops set $PKG READ_MEDIA_VISUAL_USER_SELECTED allow
fi
PKGOPS=`appops get $PKG`
UID=`dumpsys package $PKG 2>/dev/null | grep -m 1 Id= | sed -e 's|    userId=||g' -e 's|    appId=||g'`
if [ "$UID" ] && [ "$UID" -gt 9999 ]; then
  appops set --uid "$UID" LEGACY_STORAGE allow
  appops set --uid "$UID" READ_EXTERNAL_STORAGE allow
  appops set --uid "$UID" WRITE_EXTERNAL_STORAGE allow
  if [ "$API" -ge 29 ]; then
    appops set --uid "$UID" ACCESS_MEDIA_LOCATION allow
  fi
  if [ "$API" -ge 34 ]; then
    appops set --uid "$UID" READ_MEDIA_VISUAL_USER_SELECTED allow
  fi
  UIDOPS=`appops get --uid "$UID"`
fi
}

# grant
PKG=com.miui.securitycenter
if appops get $PKG > /dev/null 2>&1; then
  pm grant --all-permissions $PKG
  appops set $PKG SYSTEM_ALERT_WINDOW allow
  appops set $PKG GET_USAGE_STATS allow
  appops set $PKG WRITE_SETTINGS allow
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
  appops_set
fi

# grant
PKG=com.miui.guardprovider
if appops get $PKG > /dev/null 2>&1; then
  pm grant --all-permissions $PKG
  appops set $PKG WRITE_SETTINGS allow
  appops_set
fi

# grant
PKG=com.miui.securityadd
if appops get $PKG > /dev/null 2>&1; then
  pm grant --all-permissions $PKG
  appops set $PKG SYSTEM_ALERT_WINDOW allow
  appops_set
fi

# grant
PKG=com.miui.cleanmaster
if appops get $PKG > /dev/null 2>&1; then
  pm grant --all-permissions $PKG
  appops set $PKG GET_USAGE_STATS allow
  appops_set
fi











