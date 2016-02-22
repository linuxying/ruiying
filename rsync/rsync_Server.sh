#!/bin/sh
#author linuxliu


User=`whoami`
if [ $User = 'root' ];then
    echo "Welcome run this scripts!"
else
    echo "must be run this scripts as root£¡"
    exit
fi

Bak_user=rsync_backup
Hosts_allow=10.0.0.0/24
Password=123456
Count=`rpm -qa|grep rsync|wc -l`
if [ $Count -ge 1 ];then
    cat >/etc/rsyncd.conf<<EOF
#Rsync server
#author linuxliu
uid = root
gid = root
use chroot = no
max connections = 5
timeout = 600
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
ignore errors
read only = false
list = false
hosts allow = $Hosts_allow
hosts deny = 0.0.0.0/32
auth users = $Bak_user
secrets file = /etc/rsync.password
#####################################
[www]
comment = www bak
path = /data/www/www/
#####################################
EOF
else
    yum install -y rsync
    if [ $Count -ge 1 ];then
        cat >/etc/rsyncd.conf<<EOF
#Rsync server
#author linuxliu
uid = root
gid = root
use chroot = no
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
read only = false
list = false
hosts allow = 10.0.0.0/24
hosts deny = 0.0.0.0/32
auth users = rsync_backup
secrets file = /etc/rsync.password
################################
[www]
comment = www bak
path = /data/www/www/
################################
EOF
    fi
fi

#rsync.password
echo "$Bak_user:$Password" >/etc/rsync.password
chmod 600 /etc/rsync.password
