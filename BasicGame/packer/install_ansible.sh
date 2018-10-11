#!/bin/bash
set -e

sudo yum update -y
echo "yum update done. Waiting"

sudo easy_install pip
echo "installing pip"

sudo pip install ansible
echo "installing ansible"

ansible --version
ls -l