#! /bin/bash
/opt/script/addUser.sh $1 $2
systemctl disable createAdmin
rm -rf /opt/blibli /etc/systemd/system/createAdmin.service
