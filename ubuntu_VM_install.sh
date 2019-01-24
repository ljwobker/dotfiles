#!/bin/bash
  
VM_NAME=hack_test_vm
QCOW_FILE=/var/lib/libvirt/images/$VM_NAME.qcow2


virsh destroy $VM_NAME
virsh undefine $VM_NAME

sleep 2

sudo rm -f $QCOW_FILE
sudo qemu-img create -f qcow2 $QCOW_FILE 8G
sudo chown libvirt-qemu:kvm $QCOW_FILE

sleep 2


/home/lwobker/virt-manager/virt-install \
--debug \
--name hack_test_vm \
--ram 8192 \
--disk path=$QCOW_FILE,size=8 \
--vcpus 8 \
--initrd-inject=/var/lib/libvirt/images/test.ks \
--os-type linux \
--os-variant generic \
--location '/var/lib/libvirt/images/ubuntu-18.04.1-server-amd64.iso' \
--network bridge=bridge1,model=virtio \
--graphics none \
--noreboot \
--console pty,target_type=serial \
--extra-args 'ks=file:/test.ks  console=ttyS0,115200n8 serial'


--location 'http://192.168.15.150/test/' \
#--cdrom '/var/lib/libvirt/images/ubuntu-18.04.1-server-amd64.iso' \
#--location '/var/lib/libvirt/images/ISO/' \
