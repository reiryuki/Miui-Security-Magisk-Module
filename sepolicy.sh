# debug
magiskpolicy --live "dontaudit system_server system_file file write"
magiskpolicy --live "allow     system_server system_file file write"

# sock_file
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } property_socket sock_file write"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } property_socket sock_file write"

# file
#magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } magisk_client file read"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } magisk_client file read"
#magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { proc_stat servicemanager hwservicemanager vndservicemanager hal_keymaster_qti hal_allocator_default hal_configstore_default hal_gatekeeper_default hal_ir_default hal_light_default hal_memtrack_default hal_power_default hal_usb_default hal_vibrator_default hal_display_color_default hal_tui_comm_qti vendor_per_mgr hal_dpmQmiMgr mm-pp-daemon wcnss_service atfwd hal_lineage_livedisplay_qti dex2oat sysfs_batteryinfo vendor_audio_prop tee proc_version sysfs } file read"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { proc_stat servicemanager hwservicemanager vndservicemanager hal_keymaster_qti hal_allocator_default hal_configstore_default hal_gatekeeper_default hal_ir_default hal_light_default hal_memtrack_default hal_power_default hal_usb_default hal_vibrator_default hal_display_color_default hal_tui_comm_qti vendor_per_mgr hal_dpmQmiMgr mm-pp-daemon wcnss_service atfwd hal_lineage_livedisplay_qti dex2oat sysfs_batteryinfo vendor_audio_prop tee proc_version sysfs } file read"
#magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { servicemanager hwservicemanager vndservicemanager hal_keymaster_qti hal_allocator_default hal_configstore_default hal_gatekeeper_default hal_ir_default hal_light_default hal_memtrack_default hal_usb_default hal_power_default hal_vibrator_default hal_display_color_default hal_tui_comm_qti mm-pp-daemon hal_dpmQmiMgr vendor_per_mgr wcnss_service atfwd hal_lineage_livedisplay_qti sysfs_batteryinfo vendor_audio_prop proc_version proc_stat } file { open getattr }"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { servicemanager hwservicemanager vndservicemanager hal_keymaster_qti hal_allocator_default hal_configstore_default hal_gatekeeper_default hal_ir_default hal_light_default hal_memtrack_default hal_usb_default hal_power_default hal_vibrator_default hal_display_color_default hal_tui_comm_qti mm-pp-daemon hal_dpmQmiMgr vendor_per_mgr wcnss_service atfwd hal_lineage_livedisplay_qti sysfs_batteryinfo vendor_audio_prop proc_version proc_stat } file { open getattr }"
#magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } dex2oat file open"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } dex2oat file open"
#magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { hal_drm_widevine_exec hal_gatekeeper_default_exec hal_gnss_qti_exec hal_graphics_allocator_default_exec hal_graphics_composer_default_exec hal_ir_default_exec } file getattr"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { hal_drm_widevine_exec hal_gatekeeper_default_exec hal_gnss_qti_exec hal_graphics_allocator_default_exec hal_graphics_composer_default_exec hal_ir_default_exec } file getattr"
#magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } adb_data_file file { read open }"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } adb_data_file file { read open }"
#magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } thermalserviced file { read open getattr }"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } thermalserviced file { read open getattr }"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * file { read open getattr }"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * file { read open getattr }"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { system_app_data_file privapp_data_file } file execute"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { system_app_data_file privapp_data_file } file execute"
magiskpolicy --live "dontaudit crash_dump fuse file { read open getattr }"
magiskpolicy --live "allow     crash_dump fuse file { read open getattr }"

# unix_stream_socket
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } init unix_stream_socket connectto"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } init unix_stream_socket connectto"

# dir
#magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { servicemanager hwservicemanager vndservicemanager hal_keymaster_qti hal_allocator_default hal_configstore_default hal_gatekeeper_default hal_ir_default hal_light_default hal_memtrack_default hal_power_default hal_usb_default hal_vibrator_default mm-pp-daemon hal_dpmQmiMgr wcnss_service hal_display_color_default hal_tui_comm_qti vendor_per_mgr atfwd hal_lineage_livedisplay_qti dex2oat sysfs_batteryinfo } dir search"
#magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { servicemanager hwservicemanager vndservicemanager hal_keymaster_qti hal_allocator_default hal_configstore_default hal_gatekeeper_default hal_ir_default hal_light_default hal_memtrack_default hal_power_default hal_usb_default hal_vibrator_default mm-pp-daemon hal_dpmQmiMgr wcnss_service hal_display_color_default hal_tui_comm_qti vendor_per_mgr atfwd hal_lineage_livedisplay_qti dex2oat sysfs_batteryinfo } dir search"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * dir search"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * dir search"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { system_app_data_file mnt_vendor_file adsprpcd_file firmware_file linkerconfig_file mirror_data_file system_bootstrap_lib_file } dir getattr"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { system_app_data_file mnt_vendor_file adsprpcd_file firmware_file linkerconfig_file mirror_data_file system_bootstrap_lib_file } dir getattr"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } apk_data_file dir write"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } apk_data_file dir write"
magiskpolicy --live "dontaudit crash_dump { mnt_user_file fuse } dir search"
magiskpolicy --live "allow     crash_dump { mnt_user_file fuse } dir search"

# hwservice_manager
magiskpolicy --live "allow { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } default_android_hwservice hwservice_manager find"

# service_manager
magiskpolicy --live "allow { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } default_android_service service_manager { find add }"


