locals {

  vms = {
    nginx = merge(var.default_vm, {
      count       = 1
      name        = "nginx"
      disks = [
        { type = "cloudinit", storage = "local-lvm", slot = "ide0" },
        { type = "disk", storage = "local-lvm", size = "10G", slot = "scsi0", cache = "writethrough" },
      ]
      ip_address = "192.168.100.100"
      tags       = ["nginx", "terraform"]
    })
  }
}

module "proxmox_vm" {
  source   = "../../"
  for_each = local.vms
  vm       = each.value
}
