#!/bin/bash
#
# Windows shell provisioner for Ansible playbooks, based on KSid's
# windows-vagrant-ansible: https://github.com/KSid/windows-vagrant-ansible
#
# @see README.md
# @author Jeff Geerling, 2014
# @version 1.0

# Uncomment if behind a proxy server.
# export {http,https,ftp}_proxy='http://username:password@proxy-host:80'

ANSIBLE_PLAYBOOK=$1

if [ ! -f /vagrant/$ANSIBLE_PLAYBOOK ]; then
  echo "Cannot find Ansible playbook."
  exit 1
fi

# Install Ansible and its dependencies if it's not installed already.
if [ ! -f /usr/bin/ansible ]; then
  echo "Installing Ansible dependencies and Git."
  yum install -y git python python-devel
  echo "Installing pip via easy_install."
  wget http://peak.telecommunity.com/dist/ez_setup.py
  python ez_setup.py && rm -f ez_setup.py
  easy_install pip
  # Make sure setuptools are installed crrectly.
  pip install setuptools --no-use-wheel --upgrade
  echo "Installing required python modules."
  pip install paramiko pyyaml jinja2 markupsafe
  echo "Installing Ansible."
  pip install ansible
fi

echo "Running Ansible provisioner defined in Vagrantfile."
ansible-playbook all -i 'localhost,' /vagrant/${ANSIBLE_PLAYBOOK} --extra-vars "is_windows=true" --connection=local
