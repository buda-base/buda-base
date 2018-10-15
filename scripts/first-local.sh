#!/usr/bin/env bash

# update and install parted
echo ">>>> update and install parted"
apt-get update -q
apt-get install parted -y -q

# format, partition, mount second disk
echo ">>>> format, partition, mount second disk"
parted /dev/sdb mklabel gpt
parted -a opt /dev/sdb mkpart primary ext4 0% 100%

mkfs.ext4 -L datapart /dev/sdb1

mkdir -p /mnt/data

mount -o defaults /dev/sdb1 /mnt/data

echo "LABEL=datapart /mnt/data ext4 defaults 0 2" | cat >> /etc/fstab
