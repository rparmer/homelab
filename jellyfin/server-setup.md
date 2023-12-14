# Jellyfin Server Setup

## Configure Static IP
```sh
sudo vi /etc/netplan/99-config.yaml
```

```yaml
network:
  ethernets:
    enp6s18:
      dhcp4: no
      addresses:
        - 192.168.2.10/22
      routes:
        - to: default
          via: 192.168.1.1
      nameservers:
          addresses: [192.168.1.1, 1.1.1.1]
  version: 2
```

```sh
sudo netplan apply
```

## Install Core Resources
```sh
sudo apt update
sudo apt upgrade -y
sudo apt install -y nfs-common avahi-daemon
```

```sh
sudo reboot
```

## Install AMD driver
https://www.amd.com/en/support/linux-drivers

```sh
wget https://repo.radeon.com/amdgpu-install/22.40.5/ubuntu/jammy/amdgpu-install_5.4.50405-1_all.deb
sudo apt install -y ./amdgpu-install_5.4.50405-1_all.deb
sudo amdgpu-install -y --usecase=graphics --no-32 --opencl=rocr --vulkan=amdvlk
```

```sh
sudo reboot
```

## Install Jellyfin
```sh
curl https://repo.jellyfin.org/install-debuntu.sh | sudo bash
sudo usermod -aG render jellyfin
sudo usermod -aG video jellyfin
sudo systemctl restart jellyfin

sudo apt install -y mesa-opencl-icd

sudo /usr/lib/jellyfin-ffmpeg/vainfo --display drm --device /dev/dri/renderD128
sudo /usr/lib/jellyfin-ffmpeg/ffmpeg -v debug -init_hw_device opencl=ocl:.0,device_vendor="AMD"
sudo /usr/lib/jellyfin-ffmpeg/ffmpeg -v debug -init_hw_device drm=dr:/dev/dri/renderD128
```

## Mount NFS
```sh
sudo mkdir -p /nfs/media
sudo mount parmernas.local:/volume1/Media /nfs/media
sudo vi /etc/fstab
```

```sh
parmernas.local:/volume1/Media /nfs/media nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
```

## Resize Drive
Use the ubuntu desktop image to boot into virtual env and use gparted to resize image.

```sh
df -h / # get mapper path
sudo lvextend -l +100%FREE /dev/mapper/ubuntu--vg-ubuntu--lv
sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
```

## Sudo without password

```sh
echo "ubuntu ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ubuntu
```
