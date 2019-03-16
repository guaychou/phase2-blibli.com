#! /bin/bash

# How to run is : addUser.sh <namaUser> <passwordUser>
useradd -m -s /bin/bash $1
echo -e "$2\n$2\n" | passwd $1
echo "$1" >> /etc/vsftpd.userlist
chmod 0700 /home/$1
