resource "proxmox_vm_qemu" "k3s_nodes" {
  count = var.k3s_node_count

  name        = "k3s-hans-${count.index + 1}"
  desc        = "k3s-hans-${count.index + 1}"
  target_node = "gaston"

  clone = "ubuntu-cloud"

  os_type   = "cloud-init"
  qemu_os   = "other"
  ipconfig0 = "ip=192.168.2.1${format("%02d", count.index + 1)}/22,gw=192.168.1.1"

  cores  = 4
  memory = 1024 * 16

  scsihw = "virtio-scsi-pci"
  onboot = true

  disk {
    storage = "local-lvm"
    type    = "scsi"
    size    = "30G"
  }

  lifecycle {
    ignore_changes = [
      sshkeys,
      network,
    ]
  }

  #   provisioner "local-exec" {
  #     command = "sleep 30 && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u knox -i '10.0.4.${count.index + 1},' playbook.yml"
  #   }
}
