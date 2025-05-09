provider "libvirt" {
  uri = "qemu:///system"
}

resource "null_resource" "remove_old_ssh_key" {
  provisioner "local-exec" {
    command = "ssh-keygen -f '${pathexpand("~/.ssh/known_hosts")}' -R '${var.static_ip}' || true"
  }
}

resource "libvirt_pool" "k3s_pool" {
  name = "k3s_pool"
  type = "dir"
  path = "/var/lib/libvirt/images/k3s"
}

resource "libvirt_volume" "k3s_data" {
  name   = "${var.vm_name}-data"
  pool   = libvirt_pool.k3s_pool.name
  size   = var.disk_size * 1024 * 1024 * 1024
  format = "qcow2"
}

resource "libvirt_volume" "k3s_os" {
  name   = "${var.vm_name}-os"
  pool   = libvirt_pool.k3s_pool.name
  #source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  source = "/home/sprysio/simpleAPIgoDEVOPS/infrastucture/jammy-server-cloudimg-amd64.img"

  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "k3s_init" {
  name      = "${var.vm_name}-init.iso"
  pool      = libvirt_pool.k3s_pool.name
  user_data = templatefile("${path.module}/templates/userdata.yaml", {
    ssh_public_key = file(var.ssh_public_key)
  })
}

resource "libvirt_volume" "k3s_root" {
  name   = "${var.vm_name}-root"
  base_volume_id = libvirt_volume.k3s_os.id
  pool   = libvirt_pool.k3s_pool.name
  size   = var.root_disk_size * 1024 * 1024 * 1024
  format = "qcow2"
}

resource "libvirt_domain" "k3s_server" {
  name   = var.vm_name
  vcpu   = var.vcpus
  memory = var.memory

  cloudinit = libvirt_cloudinit_disk.k3s_init.id

  network_interface {
    network_name = "default"
    addresses = ["${var.static_ip}"]
    # wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.k3s_root.id
  }

  disk {
    volume_id = libvirt_volume.k3s_data.id
  }
  
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  depends_on = [null_resource.remove_old_ssh_key]

  provisioner "local-exec" {
    command = <<EOT
      echo "Waiting for SSH to become available..."
      while ! nc -z 192.168.122.100 22; do
        sleep 2
      done
      echo "SSH is up. Running Ansible..."

      ssh-keyscan -H 192.168.122.100 >> ~/.ssh/known_hosts
      
      rsync -avz -e "ssh -i ~/.ssh/id_rsa" ~/simpleAPIgoDEVOPS/argocd ubuntu@192.168.122.100:/home/ubuntu/

      ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook \
        -i '192.168.122.100,' \
        -u ubuntu \
        --private-key ${replace(var.ssh_public_key, ".pub", "")} \
        ${path.module}/../ansible/k3s-server.yaml
    EOT
  }
}