#!/usr/bin/env bash

########################
### SCRIPT VARIABLES ###
########################

source .env

####################
### SCRIPT LOGIC ###
####################

# Set the innodb_buffer_pool_size value to an appropriate size for your server
sudo jamf-pro database config set --innodb-buffer-pool-size 12G

# Set the innodb_file_per_table value to true
sudo jamf-pro database config set --innodb-file-per-table true

# View the complete list of saved Server Tools configuration settings
sudo jamf-pro config list

# View the complete list of saved Jamf Pro-to-MySQL connection settings
sudo jamf-pro server config list

# View the complete list of saved MySQL database settings
sudo jamf-pro database config list

# Restart the Services
# Stop Tomcat
sudo jamf-pro server stop

# Add MySQL command
mysql -uroot -p${password} -e "ALTER USER 'casper'@'localhost' IDENTIFIED with mysql_native_password BY '${password}';"

# Restart MySQL
sudo jamf-pro database restart

# Start Tomcat
sudo jamf-pro server restart

# Apt cleanup
#apt update
#apt -y upgrade
#apt -y autoremove
