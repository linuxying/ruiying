#!/bin/sh

MysqlVersion=mysql-5.5.47
MysqlVersion1=mysql-5.6.29
Toolsdir=/home/test/tools
Installdir=/application
Logdir=/app/logs
PORT=3306
Datadir=/data/$Port/data
Confdir=/data/$Port

#yum install software
yum install -y  ncurses-devel autoconfig automake gcc gcc-c++ cmake


#mkdir
mkdir $Datadir -p


#mysql version choose
while true
do
clear
#choice mysql version
echo -e "\033[32mPlease choose a version of the PHP:\033[0m"
echo -e "\t\033[32m1.Install $MysqlVersion\033[0m"
echo -e "\t\033[32m2.Install $MysqlVersion1\033[0m"
read -p "Please input you choice:(Default:2):" Mysql_Version
[ -z "$Mysql_Version" ] && Mysql_Version=3
case $Mysql_Version in
    1|2)
    echo "You choose = $Mysql_Version"
    break
    ;;
    *)
    echo "Input error: please input 1 or 2"
esac
done

#mysql install function 
function install_mysql(){
    if [ $Mysql_Version == 1 ];then
        cd $Toolsdir
        echo "Starting install ${MysqlVersion}"
        if [ ! -f ${MysqlVersion}.tar.gz ];then
            wget http://mirrors.sohu.com/mysql/MySQL-5.5/${MysqlVersion}.tar.gz
            tar zxf ${MysqlVersion}.tar.gz
            cd ${MysqlVersion}
        else
            tar zxf ${MysqlVersion}.tar.gz
            cd ${MysqlVersion}
        fi
		/usr/sbin/groupadd mysql
		/usr/sbin/useradd -s /sbin/nologin -M -g mysql mysql
		if [ ! -d $Datadir ];then
			mkdir -p $Datadir
			chown -R mysql.mysql $Datadir
		fi
		if [ ! -d $Installdir ];then
			mkdir -p $Installdir
		fi
		cmake \
		-DCMAKE_INSTALL_PREFIX=$Installdir/${MysqlVersion} \
		-DMYSQL_DATADIR=$Datadir \
		-DMYSQL_UNIX_ADDR=$Confdir/mysql.sock \
		-DDEFAULT_CHARSET=utf8 \
		-DDEFAULT_COLLATION=utf8_general_ci \
		-DWITH_EXTRA_CHARSETS=complex \
		-DWITH_INNOBASE_STORAGE_ENGINE=1 \
		-DWITH_READLINE=1 \
		-DENABLED_LOCAL_INFILE=1 \
		-DWITH_PARTITION_STORAGE_ENGINE=1 \
		-DWITH_FEDERATED_STORAGE_ENGINE=1 \
		-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
		-DWITH_MYISAM_STORAGE_ENGINE=1 \
		-DWITH_EMBEDDED_SERVER=1
		make
		make install
		if [ $? -ne 0 ];then
			echo -e "\033[31mInstall mysql failed.\033[0m "
		fi
        ln -s $Installdir/${MysqlVersion} $Installdir/mysql 
        cp  support-files/my-small.cnf  $Confdir
    elif [ $Mysql_Version == 2 ];then
        cd $Toolsdir
        echo "Starting install ${MysqlVersion1}"
        if [ ! -f ${MysqlVersion1}.tar.gz ];then
            wget http://mirrors.sohu.com/mysql/MySQL-5.6/${MysqlVersion1}.tar.gz
            tar zxf ${MysqlVersion1}.tar.gz
            cd ${MysqlVersion1}
        else
            tar zxf ${MysqlVersion1}.tar.gz
            cd ${MysqlVersion1}
        fi
		/usr/sbin/groupadd mysql
		/usr/sbin/useradd -s /sbin/nologin -M -g mysql mysql
		if [ ! -d $Datadir ];then
			mkdir -p $Datadir
			chown -R mysql.mysql $Datadir
		fi
		if [ ! -d $Installdir ];then
			mkdir -p $Installdir
		fi
		cmake \
		-DCMAKE_INSTALL_PREFIX=$Installdir/${MysqlVersion1} \
		-DMYSQL_DATADIR=$Datadir \
		-DMYSQL_UNIX_ADDR=$Confdir/mysql.sock \
		-DDEFAULT_CHARSET=utf8 \
		-DDEFAULT_COLLATION=utf8_general_ci \
		-DWITH_EXTRA_CHARSETS=complex \
		-DWITH_INNOBASE_STORAGE_ENGINE=1 \
		-DWITH_READLINE=1 \
		-DENABLED_LOCAL_INFILE=1 \
		-DWITH_PARTITION_STORAGE_ENGINE=1 \
		-DWITH_FEDERATED_STORAGE_ENGINE=1 \
		-DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
		-DWITH_MYISAM_STORAGE_ENGINE=1 \
		-DWITH_EMBEDDED_SERVER=1
		make
		make install
		if [ $? -ne 0 ];then
			echo -e "\033[31mInstall mysql failed.\033[0m "
		fi
        ln -s $Installdir/${MysqlVersion1} $Installdir/mysql 
        cp  support-files/my-small.cnf  $Confdir
	fi
   
}    


function Confmysql(){
    echo "#################my.cnf#####################"
    cat > $Confdir/my.cnf <<EOF
    [client]
    Port= $PORT
    socket= $Confdir/mysql.sock
    [mysql]
    no-auto-rehash
    [mysqld]
    useradd= mysql
    Port= $PORT
    socket= $Confdir/mysql.sock
    basedir= $Installdir/mysql
    Datadir= $Datadir
    skip-external-locking
    key_buffer_size = 16K
    max_allowed_packet = 1M
    table_open_cache = 4
    sort_buffer_size = 64K
    read_buffer_size = 256K
    read_rnd_buffer_size = 256K
    net_buffer_length = 2K
    thread_stack = 128K
    server-id= 1
    log-error = $Confdir/mysql3306.err
    pid-file = $Confdir/mysqld.pid
    log-bin = $Confdir/mysql-bin
    relay-log = $Confdir/relay-bin
    relay-log-info-file = $Confdir/relay-log.info
    [mysqldump]
    quick
    max_allowed_packet = 16M
    [mysql]
    no-auto-rehash
    [myisamchk]
    key_buffer_size = 8M
    sort_buffer_size = 8M
    [mysqlhotcopy]
    interactive-timeout
EOF
    chown -R mysql.mysql $Confdir
    chmod 700 $Confdir
    echo 'export PATH=$PATH:/application/mysql/bin ' >>/etc/profile 
    . /etc/profile 
}

function Run_mysql(){
    install_mysql
    Confmysql
}


Run_mysql
