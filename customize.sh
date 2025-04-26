# space
ui_print " "

# info
MODVER=`grep_prop version $MODPATH/module.prop`
MODVERCODE=`grep_prop versionCode $MODPATH/module.prop`
ui_print " ID=$MODID"
ui_print " Version=$MODVER"
ui_print " VersionCode=$MODVERCODE"
if [ "$KSU" == true ]; then
  ui_print " KSUVersion=$KSU_VER"
  ui_print " KSUVersionCode=$KSU_VER_CODE"
  ui_print " KSUKernelVersionCode=$KSU_KERNEL_VER_CODE"
  sed -i 's|#k||g' $MODPATH/post-fs-data.sh
else
  ui_print " MagiskVersion=$MAGISK_VER"
  ui_print " MagiskVersionCode=$MAGISK_VER_CODE"
fi
ui_print " "

# var
UID=`id -u`
[ ! "$UID" ] && UID=0
FIRARCH=`grep_get_prop ro.bionic.arch`
SECARCH=`grep_get_prop ro.bionic.2nd_arch`
ABILIST=`grep_get_prop ro.product.cpu.abilist`
if [ ! "$ABILIST" ]; then
  ABILIST=`grep_get_prop ro.system.product.cpu.abilist`
fi
if [ "$FIRARCH" == arm64 ]\
&& ! echo "$ABILIST" | grep -q arm64-v8a; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,arm64-v8a"
  else
    ABILIST=arm64-v8a
  fi
fi
if [ "$FIRARCH" == x64 ]\
&& ! echo "$ABILIST" | grep -q x86_64; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,x86_64"
  else
    ABILIST=x86_64
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST" | grep -q armeabi; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,armeabi"
  else
    ABILIST=armeabi
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST" | grep -q armeabi-v7a; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,armeabi-v7a"
  else
    ABILIST=armeabi-v7a
  fi
fi
if [ "$SECARCH" == x86 ]\
&& ! echo "$ABILIST" | grep -q x86; then
  if [ "$ABILIST" ]; then
    ABILIST="$ABILIST,x86"
  else
    ABILIST=x86
  fi
fi
ABILIST32=`grep_get_prop ro.product.cpu.abilist32`
if [ ! "$ABILIST32" ]; then
  ABILIST32=`grep_get_prop ro.system.product.cpu.abilist32`
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST32" | grep -q armeabi; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,armeabi"
  else
    ABILIST32=armeabi
  fi
fi
if [ "$SECARCH" == arm ]\
&& ! echo "$ABILIST32" | grep -q armeabi-v7a; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,armeabi-v7a"
  else
    ABILIST32=armeabi-v7a
  fi
fi
if [ "$SECARCH" == x86 ]\
&& ! echo "$ABILIST32" | grep -q x86; then
  if [ "$ABILIST32" ]; then
    ABILIST32="$ABILIST32,x86"
  else
    ABILIST32=x86
  fi
fi
if [ ! "$ABILIST32" ]; then
  [ -f /system/lib/libandroid.so ] && ABILIST32=true
fi

# log
if [ "$BOOTMODE" != true ]; then
  FILE=/data/media/"$UID"/$MODID\_recovery.log
  ui_print "- Log will be saved at $FILE"
  exec 2>$FILE
  ui_print " "
fi

# optionals
OPTIONALS=/data/media/"$UID"/optionals.prop
if [ ! -f $OPTIONALS ]; then
  touch $OPTIONALS
fi

# debug
if [ "`grep_prop debug.log $OPTIONALS`" == 1 ]; then
  ui_print "- The install log will contain detailed information"
  set -x
  ui_print " "
fi

# recovery
if [ "$BOOTMODE" != true ]; then
  MODPATH_UPDATE=`echo $MODPATH | sed 's|modules/|modules_update/|g'`
  rm -f $MODPATH/update
  rm -rf $MODPATH_UPDATE
fi

# sdk
NUM=21
if [ "$API" -lt $NUM ]; then
  ui_print "! Unsupported SDK $API."
  ui_print "  You have to upgrade your Android version"
  ui_print "  at least SDK $NUM to use this module."
  abort
else
  ui_print "- SDK $API"
  ui_print " "
fi

# boot mode
if [ "$BOOTMODE" != true ]; then
  abort "! Please install via Magisk/KernelSU app only!"
fi

# run
. $MODPATH/function.sh

# sepolicy
FILE=$MODPATH/sepolicy.rule
DES=$MODPATH/sepolicy.pfsd
if [ "`grep_prop sepolicy.sh $OPTIONALS`" == 1 ]\
&& [ -f $FILE ]; then
  mv -f $FILE $DES
fi

# miuicore
if [ ! -d /data/adb/modules/MiuiCore ]; then
  ui_print "! Miui Core Magisk Module is not installed."
  ui_print "  Please read github installation guide!"
  abort
else
  rm -f /data/adb/modules/MiuiCore/remove
  rm -f /data/adb/modules/MiuiCore/disable
fi

# cleaning
ui_print "- Cleaning..."
PKGS=`cat $MODPATH/package.txt`
if [ "$BOOTMODE" == true ]; then
  for PKG in $PKGS; do
    FILE=`find /data/app -name *$PKG*`
    if [ "$FILE" ]; then
      RES=`pm uninstall $PKG 2>/dev/null`
    fi
  done
fi
remove_sepolicy_rule
ui_print " "
# power save
FILE=$MODPATH/system/etc/sysconfig/*
if [ "`grep_prop power.save $OPTIONALS`" == 1 ]; then
  ui_print "- $MODNAME will not be allowed in power save."
  ui_print "  It may save your battery but decreasing $MODNAME performance."
  for PKG in $PKGS; do
    sed -i "s|<allow-in-power-save package=\"$PKG\"/>||g" $FILE
    sed -i "s|<allow-in-power-save package=\"$PKG\" />||g" $FILE
  done
  ui_print " "
fi

# cleanup
DIR=/data/adb/modules/$MODID
FILE=$DIR/module.prop
PREVMODNAME=`grep_prop name $FILE`
if [ "`grep_prop data.cleanup $OPTIONALS`" == 1 ]; then
  sed -i 's|^data.cleanup=1|data.cleanup=0|g' $OPTIONALS
  ui_print "- Cleaning-up $MODID data..."
  cleanup
  ui_print " "
#elif [ -d $DIR ]\
#&& [ "$PREVMODNAME" != "$MODNAME" ]; then
#  ui_print "- Different module name is detected"
#  ui_print "  Cleaning-up $MODID data..."
#  cleanup
#  ui_print " "
fi

# function
test_signature() {
FILE=`find $MODPATH/system -type f -name $APP.apk`
ui_print "- Testing signature..."
RES=`pm install -g -i com.android.vending $FILE 2>&1`
if [ "$RES" ]; then
  ui_print "  $RES"
fi
if [ "$RES" == Success ]; then
  RES=`pm uninstall -k $PKG 2>/dev/null`
  ui_print "  Signature test is passed"
elif echo "$RES" | grep -q INSTALL_FAILED_SHARED_USER_INCOMPATIBLE; then
  ui_print "  Signature test is failed"
  ui_print "  But installation is allowed for this case"
  ui_print "  Make sure you have deactivated your Android Signature"
  ui_print "  Verification, otherwise the app cannot be installed correctly."
  ui_print "  If you don't know what is it, please READ Troubleshootings!"
elif echo "$RES" | grep -Eq 'INSTALL_FAILED_INSUFFICIENT_STORAGE|not enough space'; then
  ui_print "  Please free-up your internal storage first!"
  abort
else
  ui_print "  ! Signature test is failed"
  ui_print "    You need to disable Signature Verification of your"
  ui_print "    Android first to use this module. READ Troubleshootings!"
  if [ "`grep_prop force.install $OPTIONALS`" != 1 ]; then
    abort
  fi
fi
ui_print " "
}

# test
APP=SecurityCenter
PKG=com.miui.securitycenter
if [ "$BOOTMODE" == true ]; then
  if ! appops get $PKG > /dev/null 2>&1; then
    test_signature
  fi
fi

# function
conflict() {
for NAME in $NAMES; do
  DIR=/data/adb/modules_update/$NAME
  if [ -f $DIR/uninstall.sh ]; then
    sh $DIR/uninstall.sh
  fi
  rm -rf $DIR
  DIR=/data/adb/modules/$NAME
  rm -f $DIR/update
  touch $DIR/remove
  FILE=/data/adb/modules/$NAME/uninstall.sh
  if [ -f $FILE ]; then
    sh $FILE
    rm -f $FILE
  fi
  rm -rf /metadata/magisk/$NAME\
   /mnt/vendor/persist/magisk/$NAME\
   /persist/magisk/$NAME\
   /data/unencrypted/magisk/$NAME\
   /cache/magisk/$NAME\
   /cust/magisk/$NAME
done
}

# conflict
NAMES=MiuiSecurityCenter
conflict

# function
permissive_2() {
sed -i 's|#2||g' $MODPATH/post-fs-data.sh
}
permissive() {
FILE=/sys/fs/selinux/enforce
SELINUX=`cat $FILE`
if [ "$SELINUX" == 1 ]; then
  if ! setenforce 0; then
    echo 0 > $FILE
  fi
  SELINUX=`cat $FILE`
  if [ "$SELINUX" == 1 ]; then
    ui_print "  Your device can't be turned to Permissive state."
    ui_print "  Using Magisk Permissive mode instead."
    permissive_2
  else
    if ! setenforce 1; then
      echo 1 > $FILE
    fi
    sed -i 's|#1||g' $MODPATH/post-fs-data.sh
  fi
else
  sed -i 's|#1||g' $MODPATH/post-fs-data.sh
fi
}

# permissive
if [ "`grep_prop permissive.mode $OPTIONALS`" == 1 ]; then
  ui_print "- Using device Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive
  ui_print " "
elif [ "`grep_prop permissive.mode $OPTIONALS`" == 2 ]; then
  ui_print "- Using Magisk Permissive mode."
  rm -f $MODPATH/sepolicy.rule
  permissive_2
  ui_print " "
fi

# function
extract_lib() {
for APP in $APPS; do
  FILE=`find $MODPATH/system -type f -name $APP.apk`
  if [ -f `dirname $FILE`/extract ]; then
    ui_print "- Extracting..."
    DIR=`dirname $FILE`/lib/"$ARCHLIB"
    mkdir -p $DIR
    rm -rf $TMPDIR/*
    DES=lib/"$ABILIB"/*
    unzip -d $TMPDIR -o $FILE $DES
    cp -f $TMPDIR/$DES $DIR
    ui_print " "
  fi
done
}
hide_oat() {
for APP in $APPS; do
  REPLACE="$REPLACE
  `find $MODPATH/system -type d -name $APP | sed "s|$MODPATH||g"`/oat"
done
}

# extract
APPS="`ls $MODPATH/system/priv-app`
      `ls $MODPATH/system/app`"
ARCHLIB=arm64
ABILIB=arm64-v8a
extract_lib
ARCHLIB=arm
if echo "$ABILIST" | grep -q armeabi-v7a; then
  ABILIB=armeabi-v7a
  extract_lib
elif echo "$ABILIST" | grep -q armeabi; then
  ABILIB=armeabi
  extract_lib
else
  ABILIB=armeabi-v7a
  extract_lib
fi
ARCHLIB=x64
ABILIB=x86_64
extract_lib
ARCHLIB=x86
ABILIB=x86
extract_lib
rm -f `find $MODPATH/system -type f -name extract`
# hide
hide_oat

# global
FILE=$MODPATH/service.sh
NAME=ro.security.mod_device
if [ "`grep_prop miui.security.global $OPTIONALS`" == 1 ]; then
  ui_print "- Security global mode"
  sed -i "s|#resetprop -n $NAME|resetprop -n $NAME|g" $FILE
  ui_print " "
fi









