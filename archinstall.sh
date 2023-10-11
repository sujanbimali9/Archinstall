timedatectl set-ntp true
cryptsetup luksFormat --type luks1 --use-random -S 1 -s 512 -h sha512 -i 5000 /dev/nvme0n1p3
cryptsetup open /dev/nvme0n1p3 cryptlvm
pvcreate /dev/mapper/cryptlvm
vgcreate vg /dev/mapper/cryptlvm
lvcreate -L 16G vg -n swap
lvcreate -L 70G vg -n root
lvcreate -l 250G vg -n home
mkfs.ext4 /dev/vg/root
mkfs.ext4 /dev/vg/home
mkswap /dev/vg/swap
mkfs.ext4 dev/vg/home1
mount /dev/vg/root /mnt
mkdir /mnt/home
mount /dev/vg/home /mnt/home
swapon /dev/vg/swap
mkfs.fat -F32 /dev/nvme0n1p2
mkdir /mnt/efi
mount /dev/nvme0n1p2 /mnt/efi
pacstrap /mnt base linux linux-firmware mkinitcpio lvm2 vi dhcpcd wpa_supplicant
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
