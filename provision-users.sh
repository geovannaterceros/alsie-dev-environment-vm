#!/bin/bash

 USER=jenkins
 KEY_NAME=vms-key

[[ ! -d /home/$USER ]] && useradd -m $USER -s /bin/bash
mkdir -p /home/$USER/.ssh && chmod 700 /home/$USER/.ssh
cat /vagrant/keys/$KEY_NAME.pub > /home/$USER/.ssh/authorized_keys
chown -R $USER:$USER /home/$USER
gpasswd -a $USER docker
