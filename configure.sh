#!/bin/sh

###Sys update
sudo apt-get update -y

#Installing components
sudo apt-get install puppet git -y

###Modules
sudo puppet module install jeffmccune-motd
sudo puppet module install saz-sudo
sudo puppet module install puppetlabs-tomcat
sudo puppet module install puppetlabs-apache

###Folders
sudo mkdir /etc/taskize
git clone <repo> /etc/taskize

###Puppetize
sudo puppet apply -dv /etc/taskize/init.pp