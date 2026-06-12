#!/bin/bash

#随机序列号<rand_serial>
#是=1	否=3

rand_serial=1

## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##


# 定义颜色变量
RED='\e[1;31m' # 红
GREEN='\e[1;32m' # 绿
PINK='\e[1;35m' # 粉红
YELLOW='\e[1;33m' # 黄
RES='\e[0m' # 清除颜色

if [ $rand_serial == 1 ]; then echo_rand_serial="$GREEN是$RES" ;else echo_rand_serial="$PINK否$RES" ;fi
echo -e "\n	自定义配置虚拟机 or 选择复制主机\n	随机序列号:$echo_rand_serial\n\n	当前的主机配置 :\n"
if [[ $EUID -ne 0 ]]; then echo -e "	用户权限不够,root用户执行\n" 1>&2;exit 1;fi
sleep 1



#BIOS信息
dmidecode -t 0 > ~/bios_T0
T0_vendor=$(grep 'Vendor:' ~/bios_T0 | sed -e 's/.*Vendor: //g')
T0_version=$(grep 'Version:' ~/bios_T0 | sed -e 's/.*Version: //g')
T0_date=$(grep 'Release Date:' ~/bios_T0 | sed -e 's/.*Release Date: //g')
T0_release=$(grep 'BIOS Revision:' ~/bios_T0 |  sed -e 's/.*BIOS Revision: //g')



#系统信息
dmidecode -t 1 > ~/bios_T1
T1_manufacturer=$(grep 'Manufacturer:' ~/bios_T1 | sed -e 's/.*Manufacturer: //g')
T1_product=$(grep 'Product Name:' ~/bios_T1 | sed -e 's/.*Product Name: //g')
T1_version=$(grep 'Version:' ~/bios_T1 | sed -e 's/.*Version: //g')
T1_serial=$(grep 'Serial Number:' ~/bios_T1 | sed -e 's/.*Serial Number: //g')
T1_uuid=$(grep 'UUID:' ~/bios_T1 | sed -e 's/.*UUID: //g')
T1_sku=$(grep 'SKU Number:' ~/bios_T1 | sed -e 's/.*SKU Number: //g')
T1_family=$(grep 'Family:' ~/bios_T1 | sed -e 's/.*Family: //g')



#主板信息
dmidecode -t 2 > ~/bios_T2
T2_manufacturer=$(grep 'Manufacturer:' ~/bios_T2 | sed -e 's/.*Manufacturer: //g')
T2_product=$(grep 'Product Name:' ~/bios_T2 | sed -e 's/.*Product Name: //g')
T2_version=$(grep 'Version:' ~/bios_T2 | sed -e 's/.*Version: //g')
T2_serial=$(grep 'Serial Number:' ~/bios_T2 | sed -e 's/.*Serial Number: //g')
T2_asset=$(grep 'Asset Tag:' ~/bios_T2 | sed -e 's/.*Asset Tag: //g')
T2_location=$(grep 'Location In Chassis:' ~/bios_T2 | sed -e 's/.*Location In Chassis: //g')



#机箱信息
dmidecode -t 3 > ~/bios_T3
T3_manufacturer=$(grep 'Manufacturer:' ~/bios_T3 | sed -e 's/.*Manufacturer: //g')
T3_version=$(grep 'Version:' ~/bios_T3 | sed -e 's/.*Version: //g')
T3_serial=$(grep 'Serial Number:' ~/bios_T3 | sed -e 's/.*Serial Number: //g')
T3_asset=$(grep 'Asset Tag:' ~/bios_T3 | sed -e 's/.*Asset Tag: //g')
T3_sku=$(grep 'SKU Number:' ~/bios_T3 | sed -e 's/.*SKU Number: //g')



#处理器信息
dmidecode -t 4 > ~/bios_T4
T4_sock_pfx=$(grep 'Socket Designation:' ~/bios_T4 | sed -e 's/.*Socket Designation: //g')
T4_manufacturer=$(grep 'Manufacturer:' ~/bios_T4 | sed -e 's/.*Manufacturer: //g')
T4_version=$(grep 'Version:' ~/bios_T4 | sed -e 's/.*Version: //g')
T4_maxspeed=$(grep 'Max Speed:' ~/bios_T4 | sed -e 's/.*Max Speed: //g' -e 's/ MHz//g')
T4_currentspeed=$(grep 'Current Speed:' ~/bios_T4 | sed -e 's/.*Current Speed: //g' -e 's/ MHz//g')
T4_serial=$(grep 'Serial Number:' ~/bios_T4 | sed -e 's/.*Serial Number: //g')
T4_asset=$(grep 'Asset Tag:' ~/bios_T4 | sed -e 's/.*Asset Tag: //g')
T4_part=$(grep 'Part Number:' ~/bios_T4 | sed -e 's/.*Part Number: //g')
T4_processorfamily=$(grep 'Signature:' ~/bios_T4 | sed -e 's/.*Signature: //g' -e 's/, Model.*//g' -e 's/.*Family //g')
T4_16id=$(grep 'ID:' ~/bios_T4 | sed -e 's/.*ID: //g' -e 's/ //g')
T4_processorid=$(echo "ibase=16; $T4_16id" | bc)



#内存设备
dmidecode -t 17 > ~/bios_T17
tail -n 25 ~/bios_T17 > ~/tail_bios_T17
T17_loc_pfx=$(grep '	Locator: ' ~/tail_bios_T17 | sed -e 's/.*Locator: //g')
T17_bank=$(grep 'Bank Locator:' ~/tail_bios_T17 | sed -e 's/.*Bank Locator: //g')
T17_manufacturer=$(grep 'Manufacturer:' ~/tail_bios_T17 | sed -e 's/.*Manufacturer: //g')
T17_serial=$(grep 'Serial Number:' ~/tail_bios_T17 | sed -e 's/.*Serial Number: //g')
T17_asset=$(grep 'Asset Tag:' ~/tail_bios_T17 | sed -e 's/.*Asset Tag: //g')
T17_part=$(grep 'Part Number:' ~/tail_bios_T17 | sed -e 's/.*Part Number: //g' -e 's/ //g')
T17_speed=$(grep '	Speed:' ~/tail_bios_T17 | sed -e 's/.*Speed: //g' -e 's/ MT\/s.*//g')



#CPU
lscpu > ~/lscpu
cpu_family=$(grep 'CPU family:' ~/lscpu | sed -e 's/.*CPU family://g' -e 's/ //g')
cpu_model=$(grep 'Model:' ~/lscpu | sed -e 's/.*Model://g' -e 's/ //g')
cpu_stepping=$(grep 'Stepping:' ~/lscpu | sed -e 's/.*Stepping://g' -e 's/ //g')
cpu_model_id=$(grep 'Model name:' ~/lscpu | sed -e 's/.*Model name://g' -e 's/ //g')



#磁盘
hdparm -I /dev/sda > ~/hdparm
disk_model=$(grep 'Model Number:' ~/hdparm | sed -e 's/.*Model Number://g' -e 's/ //g')
disk_serial=$(grep 'Serial Number:' ~/hdparm | sed -e 's/.*Serial Number://g' -e 's/ //g')


## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##

rm ~/bios_T0 ~/bios_T1 ~/bios_T2 ~/bios_T3 ~/bios_T4 ~/bios_T17 ~/tail_bios_T17 ~/lscpu ~/hdparm


#随机序列号
if [ $rand_serial == 1 ]; then  
T1_serial=$(shuf -i 100000000000-999999999999 -n 1)
T1_uuid=$(cat /proc/sys/kernel/random/uuid)
T2_serial=$(shuf -i 100000000000-999999999999 -n 1)
T3_serial=$(shuf -i 100000000000-999999999999 -n 1)
T4_serial=$(shuf -i 100000000000-999999999999 -n 1)
T4_processorid=$(shuf -i 100000000000-999999999999 -n 1)
T17_serial=$(shuf -i 100000000000-999999999999 -n 1)
disk_serial=$(shuf -i 100000000000-999999999999 -n 1)
fi



#BIOS信息
echo -e "<bios>"
echo -e "<entry name=\"vendor\">$YELLOW$T0_vendor$RES</entry>"
echo -e "<entry name=\"version\">$YELLOW$T0_version$RES</entry>"
echo -e "<entry name=\"date\">$YELLOW$T0_date$RES</entry>"
echo -e "<entry name=\"release\">$YELLOW$T0_release$RES</entry>"
echo -e "</bios>"

#系统信息
echo -e "<system>"
echo -e "<entry name=\"manufacturer\">$YELLOW$T1_manufacturer$RES</entry>"
echo -e "<entry name=\"product\">$YELLOW$T1_product$RES</entry>"
echo -e "<entry name=\"version\">$YELLOW$T1_version$RES</entry>"
echo -e "<entry name=\"serial\">$RED$T1_serial$RES</entry>"
echo -e "<entry name=\"sku\">$YELLOW$T1_sku$RES</entry>"
echo -e "<entry name=\"family\">$YELLOW$T1_family$RES</entry>"
echo -e "</system>"

#主板信息
echo -e "<baseBoard>"
echo -e "<entry name=\"manufacturer\">$YELLOW$T2_manufacturer$RES</entry>"
echo -e "<entry name=\"product\">$YELLOW$T2_product$RES</entry>"
echo -e "<entry name=\"version\">$YELLOW$T2_version$RES</entry>"
echo -e "<entry name=\"serial\">$RED$T2_serial$RES</entry>"
echo -e "<entry name=\"asset\">$YELLOW$T2_asset$RES</entry>"
echo -e "<entry name=\"location\">$YELLOW$T2_location$RES</entry>"
echo -e "</baseBoard>"

#机箱信息
echo -e "<chassis>"
echo -e "<entry name=\"manufacturer\">$YELLOW$T3_manufacturer$RES</entry>"
echo -e "<entry name=\"version\">$YELLOW$T3_version$RES</entry>"
echo -e "<entry name=\"serial\">$RED$T3_serial$RES</entry>"
echo -e "<entry name=\"asset\">$YELLOW$T3_asset$RES</entry>"
echo -e "<entry name=\"sku\">$YELLOW$T3_sku$RES</entry>"
echo -e "</chassis>"



#系统信息
echo -e "\n\n<qemu:arg value=\"-smbios\"/>"
echo -e "<qemu:arg value=\"type=1,uuid=$RED$T1_uuid$RES\"/>"

#处理器信息
echo -e "<qemu:arg value=\"-smbios\"/>"
echo -e "<qemu:arg value=\"type=4,sock_pfx=$YELLOW$T4_sock_pfx$RES,manufacturer=$YELLOW$T4_manufacturer$RES,version=$YELLOW$T4_version$RES,max-speed=$YELLOW$T4_maxspeed$RES,current-speed=$YELLOW$T4_currentspeed$RES,serial=$RED$T4_serial$RES,asset=$YELLOW$T4_asset$RES,part=$YELLOW$T4_part$RES,processor-family=$YELLOW$T4_processorfamily$RES,processor-id=$RED$T4_processorid$RES\"/>"

#内存设备
echo -e "<qemu:arg value=\"-smbios\"/>"
echo -e "<qemu:arg value=\"type=17,loc_pfx=$YELLOW$T17_loc_pfx$RES,bank=$YELLOW$T17_bank$RES,manufacturer=$YELLOW$T17_manufacturer$RES,serial=$RED$T17_serial$RES,asset=$YELLOW$T17_asset$RES,part=$YELLOW$T17_part$RES,speed=$YELLOW$T17_speed$RES\"/>"

#CPU
echo -e "<qemu:arg value=\"-cpu\"/>"
echo -e "<qemu:arg value=\"host,family=$YELLOW$cpu_family$RES,model=$YELLOW$cpu_model$RES,stepping=$YELLOW$cpu_stepping$RES,model_id=$YELLOW$cpu_model_id$RES,+l3-cache,rdtscp=off,hv_time,kvm=off,hv_vendor_id=null,-hypervisor,+vmx,+invtsc,vmware-cpuid-freq=false,enforce=false,host-phys-bits=true\"/>"
echo -e "<qemu:arg value=\"-machine\"/>\n\n"

#磁盘
echo -e "<disk type=\"file\" device=\"disk\">"
echo -e "<source file=\"/var/lib/libvirt/images/win10.qcow2\"/>"
echo -e "<target dev=\"sdb\" bus=\"sata\"/>"
echo -e "<serial>$RED$disk_serial$RES</serial>"
echo -e "<product>$YELLOW$disk_model$RES</product>"
echo -e "</disk>\n\n"







echo -e "\n参考资源SMBIOS :\n	libvirt:域XML格式	QEMU用户文档 — QEMU文档\n"
echo -e "https://libvirt.org/formatdomain.html#smbios-system-information
https://www.qemu.org/docs/master/system/qemu-manpage.html#hxtool-4\n\n"





