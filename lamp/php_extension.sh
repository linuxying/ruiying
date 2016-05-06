#!/bin/sh

Tools=/home/test/tools

Php_path=/application/php
Mysql_path=/application/mysql


function Check_exten(){
    cd $Tools
    [ ! -f memcache-3.0.8.tgz ] && echo -e "\033[31mPackage memcache no found.\033[0m" && exit
    [ ! -f eaccelerator-eaccelerator-42067ac.tar.gz ] && echo -e "\033[31mPackage eaccelerator no found.\033[0m" && exit
    [ ! -f PDO_MYSQL-1.0.2.tgz ] && echo -e "\033[31mPackage PDO_MYSQL no found.\033[0m" && exit
    [ ! -f ImageMagick-6.9.3-10.tar.gz ] && echo -e "\033[31mPackage ImageMagick no found.\033[0m" && exit
    [ ! -f imagick-3.4.2.tgz ] && echo -e "\033[31mPackage imagick no found.\033[0m" && exit

}

function Install_exten(){
    cd $Tools
    #install memcache
    tar zxf memcache-3.0.8.tgz
    cd memcache-3.0.8/
    $Php_path/bin/phpize
    ./configure --with-php-config=$Php_path/bin/php-config
    make && make install
    if [ $? -ne 0 ];then
        echo "Install memcache failed. Please check log."
        exit
    fi
    cd ..
    
    #安装eaccelerator php加速
    #tar zxf  eaccelerator-eaccelerator-42067ac.tar.gz 
    #cd eaccelerator-eaccelerator-42067ac/
    #$Php_path/bin/phpize
    #./configure --enable-eaccelerator=shared  --with-php-config=$Php_path/bin/php-config
    #make && make install
    #if [ $? -ne 0 ];then
    #    echo "Install eaccelerator failed. Please check log."
    #    exit
    #fi
    #cd ..

    #安装PDO_MYSQL(数据库连接的支持)
    tar zxf PDO_MYSQL-1.0.2.tgz
    cd PDO_MYSQL-1.0.2/
    $Php_path/bin/phpize
    ./configure --with-php-config=$Php_path/bin/php-config --with-pdo-mysql=$Mysql_path
    ln -s /application/mysql/include/* /usr/local/include/
    make && make install
    if [ $? -ne 0 ];then
        echo "Install PDO-MYSQL failed. Please check log."
        exit
    fi
    cd ..

    #安装ImageMagick是Linux下非常强大的图象处理函数与GD类似.
    tar zxf ImageMagick-6.9.3-10.tar.gz 
    cd ImageMagick-6.9.3-10/
    ./configure
    make && make install
    if [ $? -ne 0 ];then
        echo "Install ImageMagick failed. Please check log."
        exit
    fi
    cd ..

    #安装imagick(连接PHP和ImageMagick的通道)
    tar zxf imagick-3.4.2.tgz
    cd imagick-3.4.2/
    $Php_path/bin/phpize
    ./configure --with-php-config=$Php_path/bin/php-config
    make && make install
    if [ $? -ne 0 ];then
        echo "Install imagick failed. Please check log."
        exit
    fi
    cd ..
    echo -e "\033[32m############Install successed.###############\033[0m"
}

function Run(){
    Check_exten
    Install_exten
}


Run
