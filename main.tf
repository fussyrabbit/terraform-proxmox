resource "proxmox_vm_qemu" "this" {
  count = var.vm.count

  name        = "${var.prefix}${var.vm.name}-${count.index + 1}"
  desc        = var.vm.description
  target_node = var.vm.proxmox_node
  onboot      = var.vm.onboot
  clone       = var.vm.clone_template
  agent       = var.vm.qemu_agent ? 1 : 0
  os_type     = var.vm.os_type
  cores       = var.vm.resources.cores
  cpu_type    = var.vm.cpu_type
  memory      = var.vm.resources.memory
  full_clone  = var.vm.full_clone
  scsihw      = var.vm.scsihw

  dynamic "network" {
    for_each = { for idx, iface in var.vm.network_interfaces : idx => iface }
    content {
      id     = network.key
      bridge = network.value.bridge
      model  = network.value.model
    }
  }

  dynamic "disk" {
    for_each = { for idx, disk in var.vm.disks : idx => disk }
    content {
      type       = disk.value.type
      storage    = disk.value.storage
      size       = try(disk.value.size, "")
      emulatessd = try(disk.value.emulatessd, null)
      cache      = try(disk.value.cache, "")
      slot       = disk.value.slot
      iso        = try(disk.value.iso, "")
      iothread   = try(disk.value.iothread, false)
    }
  }

  ipconfig0 = "ip=${join(".", slice(split(".", var.vm.ip_address), 0, 3))}.${tonumber(split(".", var.vm.ip_address)[3]) + count.index}/${var.vm.network_mask},gw=${var.vm.gateway_ip_address}"
  ciuser    = var.vm.cloud_init_user
  sshkeys   = file(var.vm.public_ssh_key)
  tags      = join(";", var.vm.tags)
}
