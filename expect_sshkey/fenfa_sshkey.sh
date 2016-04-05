#!/usr/bin/bash

. /etc/init.d/functions

for ip in `cat iplist.txt`
do
    expect fenfa_sshkey.exp ~/.ssh/id_rsa.pub $ip >/dev/null 2>&1
    if [ $? -eq 0 ];then
        action "$ip" /bin/true
    else
        action "$ip" /bin/false
    fi
done
