local RepArch = require("ququ")
local Package = RepArch.Package
local env = require("env")

return RepArch.Define {
    Package :Name('Shell')
        'gnome-shell' 'gnome-session';
    Package :Name('IME') :Handle(env)
        'ibus' 'ibus-hangul' {
        env.GlobalEnvironment
    };
    Package :Name('Share')
        'gnome-user-share';
    Package :Name('Keystore')
        'gnome-keyring';
    Package :Name('Tweaker')
        'gnome-tweaks';
    Package :Name('Color')
        'gnome-color-manager';
    Package :Name('Settings')
        'dconf-editor'
        'gnome-settings-daemon'
        'gnome-control-center';
    Package :Name('GVFS')
        'gvfs'
        'gvfs-gphoto2'
        'gvfs-mtp'
        'gvfs-smb';
    Package :Name ('Greeter')
        'gdm' 'gdm-settings';
    Package :Name('Search')
        'tracker3-miners' -- FS indexer
        'grilo-plugins'; -- API provider
    Package :Name('Software')
        'malcontent'
        'archlinux-appstream-data'
        'packagekit'
        'gnome-software';
    Package :Name('extension')
        'aur/extension-manager';
}