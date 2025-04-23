output "ip_address" {
  value = libvirt_domain.postgres_server.network_interface[0].addresses[0]
}