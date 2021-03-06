#!/usr/bin/env bash

########################
### SCRIPT VARIABLES ###
########################

source .env

####################
### SCRIPT LOGIC ###
####################


# # Press "Y" if you want to save the database connection settings to the Jamf Pro configuration (DataBase.xml)
# read -p "Save to Jamf Pro Config (DataBase.xml): y/n " yn
# if [ $yn == "y" ]
# then
#     echo "Saved Connection"
# fi


# # Pres "Y" if you want to save the username and password to the Jamf Pro Server Tools CLI configuration file
# read -p "Save username and password to Jamf Sever CLI config File: y/n " yn
# if [ $yn == "y" ]
# then
#     echo "Save Creds to Jamf Server"
# fi

# Jamf Database Init?
mysql -u "root" -e "CREATE DATABASE jamfsoftware;"
mysql -u "root" -e "CREATE USER '${database_user}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${password}';"
mysql -u "root" -e "GRANT ALL ON jamfsoftware.* TO '${database_user}'@'localhost';"
mysql -u "root" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${mysql_root_password}';"