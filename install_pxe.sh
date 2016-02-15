#!/bin/sh
#author:linuxliu
#mail:512331228@qq.com

#make sure only root can run our script
rootness(){
   if [[ $UID -ne 0 ]]
   then
       echo "Error:This script must be run as root!" 1>&2
       exit 1
   fi
}



#install nfs
install_nfs(){
    [ ! -d /data/sys ] && mkdir -p /data/sys/
    mount /dev/cdrom /mnt/
    echo -e "\033[33mThis process lastest a few minutes,please wait for a moment.\033[0m"
    cp -a /mnt/* /data/sys/

    if [ `rpm -qa|grep nfs|wc -l` = 0 ]
    then
        yum install -y nfs-utils
        echo "/data/sys 10.0.0.0/24(ro,sync)" >/etc/exports
    else
        echo "/data/sys 10.0.0.0/24(ro,sync)" >/etc/exports
    fi
	
    #start nfs
    /etc/init.d/rpcbind start
    /etc/init.d/nfs start
    chkconfig nfs on
    chkconfig rpcbind on
    echo "/etc/init.d/rpcbind start">>/etc/rc.local 
    echo "/etc/init.d/nfs start">>/etc/rc.local
    echo "nfs installation completed." >>/data/sys/install_log.txt
    sleep 5
}


#install tftp
install_tftp(){
    yum install -y tftp-server
    sed -i "s/`grep "disable" \/etc\/xinetd.d\/tftp`/disable = no/g" /etc/xinetd.d/tftp 
    /etc/init.d/xinetd start
    echo "/etc/init.d/xinetd start">>/etc/rc.local
    chkconfig xinetd on
}


#pxe bootstrap
install_boot(){
    [ ! -f /usr/share/syslinx/pxelinux.0 ] && yum install -y syslinux
    Bootpath=/var/lib/tftpboot
    cp /usr/share/syslinux/pxelinux.0 $Bootpath/
    cp /mnt/images/pxeboot/vmlinuz  $Bootpath/
    cp /mnt/images/pxeboot/initrd.img  $Bootpath/
    cd $Bootpath
    mkdir -p pxelinux.cfg
    cp /mnt/isolinux/isolinux.cfg  $Bootpath/pxelinux.cfg/default
}

#install dhcp
install_dhcp(){
    yum install -y dhcp 
cat >/etc/dhcp/dhcpd.conf<<EOF
ddns-update-style none;
default-lease-time 600;
max-lease-time 7200;
log-facility local7;
subnet 10.0.0.0 netmask 255.255.255.0 {
range dynamic-bootp 10.0.0.100 10.0.0.200;
next-server 10.0.0.5;
filename "/data/sys/kickstart/ks.cfg";
next-server 10.0.0.5;
filename "/var/lib/tftpboot/pxelinux.0";
}   
EOF
    /etc/init.d/dhcpd start
    chkconfig dhcpd on
    echo "/etc/init.d/dhcpd start">>/etc/rc.local
}


#4.5 kisckstart
#config kisckstart
Kisckstart(){
    wget https://github.com/linuxying/ruiying/archive/master.zip
    unzip master.zip
    cd ruiying-master
    mkdir /data/sys/kickstart
    cp ks.cfg /data/sys/kickstart/ks.cfg
    chmod 644 /data/sys/kickstart/ks.cfg 
}

Restart(){
  /etc/init.d/rpcbind restart
  /etc/init.d/nfs restart
  /etc/init.d/xinetd restart
  /etc/init.d/dhcpd restart
}

main(){
    rootness
    install_nfs
    install_tftp
    install_boot
    install_dhcp
    Kisckstart
    Restart
}

main
