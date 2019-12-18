#!/bin/bash

DEV=/dev/sda
REGION=Europe/Prague
HOSTNAME=archlinux

timedatectl set-ntp true

# Partitioning
fdisk -l

# Make filesystems

mksf.ext4 ${DEV}1

# Swap
# mkswap ${DEV}2
# swapon ${DEV}2

mount ${DEV}1 /mnt

pacstrap /mnt base linux linux-firmware vim sudo grub openssh

genfstab -U -p /mnt >> /mnt/etc/fstab

arch-croot /mnt bash -c "ln -sf /usr/share/zoneinfo/$REGION /etc/localtime && hwclock --systohc && sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && echo \"LANG=en_US.UTF-8\" > /etc/locale.conf && locale-gen && echo $HOSTNAME > /etc/hostname && grub-install --target=i386-pc $DEV && grub-mkconfig -o /boot/grub/grub.cfg && useradd -m -g users -G wheel,storage,power sysadmin && passwd sysadmin && systemctl enable sshd && EDITOR=vim visudo && exit"

umount -R /mnt

reboot
