# Miui Security Magisk Module

## DISCLAIMER
- Miui apps are owned by Xiaomi™.
- The MIT license specified here is for the Magisk Module only, not for Miui apps.

## Descriptions
Security, Cleaner, Scanner, and Game Booster app by Xiaomi Inc. ported and integrated as a Magisk Module for all supported and rooted devices with Magisk

## Sources
- https://apkmirror.com com.miui.securitycenter, com.miui.securityadd, com.miui.cleanmaster, & com.miui.guardprovider by Xiaomi Inc.
- libmagiskpolicy.so: Magisk (stable) 30.7 (30700)

## Changelog

v2.1
- Fix crashes registerReceiver in Android 16

v2.0
- Prepare /storage/emulated/"$UID"/Android/data/$PKG/files directories
- Support NoMount metamodule
- Update libmagiskpolicy.so from Magisk (stable) 30.7 (30700)
- Resets module folders/files permissions at post-fs-data
- Move _uninstall.log to /data/adb/logs/

v1.19
- Fix SystemUI visibility while changing between dark and light theme immediately
- Fix IllegalArgumentException
- Redirect miui.intent.action.OP_AUTO_START to android.settings.IGNORE_BATTERY_OPTIMIZATION_SETTINGS
- Add Action button to clear apps caches
- Fix architecture detection in some weird ROMs
- Remove luckypatcher detection and add "not enough space" detection at installation
- Fix bug in uninstall.sh

v1.18
- Fix status bar visibility
- Fix conflict with modules_update while installing via recovery if Magisk installed
- Fix MagiskHide & SUList

v1.17-R
- Fix a method bug

v1.17
- Fix android.permission.BLUETOOTH_CONNECT
- Fix a fatal exception
- Redirect mimarket://search?q= to market://search?q=
- Does not remove com.miui.securitycenter data at uninstall

v1.16
- Using back sharedUserId="android.uid.system"
- Patches plat_seapp_contexts to fix crash caused by seinfo default not found
- Fix Game Turbo overlay
- Enable some features
- Does not download resource.zip
- Redirect /sdcard to /data/media/"$UID"
- Fix MagiskHide & SUList
- Update sepolicy rules

v1.15
- Specify UID at script
- Add optional debug.log=1 for more detailed install log

v1.14
- Update sepolicy rules
- Fix permissions
- Fix resources conflict in some ROMs

v1.13
- KernelSU support
- Magisk v26.1 support
- Can be installed in non-AOSP signatured ROM without disabling Android Signature Verifications (but Game Turbo and Ultra Battery Saver still requires AOSP signatured ROM or disabled Android Signature Verifications in non-AOSP signatured ROM)
- Allow installation via recovery if Magisk installed
- Save install log at /sdcard/..._recovery.log if installing via Recovery
- Fix optional permissive mode
- Set blacklist/whitelist
- Update sepolicy rules
- Fix permissions
- Save uninstall log at /data/media/0/..._uninstall.log
- Fix fatal exceptions
- Fix recents bug after disabling Ultra Battery Saver
- Fix get/put settings destination
- Using dex version 035 fix for Android Oreo and bellow

## Screenshots
https://t.me/androidryukimods/219

## Requirements
- NOT in Miui ROM
- Android 5 (SDK 21) and up
- Magisk or Kitsune Mask or KernelSU or Apatch installed
- Disabled Android Signature Verification in non-AOSP Signatured ROM to allow android.uid.system. Tap here: https://t.me/ryukinotes/81
- Miui Core Magisk Module installed

## Installation Guide & Download Link
- If you are using KernelSU, you need to disable Unmount Modules by Default in KernelSU app settings and install https://github.com/KernelSU-Modules-Repo/meta-overlayfs or https://github.com/KernelSU-Modules-Repo/magic_mount_rs or https://github.com/KernelSU-Modules-Repo/hybrid_mount or https://github.com/maxsteeel/nomount first depending on ROM compatibility
- Install Miui Core Magisk Module first: https://github.com/reiryuki/Miui-Core-Magisk-Module
- Install this module https://github.com/reiryuki/Miui-Security-Magisk-Module via Magisk app or Kitsune Mask app or KernelSU app or Apatch app or Recovery if Magisk or Kitsune Mask installed
- If installation failed, READ Troubleshootings bellow!
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package.txt (and your home launcher app also) (enable show system apps) and reboot afterwards
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot afterwards
- Go to app info of Security, Cleaner, System service plugin, and MIUI security components app and allow their network access

## Download Tutorial
https://t.me/ryukinotes/97

## Optionals
- https://t.me/ryukinotes/42
- Global: https://t.me/ryukinotes/35

## Troubleshootings
- https://t.me/ryukinotes/19
- Global: https://t.me/ryukinotes/34

## Known Issues
Lock apps, hide apps, data restriction, & and some fratures in Game Booster doesn't work

## Support & Bug Report
- https://t.me/ryukinotes/54
- If you don't do above, issues will be closed immediately

## Credits and Contributors
- https://t.me/androidryukimodsdiscussions
- https://t.me/androidappsportdevelopment

## Sponsors
https://t.me/ryukinotes/25


