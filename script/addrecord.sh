#! /bin/bash

echo -e "update add $1 86400 a $2\nsend\nquit\n" | nsupdate -k /etc/rndc.key
nslookup $1
