#!/bin/bash -e
# enable live
ymp repo --update --ignore-gpg --allow-oem
ymp install shadow audit --no-emerge --allow-oem
ymp install e2fsprogs dialog grub parted dosfstools rsync --no-emerge --allow-oem
rm -f /sbin/init
wget https://gitlab.com/turkman/devel/sources/installer/-/raw/master/main.sh -O /sbin/init
chmod 755 /sbin/init
# install xfce
ymp repo --update --allow-oem --ignore-gpg
ymp it xinit xorg-server xterm freetype xauth xkbcomp xkeyboard-config @x11.drivers --no-emerge --allow-oem
ymp it elogind shadow pipewire wireplumber libtool firefox-installer inxi tzdata fuse fuse2 flatpak --no-emerge --allow-oem
ymp it @xfce xfce4-screenshooter xfce4-battery-plugin xfce-polkit xfce4-pulseaudio-plugin xfce4-terminal xfce4-whiskermenu-plugin mousepad ristretto --no-emerge --allow-oem
ymp it caribou dejavu adwaita-icon-theme gsettings-desktop-schemas libhandy nm-applet seatd touchegg --no-emerge --allow-oem
ymp it gnome-icon-theme gnome-themes-standard lightdm lightdm-gtk-greeter --no-emerge --allow-oem
# fstab add tmpfs
echo "tmpfs /tmp tmpfs rw 0 0" > /etc/fstab
ln -s /proc/mounts /etc/mtab
# enable login from shadow
sed -i "s|#agetty_options.*|agetty_options=\" -l /usr/bin/login\"|" /etc/conf.d/agetty
chmod u+s /bin/su /usr/bin/su
# set language
mkdir -p /lib64/locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "" >> /etc/locale.gen
echo "export LANG=en_US.UTF-8" > /etc/profile.d/locale.sh
echo "export LC_ALL=en_US.UTF-8" >> /etc/profile.d/locale.sh
locale-gen
# polkit enable
chmod u+s /usr/bin/pkexec /usr/lib64/polkit-1/polkit-agent-helper-1
echo "/bin/bash" > /etc/shells
echo "/bin/sh" >> /etc/shells
echo "/bin/ash" >> /etc/shells
# hostname
echo turkman > /etc/hostname
# install wifi and bluetooth
ymp it wpa_supplicant networkmanager bluez --no-emerge --allow-oem
# update hicolor icons
gtk-update-icon-cache /usr/share/icons/hicolor/
# enable services
rc-update add elogind
rc-update add eudev
rc-update add fuse
rc-update add seatd
rc-update add upowerd
rc-update add hostname
rc-update add wpa_supplicant
rc-update add networkmanager
rc-update add lightdm
rc-update add bluetooth
rc-update add polkit
rc-update add touchegg
rc-update add devfs
ymp clean --allow-oem
# revert hardened bindir
mkdir -p /usr/local/bin
chmod 755 /bin /usr/bin /sbin /usr/sbin /usr/local/bin
# remove static libraries
find / -type f -iname '*.a' -exec rm -f {} \;
exit 0
