locals {

  vms = {
    nginx = {
      count        = 0
      name         = "nginx"
      proxmox_node = "pve-01"
      disks = [
        { type = "cloudinit", storage = "local-lvm", slot = "ide0" },
        { type = "disk", storage = "local-lvm", size = "10G", slot = "scsi0", cache = "writethrough" },
      ]
      scsihw   = "virtio-scsi-single"
      cpu_type = "host"
      resources = {
        cores  = 1
        memory = 1024
      }
      network_interfaces = [{ bridge = "vmbr0", model = "virtio" }]
      ip_address         = "192.168.100.100"
      gateway_ip_address = "192.168.100.1"
      network_mask       = 24
      cloud_init_user    = "cloud"
      clone_template     = "ubuntu-noble"
      full_clone         = false
      qemu_agent         = true
      onboot             = true
      public_ssh_key     = "~/.ssh/id_ed25519.pub"
      os_type            = "cloud-init"
      description        = "Terraform managed"
      tags               = ["nginx", "terraform"]
    },

    application = {
      count        = 0
      name         = "application"
      proxmox_node = "pve-01"
      disks = [
        { type = "cdrom", storage = "local", slot = "ide0", iso = "local:iso/ubuntu-24.04.2-live-server-amd64.iso" },
        { type = "disk", storage = "local-lvm", size = "10G", slot = "scsi0", cache = "writethrough" },
      ]
      scsihw   = "virtio-scsi-single"
      cpu_type = "host"
      resources = {
        cores  = 2
        memory = 2048
      }
      network_interfaces = [{ bridge = "vmbr0", model = "virtio" }]
      ip_address         = "192.168.100.102"
      gateway_ip_address = "192.168.100.1"
      network_mask       = 24
      cloud_init_user    = "cloud"
      clone_template     = ""
      full_clone         = false
      qemu_agent         = true
      onboot             = true
      public_ssh_key     = "~/.ssh/id_ed25519.pub"
      os_type            = "cloud-init"
      description        = "Terraform managed"
      tags               = ["application", "terraform"]
    }

  }
}

module "proxmox_vm" {
  source   = "../../"
  for_each = local.vms
  vm       = each.value
}
