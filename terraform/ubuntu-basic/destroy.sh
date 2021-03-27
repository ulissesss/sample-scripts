#!/bin/bash
cp ~/secrets/terraform.tfvars.asc .
gpg --decrypt --no-symkey-cache --output terraform.tfvars terraform.tfvars.asc
terraform destroy
sleep 60s
rm ./terraform.tfvars*
