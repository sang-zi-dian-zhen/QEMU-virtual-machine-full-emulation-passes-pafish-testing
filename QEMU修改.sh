#!/bin/bash


#是否配置sources<软件包源（仓库）>
#是=1	否=3

#安装编译QEMU依赖
#是=1	否=3

#[用户名字]username=当前用户=  echo $USER



sources=1
#Debian的源码镜像地址[配置sources = 3(否)不起效]
DEB='https:\/\/mirrors.tuna.tsinghua.edu.cn'		#因为使用sed命令需要 \ 转义


QEMU_YL=1

username=user



## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##


# 定义颜色变量
GREEN='\e[1;32m' # 绿
PINK='\e[1;35m' # 粉红
YELLOW='\e[1;33m' # 黄
RES='\e[0m' # 清除颜色

if [ $sources == 1 ]; then echo_sources="$GREEN是$RES" ;else echo_sources="$PINK否$RES" ;fi
if [ $QEMU_YL == 1 ]; then echo_QEMU_YL="$GREEN是$RES" ;else echo_QEMU_YL="$PINK否$RES" ;fi
echo -e "\n	QEMU修改	是否配置软件包源 :$echo_sources\n	当前用户名字 :$YELLOW$username$RES   安装编译依赖:$echo_QEMU_YL\n"

if test -e /home/$username/qemu-11.0.1.patch;then echo -e "qemu-11.0.1.patch[补丁文件存在]"
else echo -e "补丁文件不存在   复制补丁qemu-11.0.1.patch到 /home/$username/ \n";exit 1;fi

if test -e /home/$username/[ACPI-SMBIOS]补丁.patch;then echo -e "[ACPI-SMBIOS]补丁.patch[补丁文件存在]"
else echo -e "补丁文件不存在   复制补丁[ACPI-SMBIOS]补丁.patch到 /home/$username/ \n";exit 1;fi

if test -e /home/$username/qemu-11.0.2.tar.xz;then echo -e "QEMU源码压缩包存在\n"
else echo -e "QEMU源码压缩包不存在   复制qemu-11.0.2.tar.xz源码压缩包到 /home/$username/ \n";exit 1;fi


#配置sources
if [ $sources == 1 ]; then
sudo sed -i "s/deb .*/deb $DEB\/debian testing main contrib non-free/g" /etc/apt/sources.list 
sudo sed -i "s/deb-src .*/deb-src $DEB\/debian testing main contrib non-free/g" /etc/apt/sources.list 
fi

#安装编译QEMU依赖
if [ $QEMU_YL == 1 ]; then
sudo apt update
sudo apt install python3-venv libusb-1.0-0-dev ninja-build build-essential zlib1g-dev pkg-config libglib2.0-dev binutils-dev libpixman-1-dev libfdt-dev
fi



#解压QEMU<原始的未修改>
tar -xf /home/$username/qemu-11.0.2.tar.xz

#QEMU修改
cd /home/$username/qemu-11.0.2/
patch -p1 < ../qemu-11.0.1.patch
patch -p1 < ../[ACPI-SMBIOS]补丁.patch

#安装编译
./configure --target-list=x86_64-softmmu --prefix=/usr

cd build
make -j$(nproc)
sudo make install -j$(nproc)




