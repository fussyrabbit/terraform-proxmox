module "proxmox_vm" {
  source   = "../../"
  for_each = { for key, value in yamldecode(file("${path.cwd}/vms.yaml")).vms : key => merge(var.default_vm, value) }
  vm       = each.value
}
