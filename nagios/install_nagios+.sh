cd /home/test/tools/
useradd nagios
groupadd nagcmd
usermod -a -G nagcmd nagios
tar zxf nagios-4.1.1.tar.gz 
tar zxf nagios-plugins-2.1.1.tar.gz 
cd nagios-4.1.1
./configure --with-command-group=nagcmd 
make all
make install 
make install-init
make install-config
make install-commandmode
make install-webconf
cp -R contrib/eventhandlers/ /usr/local/nagios/libexec/
chown -R nagios.nagios /usr/local/nagios/libexec/eventhandlers/
/usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg 
/etc/init.d/nagios start
/etc/init.d/httpd start
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
cd ..
cd nagios-plugins-2.1.1
./configure --with-nagios-user=nagios --with-nagios-group=nagios
make
make install
chkconfig --add nagios
chkconfig --level 35 nagios on
chkconfig --add httpd
chkconfig --level 35 httpd on

tar zxf pnp4nagios-0.6.25.tar.gz 
yum install -y rrdtool rrdtool-perl 
cd pnp4nagios-0.6.25
./configure 
make all
yum install -y rrdtool rrdtool-perl perl-Time-HiRes
./configure 
make all
make fullinstall
mv /usr/local/pnp4nagios/share/install.php /usr/local/pnp4nagios/share/install.php.ignore
ln -s /usr/local/pnp4nagios/ /var/www/html/pnp4nagios

#install nagios-plugins
/usr/sbin/useradd nagios
tar xzf nagios-plugins-1.4.6.tar.gz
cd nagios-plugins-1.4.6
./configure
make
make install
chown nagios.nagios /usr/local/nagios
chown -R nagios.nagios /usr/local/nagios/libexec

#install nrpe
tar xzf nrpe-2.8.tar.gz
cd nrpe-2.8
./configure
make all
make install-plugin
make install-daemon
make install-daemon-config
#nagios4.X 不兼容问题，用Bulk Mode模式官方配置地址http://docs.pnp4nagios.org/pnp-0.6/config#bulk_mode
#参考文章http://coosh.blog.51cto.com/6334375/1741413