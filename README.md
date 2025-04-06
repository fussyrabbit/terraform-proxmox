# Proxmox VM Terraform Module

Terraform module for creating and managing virtual machines (VMs) on a Proxmox VE.

## Requirements

- Terraform >= 1.1.0
- Proxmox provider = 3.0.1-rc6
- Access to a Proxmox VE server

## Providers

| Name | Version |
|------|---------|
| <a name="proxmox"></a> [proxmox](https://registry.terraform.io/providers/Telmate/proxmox/3.0.1-rc6) | 3.0.1-rc6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_vm_qemu.this](https://registry.terraform.io/providers/Telmate/proxmox/3.0.1-rc6/docs/resources/vm_qemu) | resource |

## Usage

Before using this module don't forget configure connections settings for Proxmox VE.

```bash
export PM_API_URL='https://192.168.100.142:8006/api2/json'
export PM_API_TOKEN_ID='terraform-prov@pve!infra'
export PM_API_TOKEN_SECRET='super-sensitive-token'
```

### Basic Example

```text
module "proxmox_vm" {
  source = "../../"

  prefix = "dev-"

  vm = {
    count          = 0
    name           = "webserver"
    description    = "Development web servers"
    proxmox_node   = "pve-01"
    onboot         = true
    clone_template = "ubuntu-noble"
    qemu_agent     = true
    os_type        = "cloud-init"
    cpu_type       = "host"
    full_clone     = true
    scsihw         = "virtio-scsi-pci"

    resources = {
      cores  = 2
      memory = 4096
    }

    network_interfaces = [
      {
        bridge = "vmbr0"
        model  = "virtio"
      }
    ]

    disks = [
      {
        type    = "cloudinit"
        storage = "local-lvm"
        slot    = "ide0"
      },
      {
        type    = "disk"
        storage = "local-lvm"
        size    = "10G"
        slot    = "scsi0"
        cache   = "writethrough"
      }
    ]

    ip_address         = "192.168.100.100"
    network_mask       = 24
    gateway_ip_address = "192.168.100.1"
    cloud_init_user    = "cloud"
    public_ssh_key     = "~/.ssh/id_ed25519.pub"
    tags               = ["web", "dev"]
  }
}
```

See more examples in examples folder

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `prefix` | Prefix for VM names | `string` | `""` | no |
| `vm` | VM configuration object | `object` | n/a | yes |

### VM Configuration Object

The `vm` object accepts the following attributes:

| Attribute | Description | Type | Required |
|-----------|-------------|------|:--------:|
| `count` | Number of VM instances to create | `number` | yes |
| `name` | Base name for VMs (will be appended with index) | `string` | yes |
| `description` | Description of the VM | `string` | yes |
| `proxmox_node` | Proxmox node to deploy the VM on | `string` | yes |
| `onboot` | Whether to start VM on host boot | `bool` | yes |
| `clone_template` | Template to clone from | `string` | yes |
| `qemu_agent` | Enable QEMU guest agent | `bool` | yes |
| `os_type` | Guest OS type | `string` | yes |
| `cpu_type` | CPU type | `string` | yes |
| `full_clone` | Create full clone (true) or linked clone (false) | `bool` | yes |
| `scsihw` | SCSI controller type | `string` | yes |
| `resources` | VM resource configuration | `object` | yes |
| `network_interfaces` | Network interface configurations | `list(object)` | yes |
| `disks` | Disk configurations | `list(object)` | yes |
| `ip_address` | Base IP address (will increment for multiple VMs) | `string` | yes |
| `network_mask` | Network mask in CIDR notation | `number` | yes |
| `gateway_ip_address` | Default gateway IP address | `string` | yes |
| `cloud_init_user` | Cloud-init default user | `string` | yes |
| `public_ssh_key` | Path to public SSH key file | `string` | yes |
| `tags` | List of tags for the VM | `list(string)` | yes |

#### Resources Sub-object

| Attribute | Description | Type | Required |
|-----------|-------------|------|:--------:|
| `cores` | Number of CPU cores | `number` | yes |
| `memory` | Amount of memory in MB | `number` | yes |

#### Network Interface Object

| Attribute | Description | Type | Required |
|-----------|-------------|------|:--------:|
| `bridge` | Network bridge to connect to | `string` | yes |
| `model` | Network interface model | `string` | yes |

#### Disk Object

| Attribute | Description | Type | Required |
|-----------|-------------|------|:--------:|
| `type` | Disk type (scsi, virtio, etc.) | `string` | yes |
| `storage` | Storage pool name | `string` | yes |
| `size` | Disk size (e.g., "32G") | `string` | no |
| `emulatessd` | Emulate SSD behavior | `bool` | no |
| `cache` | Disk cache mode | `string` | no |
| `slot` | Disk slot number | `string` | yes |
| `iso` | ISO image path (for CD-ROM) | `string` | no |
| `iothread` | Enable IO thread | `bool` | no |

## Notes

1. **IP Addressing**: When creating multiple VMs (`count > 1`), the IP address will automatically increment from the base address. For example, with `ip_address = "192.168.1.10"` and `count = 2`, the VMs will get IPs `192.168.1.10` and `192.168.1.11`.

2. **Cloud-init**: The module automatically configures cloud-init with the specified user and SSH key.

## License

Apache 2.0 
