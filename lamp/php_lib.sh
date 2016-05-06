******************************************************
* Author : Linuxliu
* Email : 512331228@qq.com
* Last modified :2016-05-06 19:23
* Filename :php_lib.sh
* Description :
******************************************************
#!/bin/sh
#编译安装PHP所需的支持库：

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
