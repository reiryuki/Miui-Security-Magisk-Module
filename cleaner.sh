MODPATH=${0%/*}
APP="`ls $MODPATH/system/priv-app`
     `ls $MODPATH/system/app`
     SystemUI TeleService"
for APPS in $APP; do
  rm -f `find /data/system/package_cache -type f -name *$APPS*`
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
PKG="`cat $MODPATH/package.txt`
     com.android.systemui
     com.android.phone"
for PKGS in $PKG; do
  rm -rf /data/user*/*/$PKGS/cache/*
done


