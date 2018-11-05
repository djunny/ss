#!/bin/bash
# 一键部署 php ss 脚本
if [[ "$(whoami)" != "root" ]]; then
    echo "please run this script as root !" >&2
    exit 1
fi

port="48888"
echo -n "please input ss port"
echo -n ",need large than 10000"
echo ",default [48888]: "
read rport
if [[ $rport > 10000 && "$rport" != "" ]]; then
   port="$rport"
fi

if [[ $port > 65534 ]]; then
   port=48888
fi


pass=`head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo ''`
echo -n"please input ss password"
echo ",default [${pass}]: "
read rpass
if [[ "$rpass" != "" ]]; then
   pass=rpass
fi


echo $port
echo $pass



VER=`grep -oE '[0-9]+\.[0-9]+' /etc/redhat-release`
if [[ $VER>=7 ]]; then
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
else
    rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
    rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm
fi

yum -y install wget make automake gcc gcc-c++ pcre-devel zlib-devel sqlite-devel openssl-devel rdate flex byacc libpcap ncurses ncurses-devel libpcap-devel git php70w php70w-devel php70w-fpm php70w-opcache php70w-mysqlnd php70w-pdo php70w-gd php70w-mbstring php70w-pecl-redis ImageMagick-devel telnet gd gd-devel  libexif-devel php70w-pecl-imagick-devel memcached libmemcached10-devel php70w-pecl-memcached


git clone git@gitee.com:mz/ss.git

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
DIR="${DIR}/ss/"
CFG="${DIR}/conf"
CPU=`cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l`
if [[ CPU > 5 ]]; then
   CPU=3
fi

echo "METHOD=aes-256-cfb
PASSWORD=${pass}
PORT=${port}
LOCAL_PORT=1080
PROCESS_COUNT=${CPU}">$CFG

cd ${DIR}
php start.php start -d