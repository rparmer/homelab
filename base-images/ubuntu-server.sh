#!/bin/sh

wget https://releases.ubuntu.com/jammy/ubuntu-22.04.2-live-server-amd64.iso
qm create 8100 --memory 2048 --core 2 --name ubuntu-server --net0 virtio,bridge=vmbr0
# qm importdisk 8100 ubuntu-22.04.2-live-server-amd64.iso local-lvm
# qm set 8100 --scsihw virtio-scsi-pci --scsi0 local-lvm:vm-8100-disk-0
# qm set 8100 --boot c --bootdisk scsi0
# qm resize 8100 scsi0 20G
qm template 8100
