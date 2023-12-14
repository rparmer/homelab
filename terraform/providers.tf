terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = ">= 2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url = "https://192.168.2.1:8006/api2/json"

  # set PM_USER and PM_PASS env vars
}
