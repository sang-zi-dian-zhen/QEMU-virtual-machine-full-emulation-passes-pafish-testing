#!/bin/bash



#[用户名字]username=当前用户=  echo $USER

#Intel处理器=1	#AMD处理器=3


CPU=1

username=user

#Debian的源码镜像地址 
DEB=https://mirrors.tuna.tsinghua.edu.cn


## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##


# 定义颜色变量
YELLOW='\e[1;33m' # 黄
RES='\e[0m' # 清除颜色


if [ $CPU == 1 ]; then echo_cpu="\e[1;34mIntel处理器$RES" ;else echo_cpu="\e[1;31mAMD处理器$RES" ;fi
echo -e "\n   当前设备配置\n   当前用户名字 :$YELLOW$username$RES   处理器=$echo_cpu\n  !!内核修改需要时间非常多!\n"

if [ $CPU == 1 ]; then
if test -e /home/$username/内核补丁[Intel].patch;then echo -e "补丁文件存在"
else echo -e "补丁文件不存在   复制内核补丁[Intel].patch到 /home/$username/ \n";exit 1;fi fi

if [ $CPU == 3 ]; then
if test -e /home/$username/内核补丁[amd].patch;then echo -e "补丁文件存在"
else echo -e "补丁文件不存在   复制内核补丁[amd].patch到 /home/$username/ \n";exit 1;fi fi

if [[ $EUID -ne 0 ]]; then echo -e "	用户权限不够,root用户执行\n" 1>&2;exit 1;fi
echo -e "安装内核\n";sleep 1



#设置开机自启CPU定频
#配置sources
echo "# Base repository
deb $DEB/debian bookworm main contrib non-free
deb-src $DEB/debian bookworm main contrib non-free" > /etc/apt/sources.list
apt update
apt install cpufrequtils

echo "
[Unit]
Description=CPU设置定频
[Service]
User=root
ExecStart=/usr/bin/cpufreq-set -g performance
[Install]
WantedBy=multi-user.target " > /etc/systemd/system/cpufreq-set.service
systemctl enable cpufreq-set.service


#配置sources
if [ $CPU == 1 ]; then
echo "# Base repository
deb $DEB/debian testing main contrib non-free
deb-src $DEB/debian testing main contrib non-free" > /etc/apt/sources.list ;else
echo "# Base repository
deb $DEB/debian bullseye main contrib non-free
deb-src $DEB/debian bullseye main contrib non-free" > /etc/apt/sources.list ;fi

#安装内核
apt update
apt install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison
if [ $CPU == 1 ]; then apt source linux-source-7.0 ;else apt source linux-source-5.10 ;fi



#切换内核目录
if [ $CPU == 1 ]; then
version="$(ls | grep 'linux-7.0')"
cd $version	;else
version="$(ls | grep 'linux-5.10')"
cd $version	;fi

#CPU
lscpu=$(lscpu)
cpu_MHz=$(echo $lscpu | sed -e 's/.*CPU max MHz: //g' -e 's/ CPU min MHz:.*//g')
cpu_MHz=$(echo $cpu_MHz | sed -e 's/\.0.*//g' -e 's/00//g')
TIME=$(echo "$cpu_MHz/2" | bc)

#更换计时器
if [ $CPU == 1 ]; then
sed -i "s/u64 fake_diff =  diff \/.*/u64 fake_diff =  diff \/ $TIME;/g" /home/$username/内核补丁[Intel].patch
else	sed -i "s/u64 fake_diff =  diff \/.*/u64 fake_diff =  diff \/ $TIME;/g" /home/$username/内核补丁[amd].patch
fi



#内核修改日志
if [ $CPU == 1 ]; then
if test -e /home/$username/[LOG]内核修改[Intel][LOG];then echo -e "内核已修改"
else	patch -p1 < ../内核补丁[Intel].patch;fi
echo '内核已修改' > /home/$username/[LOG]内核修改[Intel][LOG];fi

if [ $CPU == 3 ]; then
if test -e /home/$username/[LOG]内核修改[AMD][LOG];then echo -e "内核已修改"
else	patch -p1 < ../内核补丁[amd].patch;fi
echo '内核已修改' > /home/$username/[LOG]内核修改[AMD][LOG];fi




#安装编译
make menuconfig

make -j$(nproc)
make modules_install -j$(nproc)
make install -j$(nproc)



