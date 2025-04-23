output "ip_address" {
  value = libvirt_domain.k3s_server.network_interface[0].addresses[0]
}