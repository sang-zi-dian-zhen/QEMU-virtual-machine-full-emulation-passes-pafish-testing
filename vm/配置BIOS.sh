#!/bin/bash

#随机序列号<rand_serial>
#是=1	否=3

rand_serial=1

## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##


# 定义颜色变量
GREEN='\e[1;32m' # 绿
PINK='\e[1;35m' # 粉红
RES='\e[0m' # 清除颜色

if [ $rand_serial == 1 ]; then echo_rand_serial="$GREEN是$RES" ;else echo_rand_serial="$PINK否$RES" ;fi
echo -e "\n	自定义配置虚拟机 or 选择复制主机\n	随机序列号:$echo_rand_serial\n\n	当前的主机配置 :\n"
if [[ $EUID -ne 0 ]]; then echo -e "	用户权限不够,root用户执行\n" 1>&2;exit 1;fi
sleep 1

#BIOS信息
bios_T0=$(dmidecode -t 0)
T0_vendor=$(echo $bios_T0 | sed -e 's/.*Vendor: //g' -e 's/ Version:.*//g')
T0_version=$(echo $bios_T0 | sed -e 's/.*Version: //g' -e 's/ Release Date:.*//g')
T0_date=$(echo $bios_T0 | sed -e 's/.*Release Date: //g' -e 's/ Address:.*//g')
T0_release=$(echo $bios_T0 | sed -e 's/.*BIOS Revision: //g')



#系统信息
bios_T1=$(dmidecode -t 1)
T1_manufacturer=$(echo $bios_T1 | sed -e 's/.*Manufacturer: //g' -e 's/ Product Name:.*//g')
T1_product=$(echo $bios_T1 | sed -e 's/.*Product Name: //g' -e 's/ Version:.*//g')
T1_version=$(echo $bios_T1 | sed -e 's/.*Version: //g' -e 's/ Serial Number:.*//g')
T1_serial=$(echo $bios_T1 | sed -e 's/.*Serial Number: //g' -e 's/ UUID:.*//g')
T1_uuid=$(echo $bios_T1 | sed -e 's/.*UUID: //g' -e 's/ Wake-up Type:.*//g')
T1_sku=$(echo $bios_T1 | sed -e 's/.*SKU Number: //g' -e 's/ Family:.*//g')
T1_family=$(echo $bios_T1 | sed -e 's/.*Family: //g')



#主板信息
bios_T2=$(dmidecode -t 2)
T2_manufacturer=$(echo $bios_T2 | sed -e 's/.*Manufacturer: //g' -e 's/ Product Name:.*//g')
T2_product=$(echo $bios_T2 | sed -e 's/.*Product Name: //g' -e 's/ Version:.*//g')
T2_version=$(echo $bios_T2 | sed -e 's/.*Version: //g' -e 's/ Serial Number:.*//g')
T2_serial=$(echo $bios_T2 | sed -e 's/.*Serial Number: //g' -e 's/ Asset Tag:.*//g')
T2_asset=$(echo $bios_T2 | sed -e 's/.*Asset Tag: //g' -e 's/ Features:.*//g')
T2_location=$(echo $bios_T2 | sed -e 's/.*Location In Chassis: //g' -e 's/ Chassis Handle:.*//g')



#机箱信息
bios_T3=$(dmidecode -t 3)
T3_manufacturer=$(echo $bios_T3 | sed -e 's/.*Manufacturer: //g' -e 's/ Type:.*//g')
T3_version=$(echo $bios_T3 | sed -e 's/.*Version: //g' -e 's/ Serial Number:.*//g')
T3_serial=$(echo $bios_T3 | sed -e 's/.*Serial Number: //g' -e 's/ Asset Tag:.*//g')
T3_asset=$(echo $bios_T3 | sed -e 's/.*Asset Tag: //g' -e 's/ Boot-up State:.*//g')
T3_sku=$(echo $bios_T3 | sed -e 's/.*SKU Number: //g')



#处理器信息
bios_T4=$(dmidecode -t 4)
T4_sock_pfx=$(echo $bios_T4 | sed -e 's/.*Socket Designation: //g' -e 's/ Type:.*//g')
T4_manufacturer=$(echo $bios_T4 | sed -e 's/.*Manufacturer: //g' -e 's/ ID:.*//g')
T4_version=$(echo $bios_T4 | sed -e 's/.*Version: //g' -e 's/ Voltage:.*//g')
T4_maxspeed=$(echo $bios_T4 | sed -e 's/.*Max Speed: //g' -e 's/ MHz.*//g')
T4_currentspeed=$(echo $bios_T4 | sed -e 's/.*Current Speed: //g' -e 's/ MHz.*//g')
T4_serial=$(echo $bios_T4 | sed -e 's/.*Serial Number: //g' -e 's/ Asset Tag:.*//g')
T4_asset=$(echo $bios_T4 | sed -e 's/.*Asset Tag: //g' -e 's/ Part Number:.*//g')
T4_part=$(echo $bios_T4 | sed -e 's/.*Part Number: //g' -e 's/ Core Count:.*//g')
T4_processorfamily=$(echo $bios_T4 | sed -e 's/.*Signature: //g' -e 's/, Model.*//g' -e 's/.*Family //g')
T4_16id=$(echo $bios_T4 | sed -e 's/.*ID: //g' -e 's/ Signature:.*//g' -e 's/ //g')
T4_processorid=$(echo "ibase=16; $T4_16id" | bc)



#内存设备
bios_T17=$(dmidecode -t 17 | tail -n 23)
T17_loc_pfx=$(echo $bios_T17 | sed -e 's/.*Set://g' -e 's/Bank Locator:.*//g' -e 's/.*Locator://g' -e 's/ //g')
T17_bank=$(echo $bios_T17 | sed -e 's/.*Bank Locator: //g' -e 's/ Type:.*//g')
T17_manufacturer=$(echo $bios_T17 | sed -e 's/.*Manufacturer: //g' -e 's/ Serial Number:.*//g')
T17_serial=$(echo $bios_T17 | sed -e 's/.*Serial Number: //g' -e 's/ Asset Tag:.*//g')
T17_asset=$(echo $bios_T17 | sed -e 's/.*Asset Tag: //g' -e 's/ Part Number:.*//g')
T17_part=$(echo $bios_T17 | sed -e 's/.*Part Number://g' -e 's/Rank:.*//g' -e 's/ //g')
T17_speed=$(echo $bios_T17 | sed -e 's/.*Speed: //g' -e 's/ MT\/s.*//g')



#CPU
lscpu=$(lscpu)
cpu_family=$(echo $lscpu | sed -e 's/.*CPU family: //g' -e 's/ Model:.*//g')
cpu_model=$(echo $lscpu | sed -e 's/.*Model: //g' -e 's/ Thread(s) per core:.*//g')
cpu_stepping=$(echo $lscpu | sed -e 's/.*Stepping: //g' -e 's/ Microcode version.*//g')
cpu_model_id=$(echo $lscpu | sed -e 's/.*Model name: //g' -e 's/ CPU family:.*//g')



#磁盘
hdparm=$(hdparm -I /dev/sda)
disk_model=$(echo $hdparm | sed -e 's/.*Model Number: //g' -e 's/ Serial Number:.*//g')
disk_serial=$(echo $hdparm | sed -e 's/.*Serial Number: //g' -e 's/ Firmware Revision:.*//g')


## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##


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
echo "<bios>"
echo "<entry name=\"vendor\">$T0_vendor</entry>"
echo "<entry name=\"version\">$T0_version</entry>"
echo "<entry name=\"date\">$T0_date</entry>"
echo "<entry name=\"release\">$T0_release</entry>"
echo "</bios>"

#系统信息
echo "<system>"
echo "<entry name=\"manufacturer\">$T1_manufacturer</entry>"
echo "<entry name=\"product\">$T1_product</entry>"
echo "<entry name=\"version\">$T1_version</entry>"
echo "<entry name=\"serial\">$T1_serial</entry>"
echo "<entry name=\"sku\">$T1_sku</entry>"
echo "<entry name=\"family\">$T1_family</entry>"
echo "</system>"

#主板信息
echo "<baseBoard>"
echo "<entry name=\"manufacturer\">$T2_manufacturer</entry>"
echo "<entry name=\"product\">$T2_product</entry>"
echo "<entry name=\"version\">$T2_version</entry>"
echo "<entry name=\"serial\">$T2_serial</entry>"
echo "<entry name=\"asset\">$T2_asset</entry>"
echo "<entry name=\"location\">$T2_location</entry>"
echo "</baseBoard>"

#机箱信息
echo "<chassis>"
echo "<entry name=\"manufacturer\">$T3_manufacturer</entry>"
echo "<entry name=\"version\">$T3_version</entry>"
echo "<entry name=\"serial\">$T3_serial</entry>"
echo "<entry name=\"asset\">$T3_asset</entry>"
echo "<entry name=\"sku\">$T3_sku</entry>"
echo "</chassis>"



#系统信息
echo -e "\n\n<qemu:arg value=\"-smbios\"/>"
echo -e "<qemu:arg value=\"type=1,uuid=$T1_uuid\"/>"

#处理器信息
echo -e "<qemu:arg value=\"-smbios\"/>"
echo -e "<qemu:arg value=\"type=4,sock_pfx=$T4_sock_pfx,manufacturer=$T4_manufacturer,version=$T4_version,max-speed=$T4_maxspeed,current-speed=$T4_currentspeed,serial=$T4_serial,asset=$T4_asset,part=$T4_part,processor-family=$T4_processorfamily,processor-id=$T4_processorid\"/>"

#内存设备
echo -e "<qemu:arg value=\"-smbios\"/>"
echo -e "<qemu:arg value=\"type=17,loc_pfx=$T17_loc_pfx,bank=$T17_bank,manufacturer=$T17_manufacturer,serial=$T17_serial,asset=$T17_asset,part=$T17_part,speed=$T17_speed\"/>"

#CPU
echo -e "<qemu:arg value=\"-cpu\"/>"
echo -e "<qemu:arg value=\"host,family=$cpu_family,model=$cpu_model,stepping=$cpu_stepping,model_id=$cpu_model_id,+l3-cache,rdtscp=off,hv_time,kvm=off,hv_vendor_id=null,-hypervisor,+vmx,+invtsc,vmware-cpuid-freq=false,enforce=false,host-phys-bits=true\"/>"
echo -e "<qemu:arg value=\"-machine\"/>\n\n"

#磁盘
echo -e "<disk type=\"file\" device=\"disk\">\"/>"
echo -e "<target dev=\"sdb\" bus=\"sata\"/>"
echo -e "<serial>$disk_serial</serial>"
echo -e "<product>$disk_model</product>\n\n"







echo -e "\n参考资源SMBIOS :\n	libvirt:域XML格式	QEMU用户文档 — QEMU文档\n"
echo -e "https://libvirt.org/formatdomain.html#smbios-system-information
https://www.qemu.org/docs/master/system/qemu-manpage.html#hxtool-4\n\n"





