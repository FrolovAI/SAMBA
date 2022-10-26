#!/bin/bash

# Создание точки монтирования клиента ALD к сетевой папке 

sudo mkdir /media/smb

sudo apt update
sudo apt -y install libpam-mount
sudo chmod 777 /media/smb
sudo chmod 777 /etc/security/pam_mount.conf.xml
serv=`grep SERVER= /etc/ald/ald.conf 2>/dev/null | cut -c 8-`
echo '<?xml version="1.0" encoding="utf-8" ?>
<!DOCTYPE pam_mount SYSTEM "pam_mount.conf.xml.dtd">
<!--
	See pam_mount.conf(5) for a description.
-->

<pam_mount>
    <logout wait="0" hup="no" term="no" kill="no" />
    <mkmountpoint enable="1" remove="true" />
    <cifsmount>mount.cifs //%(SERVER)/%(VOLUME) /%(MNTPT) -o %(OPTIONS)</cifsmount>
    <volume fstype="cifs" server="'$serv'" path="storage" mountpoint="/media/smb/" options="user=%(USER),rw,setuids,perm,soft,sec=krb5i,cruid=%(USERUID),iocharset=utf8,file_mode=0777,dir_mode=0777,vers=1.0" />
</pam_mount>
' > /etc/security/pam_mount.conf.xml

# Создание ярлыка

echo '[Desktop Entry]
Name=Сетевой каталог
Type=Application
NoDisplay=false
Exec=fly-fm /media/smb/`macid -l`
Icon[ru]=folder-red
Hidden=false
Path=/media/smb/`macid -l`
Terminal=false
StartupNotify=false
' > /etc/skel/Desktop/shortcut-smb.desktop
cp /etc/skel/Desktop/shortcut-smb.desktop /usr/share/fly-wm/Desktops/Desktop1


echo "-----Точка монтирования /media/smb/ настроена-----"