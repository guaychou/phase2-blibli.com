#! /bin/bash
# How to run is : addUser.sh <namaUser> <passwordUser> <email User> 
htpasswd -d -p -b /etc/vsftpd/ftpd.passwd $1 $(openssl passwd -1 -noverify $2)
echo "local_root=/home/$1" >> /etc/vsftpd/vsftpd_user_conf/$1
mkdir /home/$1
chmod 770 /home/$1
chown vsftpd:gluster /home/$1
echo  -e "CREATE USER \"$1\"@\"%\" IDENTIFIED BY \"$2\";\n" | mysql --user=root --password='Sukuchi0x01'
echo  -e "CREATE DATABASE  wordpress_$1 DEFAULT CHARACTER SET UTF8 COLLATE utf8_unicode_ci;\n" | mysql --user=root --password='Sukuchi0x01'
echo  -e "GRANT ALL PRIVILEGES ON wordpress_$1.* TO \"$1\"@\"%\" ;\n" | mysql --user=root --password='Sukuchi0x01'

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
python /opt/script/restartNginxClient.py
cp -RTf /opt/script/wordpress /home/$1
sed -i -e "s/namaUser/$1/g" /home/$1/wp-config.php
sed -i -e "s/namaPassword/$2/g" /home/$1/wp-config.php
curl -X POST --data "weblog_title=$1&user_name=$1&admin_password=$2&admin_password2=$2&admin_email=$3" http://$1.ku/wp-admin/install.php?step=2
sudo -u kevinchou bash -c "echo -e \"Your registration has been success\n\nYour Website: $1.ku\nFTP: ftp.$1.ku\nDatabase: db.$1.ku\n  Username: $1 \n Password: $2 \n  \nRegards,\nKevin\" | mailx -s \"Registration approved\" $3 "
