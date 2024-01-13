#!/usr/bin/env bash

sudo apt install ntpdate
sudo ntpdate cn.pool.ntp.org
sudo hwclock --localtime --systohc
sudo timedatectl set-ntp yes
