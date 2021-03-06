#!/usr/bin/env bash

########################
### SCRIPT VARIABLES ###
########################

source .env

####################
### SCRIPT LOGIC ###
####################

# Add scripts and installer directories
# Create /home/jamfadmin/scripts/
mkdir ${scripts}
chmod 0700 ${scripts}
chown "${user}:${user}" ${scripts}

#Create /home/jamfadmin/jamf_install/
mkdir ${jamf_install}
chmod 0700 ${jamf_install}
chown "${user}:${user}" ${jamf_install}

#Create /home/jamfadmin/jamf_install/10.26.1
mkdir ${jamf_install}/${jamf_version}
chmod 0700 ${jamf_install}/${jamf_version}
chown "${user}:${user}" ${jamf_install}/${jamf_version}

# Modify /etc/sudoers for passwordless sudo
# echo '${user} ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install Unzip
apt -y install unzip

# Clean up directory
mv ${home}jamf-install.sh ${scripts}

mv ${home}post-jamf-install.sh ${scripts}

mv ${home}variables.conf ${scripts}

# Add Jamf Installer
mv ${home}jamf-pro-installer* ${jamf_install}/${jamf_version}

# Update apt
apt update

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

# Add exception for Jamf, SSH, and then enable UFW firewall
ufw status
ufw --force enable
ufw allow 8443/tcp
ufw allow OpenSSH
ufw reload

# Change directory
cd ${jamf_install}/${jamf_version}

# Unzip Jamf Pro zip file
unzip ${jamf_install}/${jamf_version}/jamf*.zip

# Run the Jamf Pro installer
sh ${jamf_install}/${jamf_version}/jamfproinstaller.run -- -y

# Configure Pro to start automatically when the server is rebooted
systemctl is-enabled jamf.tomcat8.service
systemctl enable jamf.tomcat8
systemctl is-enabled jamf.tomcat8.service
systemctl start jamf.tomcat8

# Check Jamf Pro Server Tools CLI version
jamf-pro --version

# Create Jamf Pro Database and MySQL User Account
sudo jamf-pro database init
