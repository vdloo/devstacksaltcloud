# salt-cloud + devstack example

This repo is a short example of how to use salt-cloud to use SaltStack for orchestration, provisioning and configuration management with OpenStack. This example assumes a `stable/rocky` [DevStack](https://github.com/openstack-dev/devstack) installation.

# DevStack setup

If you don't have a real OpenStack you can run one locally in a VM. Install [DevStack](https://github.com/openstack-dev/devstack). In my setup I've used an otherwise fresh `Ubuntu 16.04.5 LTS` VM running on kvm/qemu with libvirt with macvtap networking. This repo assumes that the password is 'toor'. After running `./stack.sh` you need to configure the VM that it can SSH into any created instances. 

Log in to the devstack machine and set up some rules for the default security group:
```
root@devstack:~# su stack
stack@devstack:/root$ cd ~/devstack/
stack@devstack:~/devstack$ . openrc 
WARNING: setting legacy OS_TENANT_NAME to support cli tools.
stack@devstack:~/devstack$ openstack security group rule create --proto icmp --dst-port 0 default
stack@devstack:~/devstack$ openstack security group rule create --proto tcp --dst-port 22 default
```

Next, get some Ubuntu and Debian images and add them:
```
wget http://cloud-images.ubuntu.com/xenial/current/xenial-server-cloudimg-amd64-disk1.img
wget http://cdimage.debian.org/cdimage/openstack/current/debian-9.8.2-20190303-openstack-amd64.qcow2
openstack image create --container-format bare --disk-format qcow2 --file xenial-server-cloudimg-amd64-disk1.img xenial-server-cloudimg-amd64
openstack image create --container-format bare --disk-format qcow2 --file debian-9.8.2-20190303-openstack-amd64.qcow2  debian-server-cloudimg-amd64
```

Finally create an ssh key and log in to the web interface and add the public key under the demo project with the name 'devstack':
```
$ ssh-keygen  # create some key
# go to http://yourvmip/dashboard/project/key_pairs
# press import key and add the content of /opt/stack/.ssh/id_rsa.pub
```

# Saltstack setup

Upload this repository to your DevStack VM. This is needed because by default DevStack will only use private networking. salt-cloud will connect from the host to the private 'floating IPs' in `172.24.4.*`.

Install salt in a virtualenv
```
root@devstack:~# apt-get install virtualenvwrapper
stack@devstack:~$ cd /opt/stack/devstacksaltcloud
virtualenv venv
. venv/bin/activate
pip install -r requirements/base.txt
```

# Example commands

Run these in the directory the Saltfile is in:
```
# list images in the DevStack
salt-cloud --list-images openstack
```

```
# create a VM in the demo tenant
# add -l debug for debugging
salt-cloud -p ubuntu myubuntuinstance 
```
