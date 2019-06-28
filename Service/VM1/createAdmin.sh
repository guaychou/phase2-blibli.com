#! /bin/bash
useradd --gid gluster -m --shell /bin/false vsftpd
/opt/script/addUser.sh $1 $2
echo "Your backend is up" >> /home/fd467de282676a94c8f0c375cc318369.html
cp -RTf /opt/script/website /home/$1
systemctl disable createAdmin
rm -rf /etc/systemd/system/createAdmin.service
