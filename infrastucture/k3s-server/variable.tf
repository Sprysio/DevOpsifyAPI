variable "vm_name" {
  description = "Name for the K3s server VM"
  default     = "k3s-server"
}

variable "vcpus" {
  description = "Number of vCPUs"
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  default     = 4096
}

variable "disk_size" {
  description = "Storage in GB"
  default     = 4
}

variable "root_disk_size" {
  description = "Storage in GB"
  default     = 12
}

variable "ssh_public_key" {
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}