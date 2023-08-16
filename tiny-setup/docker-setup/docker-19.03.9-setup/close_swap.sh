swapoff -a
sed -i '/swap/s/^/#/g' /etc/fstab