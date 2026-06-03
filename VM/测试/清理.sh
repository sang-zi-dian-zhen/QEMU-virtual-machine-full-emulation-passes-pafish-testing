#!/bin/bash


#当前用户名字 
#username=当前用户=  echo $USER

username=user


## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##

# 定义颜色变量
YELLOW='\e[1;33m' # 黄
RES='\e[0m' # 清除颜色

echo -e "\n	当前用户名字 :$YELLOW$username$RES\n"
if [[ $EUID -ne 0 ]]; then echo -e "	用户权限不够,root用户执行\n" 1>&2;exit 1;fi
sleep 1


rm -r /home/$username/linux*		/home/$username/[LOG\]*	/home/$username/内核补丁[amd].patch	/home/$username/内核补丁[Intel].patch
apt remove exfalso atril quodlibet nautilus synaptic xsane xterm libreoffice* system-config-printer
apt autoremove


mkdir /home/$username/.local/share/applications

echo "[Desktop Entry]
Hidden=true" > /home/$username/.local/share/applications/xfburn.desktop

echo "[Desktop Entry]
Hidden=true" > /home/$username/.local/share/applications/xfce4-dict.desktop

echo "[Desktop Entry]
Hidden=true" > /home/$username/.local/share/applications/xfce4-notes.desktop
