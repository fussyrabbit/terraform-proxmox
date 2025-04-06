variable "default_vm" {
  type = object({
    count          = number
    description    = string
    proxmox_node   = string
    onboot         = bool
    clone_template = string
    qemu_agent     = bool
    os_type        = string
    cpu_type       = string
    full_clone     = bool
    scsihw         = string
    resources = object({
      cores  = number
      memory = number
    })
    network_interfaces = list(object({
      bridge = string
      model  = string
    }))
    disks = list(object({
      type       = string
      storage    = string
      size       = optional(string)
      emulatessd = optional(bool)
      cache      = optional(string)
      slot       = string
      iso        = optional(string)
      iothread   = optional(bool)
    }))
    network_mask       = number
    gateway_ip_address = string
    cloud_init_user    = string
    public_ssh_key     = string
    tags               = list(string)
  })
  description = "VM configuration object"
  default = {
    count              = 1
    description        = "Managed by Terraform"
    tags               = ["terraform"]
    public_ssh_key     = "~/.ssh/id_ed25519.pub"
    full_clone         = false
    network_mask       = 24
    gateway_ip_address = "192.168.100.1"
    proxmox_node       = "pve-01"
    cloud_init_user    = "cloud"
    onboot             = true
    clone_template     = "ubuntu-noble"
    qemu_agent         = true
    os_type            = "cloud-init"
    cpu_type           = "host"
    scsihw             = "virtio-scsi-single"
    resources          = { cores = 1, memory = 1024 }
    network_interfaces = [{ bridge = "vmbr0", model = "virtio" }]
    disks = [
      { type = "cloudinit", storage = "local-lvm", slot = "ide0" },
      { type = "disk", storage = "local-lvm", size = "5G", slot = "scsi0", cache = "writethrough" }
    ]
  }
}
