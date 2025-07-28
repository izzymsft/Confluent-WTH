#!/bin/bash


echo "Cleaning up Terraform resources..."
rm -rf .terraform*
rm -rf .terraform.lock.hcl
rm -rf terraform.tfstate
rm -rf terraform.tfstate.backup
rm -rf *.tfplan

echo "Terraform resources cleaned up successfully."
