variable "prefix" {
  type        = string
  description = "Prefix for VM name"
  default     = ""
}

variable "vm" {
  type = object({
    count          = number
    name           = string
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
    ip_address         = string
    network_mask       = number
    gateway_ip_address = string
    cloud_init_user    = string
    public_ssh_key     = string
    tags               = list(string)
  })
  description = "VM configuration object"
}