 1.Optimize.sh 为系统优化脚本
 
 2.install_pxe.sh 为pxe无人值守安装服务器端安装脚本 
 
 3.default，dhcpd.conf，ks.cfg为pxe无人值守安装server端配置文件  
 
 4.process.sh 是打印进度条脚本

 5.distribute.sh 是简单批量分发文件的脚本，iplist是ip地址列表


配置规范：

 1.全网服务器，时间同步。
 
 2.所有服务器脚本放到/server/scripts目录中。
 
 3.所有服务器备份目录统一放在/data/backup目录中。
 
 4.所有开机需要自启动的服务，均放到/etc/rc.local中，并做好注释，相当于服务记录，方便重启或停机维护前查看记录。
 
 5.所有安装软件均安装到/application中，日志文件放到/app/logs中。
