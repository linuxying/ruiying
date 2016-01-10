#!/bin/bash
#version: 2 
#date:2015-01-06
#mail:512331228@qq.com

#set yum
echo "###################yum conf####################"
cd /etc/yum.repos.d/
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo_$(date +%F).bak
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo
mv CentOS6-Base-163.repo CentOS-Base.repo
yum clean all
yum makecache
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-*
yum update -y

#install software
yum install -y lrzsz dos2unix tree

#update time
echo "#############update time################" >/var/spool/cron/root 
echo "*/5 * * * * /usr/sbin/ntpdate time.nist.gov >/dev/null 2>&1" >>/var/spool/cron/root

###############stop iptables and disabled#################
/etc/init.d/iptables stop
sed -i "s#^SELINUX=.*\$#SELINUX=disabled#g" /etc/selinux/config 

###############change ulimit###################
echo "* - nofile 65535" >>/etc/security/limit.conf

#echo "###############delete temporary  file#####################"
#echo "00 00 * * * find  /var/spool/clientmqueue/ -type f  |xargs rm -rf >/dev/null 2>&1" >>/var/spool/cron/root

##############delete start session####################
#>/etc/redhat-release
#>/etc/issue 

##############lang#################################
cat >/etc/sysconfig/i18n <<KKK
#LANG="en_US.UTF-8"
#SYSFONT="latarcyrheb-sun16"
LANG="zh_CN.GB2312"
SUPPORTED="zh_CN.UTF-8:zh_CN:zh:en_US.UTF-8:en_us:en"
SYSFONT="latarcyrheb-sun16"
KKK

##############kernel ##############################
cat >> /etc/sysctl.conf <<EOF
kernel.shmall = 268435456
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_keepalive_time = 1800
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_mem = 786432 1048576 1572864
net.core.wmem_max = 873200
net.core.rmem_max = 873200
net.ipv4.tcp_wmem = 8192 436600 873200
net.ipv4.tcp_rmem = 32768 436600 873200
net.core.somaxconn = 256
net.core.netdev_max_backlog = 1000
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_retries2 = 5
net.ipv4.tcp_keepalive_intvl = 30
net.ipv4.tcp_keepalive_probes = 3
net.ipv4.conf.lo.arp_ignore = 0
net.ipv4.conf.lo.arp_announce = 0
net.ipv4.conf.all.arp_ignore = 0
net.ipv4.conf.all.arp_announce = 0
net.ipv4.tcp_sack = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_window_scaling = 1
EOF
/sbin/sysctl -p >/dev/null 2>&1

################change  ssh port#####################
cat >> /etc/ssh/sshd_config <<EOF
Port 52113
PermitRootLogin no
PermitEmptyPasswords no
UseDNS no
EOF
/etc/init.d/sshd restart

################Service optimization###################
for A in `chkconfig --list|grep 3:on|awk '{print $1}'`
do 
    chkconfig $A off 
done
for B in crond irqbalance rsyslog sshd network
do 
    chkconfig $B --level 3 on 
done

#useradd 
useradd liuruiying
echo "liuruiying"|passwd --stdin liuruiying && history -c
echo "liuruiying   ALL=(ALL)  NOPASSWD: ALL">>/etc/sudoers

#mkdir dir
mkdir /home/liuruiying/tools -p
mkdir /data 
mkdir /backup
 
