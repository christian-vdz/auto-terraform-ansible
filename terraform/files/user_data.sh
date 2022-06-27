#!/bin/sh

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install git python3 ansible -y

git clone https://github.com/christian-vdz/auto-terraform-ansible.git

cd auto-terraform-ansible/ansible
HOME=/home/adminuser ansible-playbook -i inventory/hosts playbooks/base-config.yml

HOME=/home/adminuser ansible-playbook -i inventory/hosts playbooks/docker.yml
