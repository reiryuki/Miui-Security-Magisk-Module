# debug
magiskpolicy --live "dontaudit system_server system_file file write"
magiskpolicy --live "allow     system_server system_file file write"

# sock_file
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } property_socket sock_file write"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } property_socket sock_file write"

# file
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * file { read open getattr map }"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * file { read open getattr map }"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { system_app_data_file privapp_data_file } file execute"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { system_app_data_file privapp_data_file } file execute"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } apk_data_file file ioctl"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } apk_data_file file ioctl"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } system_file file lock"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } system_file file lock"
magiskpolicy --live "dontaudit crash_dump fuse file { read open getattr }"
magiskpolicy --live "allow     crash_dump fuse file { read open getattr }"

# dir
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * dir { search getattr }"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } * dir { search getattr }"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } apk_data_file dir write"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } apk_data_file dir write"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { system_bootstrap_lib_file vendor_firmware_file vendor_keylayout_file metadata_file system_data_file asec_apk_file } dir read"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { system_bootstrap_lib_file vendor_firmware_file vendor_keylayout_file metadata_file system_data_file asec_apk_file } dir read"
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { apex_mnt_dir adsprpcd_file vendor_firmware_file vendor_keylayout_file metadata_file } dir open"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { apex_mnt_dir adsprpcd_file vendor_firmware_file vendor_keylayout_file metadata_file } dir open"
magiskpolicy --live "dontaudit crash_dump { mnt_user_file fuse } dir search"
magiskpolicy --live "allow     crash_dump { mnt_user_file fuse } dir search"

# unix_stream_socket
magiskpolicy --live "dontaudit { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } init unix_stream_socket connectto"
magiskpolicy --live "allow     { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } init unix_stream_socket connectto"

# hwservice_manager
magiskpolicy --live "allow { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } default_android_hwservice hwservice_manager find"

# service_manager
magiskpolicy --live "allow { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } default_android_service service_manager { find add }"
magiskpolicy --live "allow { system_app priv_app platform_app untrusted_app_29 untrusted_app_27 untrusted_app } { perfshielder ProcessManager } service_manager add"


