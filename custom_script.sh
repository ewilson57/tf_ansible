#!/bin/bash

# Update all packages that have available updates.
sudo apt update -y

# Install Python 3 and pip.
sudo apt install -y python3-pip

# Install Ansible.
pip3 install 'ansible[azure]==2.9.13'

# Install Ansible modules and plugins for interacting with Azure.
# ansible-galaxy collection install azure.azcollection

