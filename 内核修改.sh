#!/bin/bash



#[用户名字]username=当前用户=  echo $USER

#Intel处理器=1	#AMD处理器=3


CPU=1

username=user



## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##


# 定义颜色变量
YELLOW='\e[1;33m' # 黄
RES='\e[0m' # 清除颜色


if [ $CPU == 1 ]; then echo_cpu="\e[1;34mIntel处理器$RES" ;else echo_cpu="\e[1;31mAMD处理器$RES" ;fi
echo -e "\n   当前设备配置\n   当前用户名字 :$YELLOW$username$RES   处理器=$echo_cpu\n  !!内核修改需要时间非常多!\n"

if [ $CPU == 1 ]; then
if test -e /home/$username/kernel-patch-6.8.0-65.patch;then echo -e "补丁文件存在"
else echo -e "补丁文件不存在   复制kernel-patch-6.8.0-65.patch到 /home/$username/ \n";exit 1;fi fi

if [ $CPU == 3 ]; then
if test -e /home/$username/内核补丁[amd].patch;then echo -e "补丁文件存在"
else echo -e "补丁文件不存在   复制内核补丁[amd].patch到 /home/$username/ \n";exit 1;fi fi

if [[ $EUID -ne 0 ]]; then echo -e "	用户权限不够,root用户执行\n" 1>&2;exit 1;fi
echo -e "安装内核\n";sleep 1



#配置sources
if [ $CPU == 1 ]; then
echo "# Base repository
deb http://mirrors.qlu.edu.cn/debian trixie main contrib non-free
deb-src http://mirrors.qlu.edu.cn/debian trixie main contrib non-free" > /etc/apt/sources.list ;else
echo "# Base repository
deb http://mirrors.qlu.edu.cn/debian bullseye main contrib non-free
deb-src http://mirrors.qlu.edu.cn/debian bullseye main contrib non-free" > /etc/apt/sources.list ;fi

#安装内核
apt update
apt install git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison
if [ $CPU == 1 ]; then apt source linux-source-6.12 ;else apt source linux-source-5.10 ;fi



#切换内核目录
if [ $CPU == 1 ]; then
version="$(ls | grep 'linux-6.12')"
cd $version	;else
version="$(ls | grep 'linux-5.10')"
cd $version	;fi

#CPU
lscpu=$(lscpu)
cpu_MHz=$(echo $lscpu | sed -e 's/.*CPU max MHz: //g' -e 's/ CPU min MHz:.*//g')
cpu_MHz=$(echo $cpu_MHz | sed -e 's/\.0.*//g')

#更换计时器<u64 fake_diff =  diff / 16;		16是时间戳实际差异的分差,你可以增加和减少>
if [ $CPU == 1 ]; then
if [ $cpu_MHz -ge 4200 ];then 
sed -i 's/u64 fake_diff =  diff \/.*/u64 fake_diff =  diff \/ 20;/g' /home/$username/kernel-patch-6.8.0-65.patch
else	sed -i 's/u64 fake_diff =  diff \/.*/u64 fake_diff =  diff \/ 16;/g' /home/$username/kernel-patch-6.8.0-65.patch
fi fi

if [ $CPU == 3 ]; then
if [ $cpu_MHz -ge 4200 ];then 
sed -i 's/u64 fake_diff =  diff \/.*/u64 fake_diff =  diff \/ 20;/g' /home/$username/内核补丁[amd].patch
else	sed -i 's/u64 fake_diff =  diff \/.*/u64 fake_diff =  diff \/ 16;/g' /home/$username/内核补丁[amd].patch
fi fi



#内核修改日志
if [ $CPU == 1 ]; then
if test -e /home/$username/[LOG]内核修改[Intel][LOG];then echo -e "内核已修改"
else	patch -p1 < ../kernel-patch-6.8.0-65.patch;fi
echo '内核已修改' > /home/$username/[LOG]内核修改[Intel][LOG];fi

if [ $CPU == 3 ]; then
if test -e /home/$username/[LOG]内核修改[AMD][LOG];then echo -e "内核已修改"
else	patch -p1 < ../内核补丁[amd].patch;fi
echo '内核已修改' > /home/$username/[LOG]内核修改[AMD][LOG];fi



#设置开机自启CPU定频
#配置sources
echo "# Base repository
deb http://mirrors.qlu.edu.cn/debian bookworm main contrib non-free
deb-src http://mirrors.qlu.edu.cn/debian bookworm main contrib non-free" > /etc/apt/sources.list
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



#安装编译
make menuconfig

make -j$(nproc)
make modules_install -j$(nproc)
make install -j$(nproc)



