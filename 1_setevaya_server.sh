#!/bin/bash

# Создание сетевой папки на сервере ALD

sudo mkdir /storage
sudo mkdir /storage/0
sudo mkdir /storage/1
sudo mkdir /storage/2
sudo mkdir /storage/3

sudo chmod -R 777 /storage

sudo pdpl-file 3:0:-1:ccnr /storage
sudo pdpl-file 1:0 /storage/1
sudo pdpl-file 2:0 /storage/2
sudo pdpl-file 3:0 /storage/3

sudo chmod 777 /etc/samba/smb.conf
echo "
[storage]

available = yes
comment = storage
browseable = yes
case sensitive = yes
ea support = yes
fstype = Samba
path = /storage
writable = yes
smb encrypt = auto
read only = no
guest ok = yes
delete readonly = yes
force user = nobody
force group = nogroup
force create mode = 0777
force directory mode = 0777
" >> /etc/samba/smb.conf

sed -i 's!deadtime = 10!deadtime = 0!' /etc/samba/smb.conf

sudo systemctl restart smbd.service

echo "-----Сетевая папка настроена-----"