#!/bin/bash
cp ~/secrets/terraform.tfvars.asc .
gpg --decrypt --nosymkey-cache --output ./terraform.tfvars ./terraform.tfvars.asc
terraform plan
terraform apply
sleep 60s
rm ./terraform.tfvars*
