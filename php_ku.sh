#编译安装PHP所需的支持库：

tar zxf pcre-8.38.tar.gz 
cd pcre-8.38
./configure 
make
make install
cd ..
tar zxf nginx-1.9.15.tar.gz
cd nginx-1.9.15
./configure --user=nginx --group=nginx --prefix=/application/nginx-1.9 --with-http_stub_status_module --with-http_ssl_module
make && make install
cd ..
ln -s /usr/local/lib/libpcre.so.1 /usr/lib64/

#nginx安装完成，fastcgi和php-fpm，php扩展未安装，mysql，php未安装

##php扩展安装
cd /home/test/tools/

tar zxf libiconv-1.14.tar.gz 
cd libiconv-1.14
./configure 
make && make install
cd ..

tar zxf libmcrypt-2.5.8.tar.gz 
cd libmcrypt-2.5.8
./configure && make && make install
/sbin/ldconfig 
cd libltdl/
./configure --enable-ltdl-install
make && make install
cd ../..

tar zxf mhash-0.9.9.9.tar.gz 
cd mhash-0.9.9.9
./configure && make && make install
make
make install
cd ..


ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1

tar zxf mcrypt-2.6.8.tar.gz 
cd mcrypt-2.6.8
/sbin/ldconfig 
./configure 
make
make install
cd ..
