#!/bin/bash

mkdir -p /brick
gluster volume create ftpdata transport tcp server1.ku:/brick/ftpbrick force
gluster volume create nginxconf transport tcp server1.ku:/brick/nginxconf force
gluster volume start ftpdata
gluster volume start nginxconf
systemctl disable glusterservice
sed -i -e 's/glusterservice.service/ /g' /etc/systemd/system/home.mount
sed -i -e 's/glusterservice.service/ /g' /etc/systemd/system/opt-nginxconf.mount
rm -rf /opt/blibli /etc/systemd/system/glusterservice.service
