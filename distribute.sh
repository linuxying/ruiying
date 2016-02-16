#!/usr/bin
#author:linuxliu
#mail:512331228@qq.com
#version 1
. /etc/init.d/functions


if [ $# -ne 2 ]
then
    echo "$0 file dir"
    exit
fi


for ip in `cat iplist`
do
    rsync -avzP $1 -e 'ssh -t -p 22' test@$ip:~ 
    ssh -t -p 22 test@$ip sudo rsync -avzP $1 $2 
    if [ $? -eq 0 ]
    then
        action $ip /bin/true
    else
        action $ip /bin/false
    fi
done
