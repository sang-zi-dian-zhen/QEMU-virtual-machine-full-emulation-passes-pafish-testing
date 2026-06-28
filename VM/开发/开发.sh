#!/bin/bash

#配置工作目录	#是=1	否=3
work_dir=1

##	##	##	##	##	##	##	##	##	##	##	##	##	##	

if [ $work_dir == 1 ]; then
mkdir -p ~/公共/开发[QEMU]	~/公共/开发[QEMU]/diff	~/公共/开发[QEMU]/diff/a	~/公共/开发[QEMU]/diff/b

tar -xf qemu-11.0.1.tar.xz -C ~/公共/开发[QEMU]/diff
cd ~/公共/开发[QEMU]/diff/qemu-11.0.1
	patch -p1 < ../../../../qemu-11.0.1.patch

rm -rf ~/公共/开发[QEMU]/QEMU开发
cp -r ~/公共/开发[QEMU]/diff/qemu-11.0.1		~/公共/开发[QEMU]/QEMU开发

cd ~/公共/开发[QEMU]/QEMU开发
	patch -p1 < ../../../[ACPI-SMBIOS]补丁.patch
fi

##	##	##	##	##	##	##	##	##	##	##	##	##	##	


my_array=("

/hw/i386/acpi-build.c
" "
/hw/acpi/aml-build.c
" "
/include/hw/acpi/aml-build.h
" "
/hw/smbios/smbios.c
" "
/include/hw/firmware/smbios.h
" "
/hw/i386/fw_cfg.c


" "
/hw/i386/pc.c
" "
/hw/pci-host/gpex.c
" "
/hw/scsi/scsi-bus.c

")
 

for item in "${my_array[@]}"; do
item=$(echo $item | sed  's/\n//g')

install -D ~/公共/开发[QEMU]/diff/qemu-11.0.1$item	~/公共/开发[QEMU]/diff/a$item
install -D ~/公共/开发[QEMU]/QEMU开发$item	~/公共/开发[QEMU]/diff/b$item

done	


diff -uprN ~/公共/开发[QEMU]/diff/a ~/公共/开发[QEMU]/diff/b | 
sed -e 's/\/home\/.*\[QEMU\]\/diff\/a/a/g' -e 's/\/home\/.*\[QEMU\]\/diff\/b/b/g' > ~/公共/开发[QEMU]/开发补丁[$(date "+%Y-%m-%d_%H:%M:%S")].patch





