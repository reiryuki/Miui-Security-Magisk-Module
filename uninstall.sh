(

mount /data
mount -o rw,remount /data
MODPATH=${0%/*}
MODID=`echo "$MODPATH" | sed -n -e 's/\/data\/adb\/modules\///p'`
APP="`ls $MODPATH/system/priv-app` `ls $MODPATH/system/app`"
PKG="com.miui.securitycenter
     com.miui.cleanmaster
     com.miui.securityadd
     com.miui.powerkeeper
     com.miui.guardprovider
     com.miui.android.settings"
     #com.lbe.security.miui
ADD="SystemUI TeleService"
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS
done
for APPS in $APP; do
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
for ADDS in $ADD; do
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$ADDS*.apk`
done
rm -rf /metadata/magisk/"$MODID"
rm -rf /mnt/vendor/persist/magisk/"$MODID"
rm -rf /persist/magisk/"$MODID"
rm -rf /data/unencrypted/magisk/"$MODID"
rm -rf /cache/magisk/"$MODID"

) 2>/dev/null

