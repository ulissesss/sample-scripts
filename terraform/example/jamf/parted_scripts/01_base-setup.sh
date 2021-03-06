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
mv ${home}/01_base-setup.sh ${scripts}

mv ${home}/02_install-prerequisite.sh ${scripts}

mv ${home}/03_run-jamf-installer.sh ${scripts}

mv ${home}/04_create-db.sh ${scripts}

mv ${home}/05_configure-mysql.sh ${scripts}

# Add Jamf Installer
mv ${home}/jamf-pro-installer* ${jamf_install}/${jamf_version}

# Update apt
apt update

# Launch 02_install-prerequisite.sh
# sh ${scripts}/02_install-prerequisite.sh
