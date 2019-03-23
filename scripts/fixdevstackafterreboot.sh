#!/bin/bash
cd ~/devstack
./unstack.sh
./stack.sh
. openrc
openstack keypair create --public-key ~/.ssh/id_rsa.pub devstack
openstack security group rule create --proto icmp --dst-port 0 default
openstack security group rule create --proto tcp --dst-port 22 default
openstack security group rule create --proto tcp --dst-port 4505 default
openstack security group rule create --proto tcp --dst-port 4506 default
openstack security group rule create --proto tcp --dst-port 8300 default
openstack security group rule create --proto tcp --dst-port 8302 default
openstack security group rule create --proto udp --dst-port 8302 default
mkdir -p ~/downloaded_images
cd ~/downloaded_images
wget http://cdimage.debian.org/cdimage/openstack/current/debian-9.8.2-20190303-openstack-amd64.qcow2
openstack image create --container-format bare --disk-format qcow2 --file debian-9.8.2-20190303-openstack-amd64.qcow2  debian-server-cloudimg-amd64
cd ~/stack
. openrc admin admin
nova quota-update --ram 64000 $(openstack project list | grep -v alt_demo | grep demo | awk '{print$2}')
nova quota-update --instances 100 $(openstack project list | grep -v alt_demo | grep demo | awk '{print$2}')
nova quota-update --cores 1000 $(openstack project list | grep -v alt_demo | grep demo | awk '{print$2}')
openstack quota set --volumes 1000 $(openstack project list | grep -v alt_demo | grep demo | awk '{print$2}')
openstack quota set --floating-ips 1000 $(openstack project list | grep -v alt_demo | grep demo | awk '{print$2}')
openstack quota set --ports 1000 $(openstack project list | grep -v alt_demo | grep demo | awk '{print$2}')

