#!/bin/bash



#是否配置sources<软件包源（仓库）>
#是=1	否=3

#当前用户名字 
#username=当前用户=  echo $USER

#Intel处理器,NVIDIA显卡=1
#AMD处理器,显卡=3


sources=1
username=user

CPU=1
GPU=3


## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##


# 定义颜色变量
RED='\e[1;31m' # 红
YELLOW='\e[1;33m' # 黄
GREEN='\e[1;32m' # 绿
BLUE='\e[1;34m' # 蓝
PINK='\e[1;35m' # 粉红
RES='\e[0m' # 清除颜色


echo -e "在开始配置前，请确保：

	打开<准备工作.sh>$YELLOW更改设置$RES
	主板Bios开启\e[1;33mCPU虚拟化技术$RES和\e[1;34mVT-d[Intel]$RES-\e[1;31mIOMMU[AMD]$RES
	使用\e[1;32mDebian13$RES系统
" 

if [ $CPU == 1 ]; then echo_cpu="\e[1;34mIntel处理器$RES" ;else echo_cpu="\e[1;31mAMD处理器$RES" ;fi
if [ $GPU == 1 ]; then echo_gpu="\e[1;32mNVIDIA显卡$RES" ;else echo_gpu="\e[1;31mAMD显卡$RES" ;fi
if [ $sources == 1 ]; then echo_sources="$GREEN是$RES" ;else echo_sources="$PINK否$RES" ;fi
echo -e "  当前用户名字 :$YELLOW$username$RES	是否配置软件包源 :$echo_sources\n  当前设备配置\n  处理器=$echo_cpu 显卡=$echo_gpu\n"

if [[ $EUID -ne 0 ]]; then echo -e "	用户权限不够,root用户执行\n" 1>&2;exit 1;fi
echo -e "\n安装虚拟机";sleep 1

#配置sources
if [ $sources == 1 ]; then
echo "# Base repository
deb http://mirrors.qlu.edu.cn/debian testing main contrib non-free
deb-src http://mirrors.qlu.edu.cn/debian testing main contrib non-free" > /etc/apt/sources.list ;fi

#安装所需的虚拟化软件包：
apt update
apt install qemu-system-x86 libvirt-clients virt-manager hdparm ssh


#将当前用户添加到libvirt和kvm用户组
usermod -aG libvirt $username
usermod -aG kvm $username
systemctl restart libvirtd.service


#修改KVM模块参数<去虚拟化>
echo "options kvm ignore_msrs=1 report_ignored_msrs=0" > /etc/modprobe.d/kvm.conf
echo "options kvm-intel nested=1 enable_shadow_vmcs=1 enable_apicv=1 ept=1" >> /etc/modprobe.d/kvm.conf
modprobe -r kvm_intel
modprobe -r kvm
modprobe kvm
modprobe kvm_intel



#配置VFIO驱动
echo "softdep snd_hda_intel pre:vfio vfio_pci
softdep amdgpu pre:vfio vfio_pci
# 这个是一个排序可以让vfio驱动优先加载
vfio
vfio_iommu_type1
vfio_virqfd"  >  /etc/modules


#将显卡驱动添加到黑名单
if [ $GPU == 1 ]; then  
echo "blacklist nvidia
blacklist nouveau
blacklist snd_hda_intel" > /etc/modprobe.d/blacklist.conf
else 
echo "blacklist amdgpu
blacklist pcieport
blacklist snd_hda_intel" > /etc/modprobe.d/blacklist.conf
fi


#查看显卡ID
if [ $GPU == 1 ]; then
  ID0=$(lspci -nn | grep 01:00.0 | sed -e 's/.*\] \[//g' -e 's/].*//g')
  ID1=$(lspci -nn | grep 01:00.1 | sed -e 's/.*\] \[//g' -e 's/].*//g')
else
  ID0=$(lspci -nn | grep 03:00.0 | sed -e 's/.*\] \[//g' -e 's/].*//g')
  ID1=$(lspci -nn | grep 03:00.1 | sed -e 's/.*\] \[//g' -e 's/].*//g')
fi

#修改GRUB_CMDLINE_LINUX_DEFAULT行，添加IOMMU及VFIO参数
if [ $CPU == 1 ]; then  GRUB_CPU="intel_iommu" ; else GRUB_CPU="amd_iommu"; fi

GRUB="GRUB_CMDLINE_LINUX_DEFAULT=\"$GRUB_CPU=on iommu=pt pcie_aspm=off vfio_iommu_type1.allow_unsafe_interrupts=1 vfio_pci.disable_vga=1 vfio_pci.disable_idle_d3=1 kvm.ignore_msrs=1 vfio-pci.ids=$ID0,$ID1\"" 
sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=.*/$GRUB/g" /etc/default/grub


update-grub



