#! /bin/bash
/opt/script/addUser.sh $1 $2
systemctl disable createAdmin
rm -rf /etc/systemd/system/createAdmin.service
