# 1. ----> Section that declares the provider in Terraform registry
provider "libvirt" {
    uri = "qemu:///system"
}
terraform {
    required_providers {
        libvirt = {
            source = "dmacvicar/libvirt"
        }
    }
}

# 2. ----> Fetch the smallest ubuntu image from the cloud image repo 
resource "libvirt_volume" "ubuntu-qcow2" {
    name = "ubuntu.qcow2"
    pool = "default"
    source = "https://cloud-images.ubuntu.com/releases/xenial/release/ubuntu-16.04-server-cloudimg-amd64-disk1.img"
    format = "qcow2"
}

# 3. ----> Data sources renders a template from a template string, which is loaded from external files.
data "template_file" "user_data" {
    template = file("${path.module}/cloud_init.cfg")
}
data "template_file" "network_config" {
    template = file("${path.module}/network_config.cfg")
}

# 4. ----> Using CloudInit to add our ssh-key to the instance
resource "libvirt_cloudinit_disk" "commoninit" {
    name = "commoninit.iso"
    user_data = data.template_file.user_data.rendered
    network_config = data.template_file.network_config.rendered
    pool = "default"
}

# 5. ----> Create the compute vm
resource "libvirt_domain" "domain-ubuntu" {
    name = "ubuntu-terraform"
    memory = "512"
    vcpu = 1

    cloudinit = libvirt_cloudinit_disk.commoninit.id

    network_interface {
        network_name = "default"
    }

  # Since they expect a console we need to pass it
    console {
        type = "pty"
        target_port = "0"
        target_type = "serial"
    }

    console {
        type = "pty"
        target_type = "virtio"
        target_port = "1"
    }

    disk {
        volume_id = libvirt_volume.ubuntu-qcow2.id
    }

    graphics {
        type = "spice"
        listen_type = "address"
        autoport = true
    }
}