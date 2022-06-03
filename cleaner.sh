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


