#安装memcache
tar zxvf memcache-2.2.5.tgz
cd memcache-2.2.5/
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make
make install
cd ..

#安装eaccelerator php加速
tar jxvf eaccelerator-0.9.5.3.tar.bz2
cd eaccelerator-0.9.5.3/
/usr/local/php/bin/phpize
./configure --enable-eaccelerator=shared  --with-php-config=/usr/local/php/bin/php-config
make
make install
cd ..

#安装PDO_MYSQL(数据库连接的支持)
tar zxvf PDO_MYSQL-1.0.2.tgz
cd PDO_MYSQL-1.0.2/
/usr/local/php/bin/phpize
/configure --with-php-config=/usr/local/php/bin/php-config
with-pdo-mysql=/usr/local/mysql
make
make install
cd ..

#安装ImageMagick是Linux下非常强大的图象处理函数与GD类似.
tar zxvf ImageMagick.tar.gz
cd ImageMagick-6.5.1-2/
./configure
make
make install
cd ..

#安装imagick(连接PHP和ImageMagick的通道)
tar zxvf imagick-2.2.2.tgz
cd imagick-2.2.2/
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make
make install
cd ..


