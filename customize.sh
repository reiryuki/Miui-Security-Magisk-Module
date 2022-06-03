ui_print " "

# boot mode
if [ "$BOOTMODE" != true ]; then
  abort "- Please flash via Magisk Manager only!"
fi

# magisk
if [ -d /sbin/.magisk ]; then
  MAGISKTMP=/sbin/.magisk
else
  MAGISKTMP=`find /dev -mindepth 2 -maxdepth 2 -type d -name .magisk`
fi

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
ui_print " MagiskVersion=$MAGISK_VER"
ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
ui_print " "

# bit
if [ "$IS64BIT" != true ]; then
  ui_print "- 32 bit"
  rm -rf `find $MODPATH/system -type d -name *64`
else
  ui_print "- 64 bit"
fi
ui_print " "

# sdk
NUM=21
if [ "$API" -lt $NUM ]; then
  ui_print "! Unsupported SDK $API."
  ui_print "  You have to upgrade your Android version"
  ui_print "  at least SDK API $NUM to use this module."
  abort
else
  ui_print "- SDK $API"
  ui_print " "
fi

# sepolicy.rule
if [ "$BOOTMODE" != true ]; then
  mount -o rw -t auto /dev/block/bootdevice/by-name/persist /persist
  mount -o rw -t auto /dev/block/bootdevice/by-name/metadata /metadata
fi
FILE=$MODPATH/sepolicy.sh
DES=$MODPATH/sepolicy.rule
if [ -f $FILE ] && ! getprop | grep -Eq "sepolicy.sh\]: \[1"; then
  mv -f $FILE $DES
  sed -i 's/magiskpolicy --live "//g' $DES
  sed -i 's/"//g' $DES
fi

# miuicore
if [ ! -d /data/adb/modules_update/MiuiCore ] && [ ! -d /data/adb/modules/MiuiCore ]; then
  ui_print "! Miui Core Magisk Module is not installed."
  ui_print "  Please read github installation guide!"
  abort
else
  rm -f /data/adb/modules/MiuiCore/remove
  rm -f /data/adb/modules/MiuiCore/disable
fi

# miuisettingsmod
if [ ! -d /data/adb/modules_update/MiuiSettingsMod ] && [ ! -d /data/adb/modules/MiuiSettingsMod ]; then
  ui_print "! Miui Settings Mod Magisk Module is not installed."
  ui_print "  Please read github installation guide!"
  abort
else
  rm -f /data/adb/modules/MiuiSettingsMod/remove
  rm -f /data/adb/modules/MiuiSettingsMod/disable
fi

# function
test_signature() {
APP=SecurityCenter
PKG=com.miui.securitycenter
FILE=`find $MODPATH/system -type f -name $APP.apk`
ui_print "- Installing $APP.apk"
ui_print "  and granting all runtime permissions..."
RES=`pm install -g -i com.android.vending $FILE`
if [ "$RES" ]; then
  ui_print "  $RES"
fi
if [ "$RES" == Success ]; then
  RES=`pm uninstall -k $PKG`
elif [ -d /data/adb/modules_update/luckypatcher ] || [ -d /data/adb/modules/luckypatcher ]; then
  ui_print "  Enabling Patches to Android Lucky Patcher Module..."
  rm -f /data/adb/modules/luckypatcher/remove
  rm -f /data/adb/modules/luckypatcher/disable
  LUCKYPATCHER=true
elif echo "$RES" | grep -Eq INSTALL_FAILED_SHARED_USER_INCOMPATIBLE; then
  ui_print "  Signature test is failed"
  ui_print "  But installation is allowed for this case"
  ui_print "  Make sure you have deactivated your Android Signature"
  ui_print "  Verification or the app cannot be installed correctly."
  ui_print "  If you don't know what it is, please READ #troubleshootings."
elif echo "$RES" | grep -Eq INSTALL_FAILED_INSUFFICIENT_STORAGE; then
  ui_print "  Please free-up your internal storage first."
  abort
else
  ui_print "  ! Signature test is failed"
  ui_print "    You need to disable Signature Verification of your"
  ui_print "    Android first to use this module. READ #troubleshootings!"
  ui_print "    Or maybe just insufficient storage."
  abort
fi
ui_print " "
}

# test
test_signature
if [ "$LUCKYPATCHER" != true ]; then
  if [ -d /data/adb/modules_update/luckypatcher ] || [ -d /data/adb/modules/luckypatcher ]; then
    ui_print "- Enabling Patches to Android Lucky Patcher Module..."
    rm -f /data/adb/modules/luckypatcher/remove
    rm -f /data/adb/modules/luckypatcher/disable
    ui_print " "
  else
    rm -f $MODPATH/disabler.sh
  fi
fi

# global
FILE=$MODPATH/service.sh
if getprop | grep -Eq "miui.global\]: \[1"; then
  ui_print "- Global mode"
  sed -i 's/#g//g' $FILE
  ui_print "  Do not change the Home page orientation to landscape"
  ui_print "  mode in Game Booster settings!"
  ui_print " "
fi

# code
FILE=$MODPATH/service.sh
NAME=ro.miui.ui.version.code
if getprop | grep -Eq "miui.code\]: \[0"; then
  ui_print "- Removing $NAME..."
  sed -i "s/resetprop $NAME/#resetprop $NAME/g" $FILE
  ui_print "  Some features will be missing."
  ui_print " "
fi

# cleaning
ui_print "- Cleaning..."
APP="`ls $MODPATH/system/priv-app` `ls $MODPATH/system/app`"
PKG="com.miui.securitycenter
     com.miui.cleanmaster
     com.miui.securityadd
     com.miui.powerkeeper
     com.miui.guardprovider"
     #com.lbe.security.miui
ADD="SystemUI TeleService"
if [ "$BOOTMODE" == true ]; then
  for PKGS in $PKG; do
    RES=`pm uninstall $PKGS`
  done
fi
for APPS in $APP; do
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$APPS*.apk`
done
for ADDS in $ADD; do
  rm -f `find /data/dalvik-cache /data/resource-cache -type f -name *$ADDS*.apk`
done
rm -rf /metadata/magisk/$MODID
rm -rf /mnt/vendor/persist/magisk/$MODID
rm -rf /persist/magisk/$MODID
rm -rf /data/unencrypted/magisk/$MODID
rm -rf /cache/magisk/$MODID
ui_print " "

# power save
PROP=`getprop power.save`
FILE=$MODPATH/system/etc/sysconfig/*
if [ "$PROP" == 1 ]; then
  ui_print "- $MODNAME will not be allowed in power save."
  ui_print "  It may save your battery but decreasing $MODNAME performance."
  for PKGS in $PKG; do
    sed -i "s/<allow-in-power-save package=\"$PKGS\"\/>//g" $FILE
    sed -i "s/<allow-in-power-save package=\"$PKGS\" \/>//g" $FILE
  done
  ui_print " "
fi

# function
permissive() {
SELINUX=`getenforce`
if [ "$SELINUX" == Enforcing ]; then
  setenforce 0
  SELINUX=`getenforce`
  if [ "$SELINUX" == Enforcing ]; then
    ui_print "  ! Your device can't be turned to Permissive state."
  fi
  setenforce 1
fi
sed -i '1i\
SELINUX=`getenforce`\
if [ "$SELINUX" == Enforcing ]; then\
  setenforce 0\
fi\' $MODPATH/post-fs-data.sh
}

# permissive
if getprop | grep -Eq "permissive.mode\]: \[1"; then
  ui_print "- Using permissive method"
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
elif getprop | grep -Eq "permissive.mode\]: \[2"; then
  ui_print "- Using both permissive and SE policy patch"
  permissive
  ui_print " "
fi

# function
extract_lib() {
for APPS in $APP; do
  ui_print "- Extracting..."
  FILE=`find $MODPATH/system -type f -name $APPS.apk`
  DIR=`find $MODPATH/system -type d -name $APPS`/lib/$ARCH
  mkdir -p $DIR
  rm -rf $TMPDIR/*
  unzip -d $TMPDIR -o $FILE $DES
  cp -f $TMPDIR/$DES $DIR
  ui_print " "
done
}

# extract
PROP=`getprop ro.product.cpu.abi`
DES=lib/$PROP/*
extract_lib

# function
hide_oat() {
for APPS in $APP; do
  mkdir -p `find $MODPATH/system -type d -name $APPS`/oat
  touch `find $MODPATH/system -type d -name $APPS`/oat/.replace
done
}

# hide
hide_oat

# features
PROP=`getprop miui.features`
FILE=$MODPATH/system.prop
FILE2=$MODPATH/service.sh
if [ "$PROP" == 0 ]; then
  ui_print "- Removing ro.product.name changes..."
  sed -i 's/ro.product.name=cepheus//g' $FILE
  sed -i 's/resetprop ro.product.miname cepheus//g' $FILE2
  ui_print " "
elif [ "$PROP" ] && [ "$PROP" != 1 ]; then
  ui_print "- Your ro.product.name will be changed to $PROP"
  sed -i "s/cepheus/$PROP/g" $FILE
  sed -i "s/cepheus/$PROP/g" $FILE2
  ui_print " "
else
  ui_print "- Your ro.product.name will be changed to cepheus"
  ui_print " "
fi

# function
patch_file() {
ui_print "- Patching"
ui_print "  $FILE"
ui_print "  changing $PROP"
ui_print "  to $MODPROP"
ui_print "  Please wait..."
sed -i "s/$PROP/$MODPROP/g" $FILE
ui_print " "
}

# patch
#FILE=`find $MODPATH/system -type f -name libavlm.so`
#if [ "$PROP" != 0 ]; then
#  PROP=ro.product.device
#  MODPROP=ro.product.miname
#  patch_file
#fi








