#!/bin/bash 
set -e
set -v


# http://superuser.com/questions/196848/how-do-i-create-an-administrator-user-on-ubuntu
# http://unix.stackexchange.com/questions/1416/redirecting-stdout-to-a-file-you-dont-have-write-permission-on
# This line assumes the user you created in the preseed directory is vagrant
echo "%admin  ALL=NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/init-users
sudo groupadd admin
sudo usermod -a -G admin vagrant


# Installing vagrant keys
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
sudo mkdir -p /home/vagrant/.ssh
sudo chown -R vagrant:vagrant /home/vagrant/.ssh
cat ./vagrant.pub >> /home/vagrant/.ssh/authorized_keys
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/authorized_keys
echo "All Done!"

# Install instructions https://github.com/illinoistech-itm/coup-doeil
# https://dba.stackexchange.com/questions/59317/install-mariadb-10-on-ubuntu-without-prompt-and-no-root-password
# http://dba.stackexchange.com/questions/35866/install-mariadb-without-password-prompt-in-ubuntu?newreg=426e4e37d5a2474795c8b1c911f0fb9f
# From <http://serverfault.com/questions/103412/how-to-change-my-mysql-root-password-back-to-empty/103423> 
export DEBIAN_FRONTEND=noninteractive
echo "mariadb-server mysql-server/root_password password $DBPASS" | sudo  debconf-set-selections
echo "mariadb-server mysql-server/root_password_again password $DBPASS" | sudo debconf-set-selections

sudo apt-get -y update && sudo apt-get -y dist-upgrade 
sudo apt-get -y install nodejs npm
sudo apt-get -y install mariadb-server

git clone https://github.com/illinoistech-itm/coup-doeil /home/vagrant/coup-doeil

cd /home/vagrant/coup-doeil
sudo npm install