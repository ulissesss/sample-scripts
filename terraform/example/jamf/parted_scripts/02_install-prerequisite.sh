#!/usr/bin/env bash

########################
### SCRIPT VARIABLES ###
########################

source .env

####################
### SCRIPT LOGIC ###
####################

# Install OpenJDK 11
apt -y install openjdk-11-jdk

# Check Java version
java --version

# change selected Java version
update-alternatives --config java

# Set the Java path by executing the following command
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin

# Change directory
cd /tmp

# Download MySQL 8.0
wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.16-1_all.deb
export DEBIAN_FRONTEND="noninteractive"
sudo echo "mysql-apt-config mysql-apt-config/select-server select mysql-8.0" | sudo debconf-set-selections
dpkg -i mysql-apt-config_0.8.16-1_all.deb

# Update apt
apt update

# Install MySQL
sudo echo "mysql-community-server mysql-community-server/root-pass password $password" | sudo debconf-set-selections
sudo echo "mysql-community-server mysql-community-server/re-root-pass password $password" | sudo debconf-set-selections
sudo echo "mysql-community-server mysql-community-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)" | sudo debconf-set-selections

export DEBIAN_FRONTEND="noninteractive"
apt -y install mysql-server

# Launch 03_run-jamf-installer.sh
# sh ${scripts}/03_run-jamf-installer.sh
