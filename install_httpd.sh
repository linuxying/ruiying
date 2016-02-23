#!/bin/sh
#author linuxliu


#software version
apacheVersion='httpd-2.4.18'
aprVersion='apr-1.5.2'
aprutilVersion='apr-util-1.5.4'
pcreVersion='pcre-8.38'
#tools dir
Toolsdir=/home/test/tools



User=`whoami`
if [ $User != 'root' ];then
    echo "must be run this scripts as root£¡"
    exit
fi


function Download_file(){
    cd $Toolsdir
    [ ! -f $aprVersion.tar.gz ] && wget http://mirrors.noc.im/apache//apr/$aprVersion.tar.gz 
    if [ $? -ne 0 ];then
        echo "Error:$aprVersion.tar.gz is download false."
    fi
    [ ! -f $aprutilVersion.tar.gz ] && wget http://mirrors.noc.im/apache//apr/$aprutilVersion.tar.gz
    if [ $? -ne 0 ];then
        echo "Error:$aprVersion.tar.gz is download false."
    fi
    [ ! -f $apacheVersion.tar.gz ] && wget http://apache.fayea.com/httpd/$apacheVersion.tar.gz
    if [ $? -ne 0 ];then
        echo "Error:$AprVersion.tar.gz is download false."
    fi
}

#apr install
function install_apr(){
    tar zxf $aprVersion.tar.gz
    cd $aprVersion
    ./configure --prefix=/usr/local/apr && make && make install >>/app/logs/aprinstall.log
    if [ $? -ne 0 ];then
        echo "error ,please check log file."
        exit 1
    else
        cd ..
        echo -e "\033[32mapr install ok.\033[0m"
	sleep 5
    fi
}

#apr-util install
function install_aprutil(){
    tar zxf $aprutilVersion.tar.gz
    cd $aprutilVersion
    ./configure --prefix=/usr/local/apr-util --with-apr=/usr/local/apr/bin/apr-1-config && make && make install >>/app/logs/aprinstall.log
    if [ $? -ne 0 ];then
        echo "error ,please check log file."
	exit 1
    else
        cd ..
        echo -e "\033[32maprutil install ok.\033[0m"
	sleep 3
    fi	
}

#pcre install
function install_pcre(){
   tar zxf $pcreVersion.tar.gz
   cd $pcreVersion
   ./configure --prefix=/usr/local/pcre && make && make install >>/app/logs/pcreinstall.log
   if [ $? -ne 0 ];then
       echo "error ,please check log file."
       exit 1
   else
       cd ..
       echo -e "\033[32maprutil install ok.\033[0m"
       sleep 3
   fi
}

#apache install
function install_apache(){
    yum install -y zlib-devel
    tar zxf $apacheVersion.tar.gz
    cd $apacheVersion
    ./configure \
    --prefix=/application/$apacheVersion \
    --enable-deflate \
    --enable-expires \
    --enable-headers \
    --enable-modules=most \
    --enable-so \
    --with-mpm=worker \
    --enable-rewrite \
    --with-apr=/usr/local/apr \
    --with-apr-util=/usr/local/apr-util/ \
    --with-pcre=/usr/local/pcre  >>/app/logs/apacheinstall.log
    make && make install
    if [ $? -ne 0 ];then
        echo "error ,please check log file."
        exit 1
    else
        cd ..
        echo -e "\033[32mapache install success.\033[0m"
	sleep 5
    fi
}

function run_apache(){
#    Download_file
    install_apr
    install_aprutil
    install_pcre
    install_apache
}


run_apache
