#!/bin/sh

Install_dir=/application
Soft_dir=/home/test/tools

#php version 
PHPv1=php-5.6.19
PHPv2=php-5.5.33
PHPv3=php-5.4.45
PHPv4=php-5.3.29

#Check installation environment
[ -d /application/mysql  -a  -d /application/apache ] && echo "mysql and apapche  already installed. Next install php" || echo "error:mysql or apache no install."


#choose version
while true
do 
clear
echo "############################################"
echo "#  1.       PHPv1=php-5.6.19               #"
echo "#  2.       PHPv2=php-5.5.33               #"
echo "#  3.       PHPv3=php-5.4.45               #"
echo "#  4.       PHPv4=php-5.3.29               #"
echo "############################################"
read -p "Please input number(default 1):" Num
[ -z "$Num" ] && Num=1
case $Num in 
    1|2|3|4)
	echo "You choose is $Num."
	break
	;;
	*)
	echo "Error:Please input {1|2|3|4}"
esac
done

#Download  php
function Download_php(){
    cd $Soft_dir
    if [ $Num == 1 ];then
        [ ! -f $PHPv1.tar.gz ] && wget http://mirrors.sohu.com/php/$PHPv1.tar.gz
    elif [ $Num == 2 ];then
        [ ! -f $PHPv2.tar.gz ] && wget http://mirrors.sohu.com/php/$PHPv2.tar.gz
    elif [ $Num == 3 ];then
        [ ! -f $PHPv3.tar.gz ] && wget http://mirrors.sohu.com/php/$PHPv3.tar.gz
    else
        [ ! -f $PHPv4.tar.gz ] && wget http://mirrors.sohu.com/php/$PHPv4.tar.gz
    fi
    if [ $? -eq 0 ];then
        echo "Download_php success."
    fi
}

#Dependent environment 
function Yum_software(){
    yum install libmcrypt-devel readline-devel libicu-devel libc-client-devel zlib libxml openldap-devel libxslt-devel libjpeg freetype libpng gd curl zlib-devel libxml2-devel libjpeg-devel freetype-devel libpng-devel gd-devel curl-devel openssl openssl-devel gmp-devel -y
    cp -frp /usr/lib64/libldap* /usr/lib/
    ln -s /usr/lib64/libc-client.so /usr/lib/libc-client.so
}

#install php
function Install_php(){
     cd $Soft_dir
	 if [ $Num == 1 ];then
	    tar zxf $PHPv1.tar.gz
		cd $PHPv1
		./configure \
	    --prefix=/application/$PHPv1 \
	    --with-apxs2=/application/apache/bin/apxs \
	    --with-config-file-path=/application/$PHPv1/etc  \
	    --with-mysql=/application/mysql \
	    --with-mysqli=/application/mysql/bin/mysql_config  \
	    --with-pcre-dir=/usr/local/pcre  \
	    --with-iconv-dir=/usr/local/libiconv  \
	    --with-mysql-sock=/tmp/mysql.sock  \
	    --with-config-file-scan-dir=/application/$PHPv1/php.d  \
	    --with-mhash=/usr  \
	    --with-icu-dir=/usr/bin  \
	    --with-bz2  \
	    --with-curl \
	    --with-freetype-dir \
	    --with-gd  \
	    --with-gettext  \
	    --with-gmp=/usr/local  \
	    --with-jpeg-dir  \
	    --with-imap \
	    --with-imap-ssl  \
	    --with-kerberos \
	    --with-ldap \
	    --with-ldap-sasl  \
	    --with-mcrypt  \
	    --with-openssl   \
	    --without-pear   \
	    --with-pdo-mysql   \
	    --with-png-dir    \
	    --with-readline    \
	    --with-xmlrpc  \
	    --with-xsl \
	    --with-zlib \
	    --enable-bcmath  \
	    --enable-calendar \
	    --enable-ctype   \
	    --enable-dom  \
	    --enable-exif  \
	    --enable-ftp   \
	    --enable-gd-native-ttf   \
	    --enable-intl  \
	    --enable-json  \
	    --enable-mbstring \
	    --enable-pcntl \
	    --enable-session \
	    --enable-shmop \
	    --enable-simplexml  \
	    --enable-soap   \
	    --enable-sockets \
	    --enable-tokenizer \
	    --enable-wddx  \
	    --enable-xml  \
	    --enable-zip
		make && make install
		if [ $? -eq 0 ];then
		    echo "$PHPv1 install success."
		else
		    echo "error"
            exit
		fi
		ln -s /application/$PHPv1 /application/php
        cp -ap php.ini-production /application/php/lib/php.ini
     elif [ $Num == 2 ];then
	    tar zxf $PHPv2.tar.gz
		cd $PHPv2
		./configure \
	    --prefix=/application/$PHPv2 \
	    --with-apxs2=/application/apache/bin/apxs \
	    --with-config-file-path=/application/$PHPv2/etc  \
	    --with-mysql=/application/mysql \
	    --with-mysqli=/application/mysql/bin/mysql_config  \
	    --with-pcre-dir=/usr/local/pcre  \
	    --with-iconv-dir=/usr/local/libiconv  \
	    --with-mysql-sock=/tmp/mysql.sock  \
	    --with-config-file-scan-dir=/application/$PHPv2/php.d  \
	    --with-mhash=/usr  \
	    --with-icu-dir=/usr/bin  \
	    --with-bz2  \
	    --with-curl \
	    --with-freetype-dir \
	    --with-gd  \
	    --with-gettext  \
	    --with-gmp=/usr/local  \
	    --with-jpeg-dir  \
	    --with-imap \
	    --with-imap-ssl  \
	    --with-kerberos \
	    --with-ldap \
	    --with-ldap-sasl  \
	    --with-mcrypt  \
	    --with-openssl   \
	    --without-pear   \
	    --with-pdo-mysql   \
	    --with-png-dir    \
	    --with-readline    \
	    --with-xmlrpc  \
	    --with-xsl \
	    --with-zlib \
	    --enable-bcmath  \
	    --enable-calendar \
	    --enable-ctype   \
	    --enable-dom  \
	    --enable-exif  \
	    --enable-ftp   \
	    --enable-gd-native-ttf   \
	    --enable-intl  \
	    --enable-json  \
	    --enable-mbstring \
	    --enable-pcntl \
	    --enable-session \
	    --enable-shmop \
	    --enable-simplexml  \
	    --enable-soap   \
	    --enable-sockets \
	    --enable-tokenizer \
	    --enable-wddx  \
	    --enable-xml  \
	    --enable-zip
		make && make install
		if [ $? -eq 0 ];then
		    echo "$PHPv2 install success."
		else
		    echo "error"
            exit
		fi
		ln -s /application/$PHPv2/ /application/php
        cp -ap php.ini-production /application/php/lib/php.ini
	 elif [ $Num == 3 ];then
	    tar zxf $PHPv3.tar.gz
		cd $PHPv3
		./configure \
	    --prefix=/application/$PHPv3 \
	    --with-apxs2=/application/apache/bin/apxs \
	    --with-config-file-path=/application/$PHPv3/etc  \
	    --with-mysql=/application/mysql \
	    --with-mysqli=/application/mysql/bin/mysql_config  \
	    --with-pcre-dir=/usr/local/pcre  \
	    --with-iconv-dir=/usr/local/libiconv  \
	    --with-mysql-sock=/tmp/mysql.sock  \
	    --with-config-file-scan-dir=/application/$PHPv3/php.d  \
	    --with-mhash=/usr  \
	    --with-icu-dir=/usr/bin  \
	    --with-bz2  \
	    --with-curl \
	    --with-freetype-dir \
	    --with-gd  \
	    --with-gettext  \
	    --with-gmp=/usr/local  \
	    --with-jpeg-dir  \
	    --with-imap \
	    --with-imap-ssl  \
	    --with-kerberos \
	    --with-ldap \
	    --with-ldap-sasl  \
	    --with-mcrypt  \
	    --with-openssl   \
	    --without-pear   \
	    --with-pdo-mysql   \
	    --with-png-dir    \
	    --with-readline    \
	    --with-xmlrpc  \
	    --with-xsl \
	    --with-zlib \
	    --enable-bcmath  \
	    --enable-calendar \
	    --enable-ctype   \
	    --enable-dom  \
	    --enable-exif  \
	    --enable-ftp   \
	    --enable-gd-native-ttf   \
	    --enable-intl  \
	    --enable-json  \
	    --enable-mbstring \
	    --enable-pcntl \
	    --enable-session \
	    --enable-shmop \
	    --enable-simplexml  \
	    --enable-soap   \
	    --enable-sockets \
	    --enable-tokenizer \
	    --enable-wddx  \
	    --enable-xml  \
	    --enable-zip
		make && make install
		if [ $? -eq 0 ];then
		    echo "$PHPv3 install success."
		else
		    echo "error"
            exit
		fi
		ln -s /application/$PHPv3/ /application/php
        cp -ap php.ini-production /application/php/lib/php.ini
	 else
	    tar zxf $PHPv4.tar.gz
		cd $PHPv4
		./configure \
	    --prefix=/application/$PHPv4 \
	    --with-apxs2=/application/apache/bin/apxs \
	    --with-config-file-path=/application/$PHPv4/etc  \
	    --with-mysql=/application/mysql \
	    --with-mysqli=/application/mysql/bin/mysql_config  \
	    --with-pcre-dir=/usr/local/pcre  \
	    --with-iconv-dir=/usr/local/libiconv  \
	    --with-mysql-sock=/tmp/mysql.sock  \
	    --with-config-file-scan-dir=/application/$PHPv4/php.d  \
	    --with-mhash=/usr  \
	    --with-icu-dir=/usr/bin  \
	    --with-bz2  \
	    --with-curl \
	    --with-freetype-dir \
	    --with-gd  \
	    --with-gettext  \
	    --with-gmp=/usr/local  \
	    --with-jpeg-dir  \
	    --with-imap \
	    --with-imap-ssl  \
	    --with-kerberos \
	    --with-ldap \
	    --with-ldap-sasl  \
	    --with-mcrypt  \
	    --with-openssl   \
	    --without-pear   \
	    --with-pdo-mysql   \
	    --with-png-dir    \
	    --with-readline    \
	    --with-xmlrpc  \
	    --with-xsl \
	    --with-zlib \
	    --enable-bcmath  \
	    --enable-calendar \
	    --enable-ctype   \
	    --enable-dom  \
	    --enable-exif  \
	    --enable-ftp   \
	    --enable-gd-native-ttf   \
	    --enable-intl  \
	    --enable-json  \
	    --enable-mbstring \
	    --enable-pcntl \
	    --enable-session \
	    --enable-shmop \
	    --enable-simplexml  \
	    --enable-soap   \
	    --enable-sockets \
	    --enable-tokenizer \
	    --enable-wddx  \
	    --enable-xml  \
	    --enable-zip
		make && make install
		if [ $? -eq 0 ];then
		    echo "$PHPv4 install success."
		else
		    echo "error"
            exit
		fi
		ln -s /application/$PHPv4/ /application/php
        cp -ap php.ini-production /application/php/lib/php.ini
     fi
     echo "php install ok"

}

Download_php
Yum_software
Install_php
