MODPATH=${0%/*}
APP="`ls $MODPATH/system/priv-app`
     `ls $MODPATH/system/app`
     SystemUI TeleService"
for APPS in $APP; do
  rm -f `find /data/system/package_cache -type f -name *$APPS*`
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
PKG="com.miui.securitycenter
     com.miui.cleanmaster
     com.miui.securityadd
     com.lbe.security.miui
     com.miui.powerkeeper
     com.miui.guardprovider
     com.android.systemui
     com.android.phone"
for PKGS in $PKG; do
  rm -rf /data/user/*/$PKGS/cache/*
done


