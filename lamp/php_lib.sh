#!/bin/sh

#编译安装PHP所需的支持库：
#tar zxf pcre-8.38.tar.gz 
#cd pcre-8.38
#./configure 
#make
#make install
#cd ..

#tar zxf nginx-1.9.15.tar.gz
#cd nginx-1.9.15
#./configure --user=nginx --group=nginx --prefix=/application/nginx-1.9 --with-http_stub_status_module --with-http_ssl_module
#make && make install
#cd ..
#ln -s /usr/local/lib/libpcre.so.1 /usr/lib64/

#nginx安装完成，fastcgi和php-fpm，php扩展未安装，mysql，php未安装

##php扩展安装
#cd /home/test/tools/

Tools=/home/test/tools


echo -e "\033[32m#######################software version######################\033[0m"
echo -e "\033[32m#                                                           #\033[0m"
echo -e "\033[32m#                     libiconv-1.14.tar.gz                  #\033[0m"
echo -e "\033[32m#                     libmcrypt-2.5.8.tar.gz                #\033[0m"
echo -e "\033[32m#                     mhash-0.9.9.9.tar.gz                  #\033[0m"
echo -e "\033[32m#                     mcrypt-2.6.8.tar.gz                   #\033[0m"
echo -e "\033[32m#                                                           #\033[0m"
echo -e "\033[32m#############################################################\033[0m"

function check_package(){
    cd $Tools
    [ ! -f libiconv-1.14.tar.gz ] && echo "libiconv is no found" && exit
    [ ! -f libmcrypt-2.5.8.tar.gz ] && echo "libmcrypt is no found" && exit
    [ ! -f mhash-0.9.9.9.tar.gz  ] && echo "mhash is no found" && exit
    [ ! -f mcrypt-2.6.8.tar.gz  ] && echo "mhash is no found" && exit
}


function install(){
    cd /home/test/tools
    #install libiconv
    tar zxf libiconv-1.14.tar.gz 
    cd libiconv-1.14
    ./configure 
    make && make install
    if [ $? -ne 0 ];then
        echo "Install libiconv failed. Please check log."
        exit
    fi
    cd ..
    
    #install libmcrypt
    tar zxf libmcrypt-2.5.8.tar.gz 
    cd libmcrypt-2.5.8
    ./configure && make && make install
    if [ $? -ne 0 ];then
        echo "Install libmcrypt failed. Please check log."
        exit
    fi
    /sbin/ldconfig
    cd libltdl/
    ./configure --enable-ltdl-install
    make && make install
    if [ $? -ne 0 ];then
        echo "Install libltdl failed. Please check log."
        exit
    fi
    cd ../..    
     
    #install mhash
    tar zxf mhash-0.9.9.9.tar.gz
    cd mhash-0.9.9.9
    ./configure && make && make install
    make && make install
    if [ $? -ne 0 ];then
        echo "Install mhash failed. Please check log."
        exit
    fi
    cd ..
    
    #ln -s 
    ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
    ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
    ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
    ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
    ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
    ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
    ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
    ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
    ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
    
    #install mcrypt
    tar zxf mcrypt-2.6.8.tar.gz
    cd mcrypt-2.6.8
    /sbin/ldconfig
    ./configure
    make && make install
    if [ $? -ne 0 ];then
        echo "Install mhash failed. Please check log."
        exit
    fi
    cd ..
    
    echo -e "\033[32minstall successed.\033[0m"
}


check_package
install