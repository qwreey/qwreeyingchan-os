local RepArch = require("RepArch")
local Package = RepArch.Package

-- TODO: local/ support  (package)
-- TODO: aur/ handler
-- TODO: xdg default for user
-- TODO: impl all
-- TODO: Systemd service
-- TODO: flatpak
-- TODO: pacman source manage

-- amberol
-- blackbox-terminal
-- devhelp
-- dissent
-- ghex
-- gnome-disk-utility
-- gnome-logs
-- gnome-maps
-- gnome-system-monitor
-- gnome-terminal

Package {

    Package :Name("IME") :Handle(Nimf) {
        Nimf.TargetUser 'qwreey';
        Nimf.HotKeys 'Alt_R';
    };


    Package :Name('System') :Handle(require './system.luau');

    -- For ADB
    Package :Name('Android') 'android-tools';

    Package :Name('CLI utility') {
        Package :Name('Shell') 'zsh';
        Package :Name('Editor') 'vim';
        Package :Name('Status') 'btop' 'neofetch' 'gdu' 'aur/amdgpu_top-git' 'smartmontools';
        Package :Name('Remote') 'openssh';
        Package :Name('pager') 'less';
    };

    Package :Name('VPN') 'tailscale';

    Package :Name('Waydroid') {
        Package :Name('Binder') 'binder_linux-dkms';
        Package
            'aur/waydroid'
            'aur/waydroid-script-git'
            'aur/waydroid-settings-git';
    };

    Package :Name('GUI system') {
        Package :Name('XDG') {
            Package :Name('User Dirs') 'xdg-user-dirs' 'xdg-user-dirs-gtk';
            Package :Name('Portal') 'xdg-desktop-portal-gtk' 'xdg-desktop-portal-gnome' 'xdg-desktop-portal';
        };

        Package :Name('Fonts')
            'ttf-twemoji' 'noto-fonts-cjk';

        Package :Name('Gnome') :Handle(require 'gnome');

        Package :Name('Clipboard') :Handle(require 'clipboard')
        Package :Name('Basic Apps') {
            Flatpak 'blackbox';

            Package 'snapshot' -- Camera
                    'gnome-calculator' -- Calculator 
                    'gnome-calendar' -- Calendar
                    'gnome-clocks' -- Clocks
                    'gnome-font-viewer' -- Font viewer
                    'gnome-weather' -- Weather
                    'geary' -- Email client

                    'authenticator' -- TOTP
                    'gnome-firmware' -- fwupd gui

                    -- we need flatpak
                    'easyeffects'
                    'mission-center'
                    'junction'
                    'nextcloud-client'
                    'vesktop'
                    'countdown'
                    'seahorse' -- Key management
                    'gedit' -- Text 
                    'gnome-text-editor'
                    'xournalpp' -- PDF viewer/editor
                    'steam'
                    'obs-studio'
                    'aur/video-trimmer'
                    'aur/gnome-obfuscate'
                    'aur/decoder' -- QR code read/create
                    'aur/collision' -- Checksum
                    'aur/cartridges' -- Game library
                    'fragments' -- torrent
                    'fractal' -- matrix chat app
                    'baobab' -- Disk file size analyzer
                    'gparted' -- Disk manager
                    'gnome-system-monitor';

            Package :Name('File Browse') {
                Package :Name("Explorer") 'nautilus' 'nemo';
                Package :Name('Archive Utility') 'aur/file-roller-linuxmint' 'nemo-fileroller';
                Package :Name('Image Viewer') 'eog';
                Package :Name('Video Viewer') 'clapper';

                XdgMime '';

                -- TODO: xdg default to user
            };

            Package :Name('Remote') {
                Package :Name('remmina') 'remmina' 'libvncserver' 'spice-gtk' 'freerdp';
            };

            -- i wanna remove epiphany
            Package :Name('Browser') 'aur/thorium-browser-bin' 'firefox' 'aur/tangram' 'epiphany';

            Package :Name('Development') {
                Package :Name('Editor') 'aur/visual-studio-code-bin'
            }
        };
    };

}
