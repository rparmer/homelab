#!/bin/sh

wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
qm create 8000 --memory 2048 --core 2 --name ubuntu-cloud --net0 virtio,bridge=vmbr0
qm importdisk 8000 jammy-server-cloudimg-amd64.img local-lvm
qm set 8000 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-8000-disk-0
qm set 8000 --ide2 local-lvm:cloudinit
qm set 8000 --boot c --bootdisk scsi0
qm set 8000 --serial0 socket --vga serial0
qm set 8000 --sshkeys sshkeys
qm set 8000 --ipconfig0 ip=dhcp
qm resize 8000 scsi0 +20G
qm template 8000
