#!/bin/bash
#File Name: install_php.sh
#Author:linuxliu 
#Mail:linuxliu_ry@qq.com 
#Created Time: 2016年02月29日 星期一 23时01分39秒

#php version
PhpVersion=php-5.6.18.tar.gz
PhpVersion1=php-5.5.32.tar.gz
PhpVersion2=php-5.4.45.tar.gz
PhpVersion3=php-5.3.29.tar.gz


#install path
InstallPath=/application




function install_php(){
    if [ ! -d /application ];then
	    mkdir /application
        echo "Start Installing PHP"
        if [ $PHP_version -eq 1 ]; then
            cd $cur_dir/untar/$PHPVersion
        elif [ $PHP_version -eq 2 ]; then
            cd $cur_dir/untar/$PHPVersion2
            # Add PHP5.3 patch
            patch -p1 < $cur_dir/php5.3.patch
        elif [ $PHP_version -eq 3 ]; then
            cd $cur_dir/untar/$PHPVersion3
        elif [ $PHP_version -eq 4 ]; then
            cd $cur_dir/untar/$PHPVersion4
        elif [ $PHP_version -eq 5 ]; then
            cd $cur_dir/untar/$PHPVersion5
        fi
	fi
        ./configure \
        --prefix=/usr/local/php \
        --with-apxs2=/usr/local/apache/bin/apxs \
        --with-config-file-path=/usr/local/php/etc \
        --with-mysql=/usr/local/mysql \
        --with-mysqli=/usr/local/mysql/bin/mysql_config \
        --with-pcre-dir=/usr/local/pcre \
        --with-iconv-dir=/usr/local/libiconv \
        --with-mysql-sock=/tmp/mysql.sock \
        --with-config-file-scan-dir=/usr/local/php/php.d \
        --with-mhash=/usr \
        --with-icu-dir=/usr/local \
        --with-bz2 \
        --with-curl \
        --with-freetype-dir \
        --with-gd \
        --with-gettext \
        --with-gmp=/usr/local \
        --with-jpeg-dir \
        --with-imap \
		--with-imap-ssl \
		--with-kerberos \
        --with-ldap \
        --with-ldap-sasl \
        --with-mcrypt \
        --with-openssl \
        --without-pear \
        --with-pdo-mysql \
        --with-png-dir \
        --with-readline \
        --with-xmlrpc \
        --with-xsl \
        --with-zlib \
        --enable-bcmath \
        --enable-calendar \
        --enable-ctype \
        --enable-dom \
        --enable-exif \
        --enable-ftp \
        --enable-gd-native-ttf \
        --enable-intl \
        --enable-json \
        --enable-mbstring \
        --enable-pcntl \
        --enable-session \
        --enable-shmop \
        --enable-simplexml \
        --enable-soap \
        --enable-sockets \
        --enable-tokenizer \
        --enable-wddx \
        --enable-xml \
        --enable-zip 
        --enable-fileinfo
