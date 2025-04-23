variable "vm_name" {
  description = "Name for the PostgreSQL server VM"
  default     = "postgres-server"
}

variable "vcpus" {
  description = "Number of vCPUs"
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  default     = 2048
}

variable "disk_size" {
  description = "Disk size in GB"
  default     = 5
}

variable "root_disk_size" {
  description = "Disk size in GB"
  default     = 10
}

variable "ssh_public_key" {
  description = "Path to SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}

variable "static_ip" {
  default = "192.168.122.50"
}
