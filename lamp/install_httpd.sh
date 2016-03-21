#!/bin/sh
#author linuxliu


#software version
apacheVersion='httpd-2.4.18'
aprVersion='apr-1.5.2'
aprutilVersion='apr-util-1.5.4'
pcreVersion='pcre-8.38'
#tools dir
Toolsdir=/home/test/tools
Confdir=/application/apache/conf 

mkdir /app/logs -p
mkdir /application 
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
    ln -s /application/$apacheVersion  /application/apache
}

function Confapache(){
    sed -i  "s/#Include conf\/extra\/httpd\-vhosts\.conf/Include conf\/extra\/httpd\-vhosts\.conf/g" $Confdir/httpd.conf
    cp -f $Confdir/httpd.conf $Confdir/httpd.conf.backup
    cp -f $Confdir/extra/httpd-vhosts.conf $Confdir/extra/httpd-vhosts.conf.backup
    sed -i  "s/User daemon/User apache/g" $Confdir/httpd.conf
    sed -i  "s/Group daemon/Group apache/g" $Confdir/httpd.conf
    sed -i "s/#ServerName www.example.com:80/ServerName 127.0.0.1:80/g" $Confdir/httpd.conf
    sed -i '\/AddType application\/x-compress \.Z/a AddType application\/x-httpd-php \.php \.php3' $Confdir/httpd.conf
    sed -i '\/AddType application\/x-compress \.Z/a AddType application\/x-httpd-php-source \.phps' $Confdir/httpd.conf
    sed -i  's/DirectoryIndex index.html/DirectoryIndex index.html index.php/g' $Confdir/httpd.conf
    mkdir /data/www/www -p
    useradd -s /sbin/nologin -M apache
    chown -R apache.apache /data/www/


    cat >$Confdir/extra/httpd-vhosts.conf <<EOF
    <VirtualHost *:80>
        ServerAdmin 512331228@qq.com 
        DocumentRoot "/data/www/www"
        ServerName www.liuruiying.com
        ServerAlias wwwapache01.liuruiying.com
        ErrorLog "/app/logs/wwwapache01.liuruiying.com-error_log"
        #CustomLog "|/usr/local/sbin/cronolog /app/logs/access_www_%Y%m%d.log" combined
        CustomLog "/app/logs/access_www_%Y%m%d.log" common
    </VirtualHost>

    <Directory "/data/www">
        AllowOverride None
        Options None
        Require all granted
    </Directory>
EOF
}


function run_apache(){
    Download_file
    install_apr
    install_aprutil
    install_pcre
    install_apache
    Confapache
}
