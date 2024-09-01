local RepArch = require("RepArch")
local Package = RepArch.Package
local grub = require("grub")

return RepArch.Define {
    Package :Name('Base') {
        Package :Name('Linux')
            'base' 'linux' 'linux-firmware';
    
        Package :Name('Linux Build')
            'linux-headers' 'base-devel' 'git' 'mandoc';
    
        Package :Name('Boot Manager') :Handle(grub) 'grub-customizer' 'efibootmgr' {
            grub.KernelParameter
                "psi=1"
                "acpi.ec_no_wakeup=1";
        };
    };

    Package :Name('Package Management')
        'aur/pkg_scripts';

    Package :Name('Firmware Update Service') 'fwupd';

    Package :Name('Bluetooth Service')
        'bluez' 'bluez-utils' {

        ququ.Patch '/etc/bluetooth/main.conf' :StripIndent() [[
            --- -	2024-07-30 14:17:11.647497121 +0900
            +++ /etc/bluetooth/main.conf	2024-07-30 14:12:58.585513083 +0900
            @@ -124,7 +124,7 @@
            
            # Enables D-Bus experimental interfaces
            # Possible values: true or false
            -#Experimental = false
            +Experimental = true
            
            # Enables D-Bus testing interfaces
            # Possible values: true or false
            @@ -141,7 +141,7 @@
            # a6695ace-ee7f-4fb9-881a-5fac66c629af (BlueZ Experimental Offload Codecs)
            # 6fbaf188-05e0-496a-9885-d6ddfdb4e03e (BlueZ Experimental ISO socket)
            # Defaults to false.
            -#KernelExperimental = false
            +KernelExperimental = 6fbaf188-05e0-496a-9885-d6ddfdb4e03e
            
            # The duration to avoid retrying to resolve a peer's name, if the previous
            # try failed.
        ]]
    };

    Package :Name('Graphic Driver')
        'xf86-video-amdgpu'
        'mesa' 'lib32-mesa'
        'vulkan-radeon' 'lib32-vulkan-radeon'
        'libva-mesa-driver' 'lib32-libva-mesa-driver'
        'mesa-vdpau' 'lib32-mesa-vdpau';

    Package :Name('Media library') {
        Package :Name('gstreamer')
            'gstreamer' 'gstreamer-vaapi';

        Package 'ffmpeg';

        Package 'imagemagick';
    };

    Package :Name('Keystore')
        'gnupg';

    Package :Name('GUI library') {
        Package :Name('QT') 'qt5' 'qt6';

        Package :Name('Window Server')
            'xorg-server' 'xorg-apps' 'wayland';
    };

    Package :Name('Printer Service')
        'cups';

    Package :Name('Network')
        'networkmanager';

    Package :Name('Sound Service')
        'wireplumber' -- Session manager
        --[['pipewire-jack' i have no idea]] 'pipewire-pulse'
        'pipewire-alsa' 'pipewire'
        'alsa-utils' 'pavucontrol' -- control
        'lsp-plugins'; -- effect plugins

    -- For trackpoint/touchpad/touchscreen
    Package :Name('Input Driver')
        'xf86-input-libinput';

    Package :Name('Finger Print Manager') 'libfprint' 'fprintd' {
        RepArch.Patch '/etc/pam.d/sudo' :As('root') [[
        
        ]];

        RepArch.Mkdir :As('root') '/etc/polkit-1/rules.d' ;

        RepArch.Write :As('root') '/etc/polkit-1/rules.d/50-default.rules' [[
            ipolkit.addAdminRule(function(action, subject) {
                return ["unix-group:sudo"];
            });
        ]] :StripIndent();

        -- Disallow fingerprint enroll
        RepArch.Write :As('root') '/etc/polkit-1/rules.d/50-net.reactivated.fprint.device.enroll.rules' [[
            polkit.addRule(function (action, subject) {
                if (action.id == "net.reactivated.fprint.device.enroll") {
                    return subject.user == "root" ? polkit.Result.YES : polkit.Result.NO
                }
            })
        ]] :StripIndent();
    };

    Package :Name('Filesystem') 'ntfs-3g';

    Package :Name('Poewr management') 'tuned' 'tuned-ppd' {
        Package 'upower';

        RepArch.Write :Mkdir() :As('root') :StripIndent() '/etc/tuned/profiles/qwreey-b-save/tuned.conf' [[
            #
            # tuned configuration
            #
            [main]
            include = laptop-battery-powersave

            [cpu]
            load_threshold = 0.2
            latency_low = 100
            latency_high = 1000
            governor = poewrsave
            no_turbo = True
            energy_performance_preference = balance_power

            [usb]
            autosuspend = True

            [video]
            radeon_powersave = dpm-battery

            [acpi]
            platform_profile = low-power

            [net]
            dynamic = True
            wake_on_lan = False

            [sysfs]

            [audio]
            timeout = 1
            reset_controller = False

            [disk]
            dynamic = True
        ]];

        -- Sleep patch
        RepArch.Write
            :As('root')
            :StripIndent()
            :gsub("    ","\t")
            :gsub("\n *%*%*%*.+%*%*%* *","")
            :Mkdir()
            :Chmod('u+x')
            '/usr/lib/systemd/system-sleep/workaround' [[
            #!/bin/sh
    
            *** Disable Non-Boot Core When Sleep ***
            function corep() {
                for file in /sys/devices/system/cpu/cpu[1-9]*; do
                    if [ -e "$file/online" ] && [ "$file" != "/sys/devices/system/cpu/cpu1" ]; then
                        /usr/bin/echo $1 > $file/online
                    fi
                done
            }
    
            if [ "$1" == "pre" ]; then
                if [ "$2" == "hibernate" ]; then
                    *** Workaround wifi issue ***
                    /usr/bin/systemctl stop NetworkManager.service systemd-networkd.service systemd-networkd.socket
                    /usr/bin/modprobe -r ath11k_pci
                    *** Workaround trackpad issue ***
                    /usr/bin/modprobe -r psmouse
                else
                    *** ASPM Powersave ***
                    /usr/bin/echo powersupersave > /sys/module/pcie_aspm/parameters/policy
                    corep 0
                fi
            elif [ "$1" == "post" ]; then
                if [ "$2" == "hibernate" ]; then
                    /usr/bin/systemctl is-enabled NetworkManager.service && /usr/bin/systemctl start NetworkManager.service
                    /usr/bin/systemctl is-enabled systemd-networkd.socket && /usr/bin/systemctl start systemd-networkd.socket
                    /usr/bin/systemctl is-enabled systemd-networkd.service && /usr/bin/systemctl start systemd-networkd.service
                    /usr/bin/modprobe ath11k_pci
                    /usr/bin/modprobe psmouse
                else
                    corep 1
                    /usr/bin/echo default > /sys/module/pcie_aspm/parameters/policy
                fi
            fi
        ]];
    };
}