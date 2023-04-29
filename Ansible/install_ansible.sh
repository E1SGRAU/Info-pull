#! /bin/bash

sudo apt update
sudo apt-add-repository ppa:ansible/ansible
sudo apt update

sudo apt -y install ansible

echo "
[servers]
server_ubuntu  ansible_host=10.7.150.149 ansible_user=master ansible_password=Qwerty-1
server_centos ansible_host=10.7.150.136 ansible_user=root ansible_password=Qwerty-1

[ubuntu]
server_ubuntu  ansible_host=10.7.150.149 ansible_user=master ansible_password=Qwerty-1

[centos]
server_centos ansible_host=10.7.150.136 ansible_user=root ansible_password=Qwerty-1
"
sudo nano /etc/ansible/hosts