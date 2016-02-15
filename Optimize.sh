#!/bin/sh
#author:linuxliu
#mail:linuxliu_ry


#check user
if [ "`whoami`" != root ]
then
    echo -e "\033[33m Please run this script as root!\033[0m"
    exit
fi

#continue or break
yn="n"
echo -e "\033[32mwhether to continue? default is N.\033[0m"
read -p "please input [y/n]" yn
if [ "$yn" != "y" -a "$yn" != "Y" ]
then
    echo "ByeBye~~~!"
    exit
fi

#print process
b=''
for ((i=0;$i<=100;i+=2))
do
        printf "progress:[%-50s]%d%%\r" $b $i
        sleep 0.1
        b=#$b
done
echo

#check os
Version=`cat /etc/redhat-release |awk  -F '[ .]' '{print $3}'`
Release=`cat /etc/redhat-release |awk  '{print $1}'`

if [ $Version != '6' -o $Release != 'CentOS' ]
then
    echo -e "\033[33mThis script can only run on CentOS.\033[0m"
    exit
fi

#print os
echo -e "\033[32m+------------------------------+\033[0m"
echo -e "\033[32myou os is $Release $Version.\033[0m"
echo -e "\033[32m      strat optimize ...    \033[0m"
echo -e "\033[32m+------------------------------+\033[0m"


#config yum repo
yum_update(){
#make the 163.com as the default yum repo
if [ ! -e "/etc/yum.repos.d/bak" ]; then
    mkdir /etc/yum.repos.d/bak
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/bak/CentOS-Base.repo.bak_%w
fi
 
#add
wget http://mirrors.163.com/.help/CentOS6-Base-163.repo -O /etc/yum.repos.d/CentOS-Base.repo
 
#add the third-party repo
#rpm -Uvh http://download.Fedora.RedHat.com/pub/epel/6/x86_64/epel-release-6-5.noarch.rpm 
rpm -Uvh ftp://ftp.muug.mb.ca/mirror/centos/6.7/extras/x86_64/Packages/epel-release-6-8.noarch.rpm
#add the epel
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
 
#add the rpmforge
rpm -Uvh http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.x86_64.rpm
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag
 
#update the system
yum clean all && yum makecache
yum -y update glibc\*
yum -y update yum\* rpm\* python\* 
yum -y update
yum install -y lrzsz tree dos2unix
echo -e "\033[32m yum update ok \033[0m"
sleep 1
}


#update time
update_time(){
echo -e "\033[32m update time\033[0m "
echo "*/5 * * * * /usr/sbin/ntpdate time.windows.com > /dev/null 2>&1 " >>/var/spool/cron/root
/etc/init.d/crond restart
}


#set the file limit
limits_config(){
    echo "* - nofile 65535" >>/etc/security/limit.conf
}

#tune kernel
sysctl_config(){
if [ ! -f "/etc/sysctl.conf.bak" ]
then
    cp /etc/sysctl.conf /etc/sysctl.conf.bak
fi

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
}

#chage i18n
i18n_config(){
cat >/etc/sysconfig/i18n <<EOF
#LANG="en_US.UTF-8"
#SYSFONT="latarcyrheb-sun16"
LANG="zh_CN.GB2312"
SUPPORTED="zh_CN.UTF-8:zh_CN:zh:en_US.UTF-8:en_us:en"
SYSFONT="latarcyrheb-sun16"
EOF
}

#stop iptables and selinux
iptables_config(){
/etc/init.d/iptables stop
sed -i "s#^SELINUX=.*\$#SELINUX=disabled#g" /etc/selinux/config 
}

#ssh config
ssh_config(){
cat >> /etc/ssh/sshd_config <<EOF
Port 52113
PermitRootLogin no
PermitEmptyPasswords no
UseDNS no
EOF
/etc/init.d/sshd restart
}

#Close unused service
#注意此处有的是显示英文on，有的显示的是启用
service_config(){
for un_service in `chkconfig --list|grep 3:启用|awk '{print $1}'`
do
    chkconfig ${un_service} off
done
for service in crond irqbalance rsyslog sshd network
do
    chkconfig $service --level 3 on 
done
}

#other config 
other_config(){
#useradd 注意此处test修改为你自己的用户名和密码
useradd test
echo "test"|passwd --stdin test && history -c
echo "test   ALL=(ALL)  NOPASSWD: ALL">>/etc/sudoers

#mkdir dir
mkdir /home/test/tools -p
mkdir /data 
mkdir /backup
mkdir -p /server/script
}

#ok
ok(){
cat << EOF
+-------------------------------------------------+
|               optimizer is done                 |
|   it's recommond to restart this server !       |
|                                                 |
|             Please Reboot system                |
+-------------------------------------------------+
EOF
}

main(){
    yum_update
    update_time
    limits_config
    sysctl_config
    i18n_config
    iptables_config
    ssh_config
    service_config
    other_config
    ok  
}

main
