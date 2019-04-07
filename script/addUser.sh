#! /bin/bash

# How to run is : addUser.sh <namaUser> <passwordUser>
useradd -m -s /bin/bash $1
echo -e "$2\n$2\n" | passwd $1
echo "$1" >> /etc/vsftpd.userlist
chmod 0770 /home/$1
chgrp -R gluster /home/$1
usermod -g gluster $1

cat << EOF > /opt/nginxconf/$1.conf

server {
    listen       80;
    server_name  $1.ku;
    root   /usr/share/nginx/html/$1/;
    index index.php  index.html index.htm;
    

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html/;
    }
    location / {
        try_files \$uri \$uri/ =404;
    }
   
    error_page 404 /404.html;
    location = /404.html {
	root /usr/share/nginx/html;
    }

    location ~ [^/]\.php(/|$) {
    fastcgi_split_path_info  ^(.+\.php)(/.+)$;
    fastcgi_index            index.php;
    fastcgi_pass             unix:/var/run/php-fpm.sock;
    include                  fastcgi_params;
    fastcgi_param   PATH_INFO      \$fastcgi_path_info;
    fastcgi_param   SCRIPT_FILENAME /usr/share/nginx/html/$1\$fastcgi_script_name;
   }
}


EOF

/opt/script/addrecord.sh $1.ku 192.168.220.128
/opt/script/addrecord.sh ftp.$1.ku 192.168.220.128
/opt/script/addrecord.sh db.$1.ku 192.168.220.128
