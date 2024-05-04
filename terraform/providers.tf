terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc1"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://192.168.2.10:8006/api2/json"
  pm_tls_insecure = true
  # pm_user = "root@pve"
  # pm_password = "B@ndit0920"

  # set PM_USER and PM_PASS env vars
}
