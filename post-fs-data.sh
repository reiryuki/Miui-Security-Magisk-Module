mount -o rw,remount /data
MODPATH=${0%/*}

# log
exec 2>$MODPATH/debug-pfsd.log
set -x

# var
ABI=`getprop ro.product.cpu.abi`

# function
permissive() {
if [ "$SELINUX" == Enforcing ]; then
  if ! setenforce 0; then
    echo 0 > /sys/fs/selinux/enforce
  fi
fi
}
magisk_permissive() {
if [ "$SELINUX" == Enforcing ]; then
  if [ -x "`command -v magiskpolicy`" ]; then
	magiskpolicy --live "permissive *"
  else
	$MODPATH/$ABI/libmagiskpolicy.so --live "permissive *"
  fi
fi
}
sepolicy_sh() {
if [ -f $FILE ]; then
  if [ -x "`command -v magiskpolicy`" ]; then
    magiskpolicy --live --apply $FILE 2>/dev/null
  else
    $MODPATH/$ABI/libmagiskpolicy.so --live --apply $FILE 2>/dev/null
  fi
fi
}

# selinux
SELINUX=`getenforce`
chmod 0755 $MODPATH/*/libmagiskpolicy.so
#1permissive
#2magisk_permissive
#kFILE=$MODPATH/sepolicy.rule
#ksepolicy_sh
FILE=$MODPATH/sepolicy.pfsd
sepolicy_sh

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

# dependency
#rm -f /data/adb/modules/MiuiCore/remove
#rm -f /data/adb/modules/MiuiCore/disable

# patch plat_seapp_contexts
FILE=/system/etc/selinux/plat_seapp_contexts
rm -f $MODPATH$FILE
if ! grep 'user=system seinfo=default domain=system_app type=system_app_data_file' $FILE; then
  cp -af $FILE $MODPATH$FILE
  sed -i '1i\
user=system seinfo=default domain=system_app type=system_app_data_file' $MODPATH$FILE
fi

# cleaning
FILE=$MODPATH/cleaner.sh
if [ -f $FILE ]; then
  . $FILE
  mv -f $FILE $FILE.txt
fi







