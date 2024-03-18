## Table of Contents

- [Tested on](#tested-on)
- [Requirements](#requirements)
- [Modules](#modules)
- [Commands](#commands)



## Tested on
 - Ubuntu 16.04 server

## Requirements

| Name | Version |
| --- | --- |
| [`Terraform`](https://registry.terraform.io/) | >= 1.0 |
| [`libvirt`](https://registry.terraform.io/providers/DevScrewOps/libvirt/latest/docs/resources/cloudinit) | >= 0.7.0 |

## Modules
No modules.

## Commands
Initializing terraform, plan and execute
```
terraform init
terraform plan
terraform apply
```

Find IP of the VM on KVM
```
virsh list
virsh dumpxml ubuntu-terraform | grep "mac address" | awk -F\' '{ print $2}'
arp -an | grep mac_address 
```
SSH to the VM with ssh key (note: prior to use key remove all '#' on the beginning of all lines)
```
ssh ubuntu@ip.add.re.ss -i my_ssh_key
```

## Increase VM disk size
When is VM in running state check the name of it with command:
```
sudo virsh list
```
Shutdown VM with command:
```
sudo virsh shutdown ubuntu-terraform
```
Check path of VM storage
```
sudo virsh domblklist ubuntu-terraform
```
Get information of the storage
```
sudo qemu-img info /var/lib/libvirt/images/ubuntu.qcow2
```
Extend VM disk [remove all snapshots for that VM]
```
sudo qemu-img resize /var/lib/libvirt/images/ubuntu.qcow2 +10G
```
Start VM
```
sudo virsh start rhel8
```
Check the block size
```
sudo virsh blockresize rhel8 /var/lib/libvirt/images/ubuntu.qcow2
```
