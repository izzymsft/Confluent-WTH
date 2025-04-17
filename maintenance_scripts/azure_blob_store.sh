#!/bin/bash

source ./environment.sh

az storage account update -g ${AZURE_RESOURCE_GROUP} --name ${STORAGE_ACCOUNT}  --allow-shared-key-access true

az storage account update \
  --name ${STORAGE_ACCOUNT} \
  --resource-group ${AZURE_RESOURCE_GROUP} \
  --public-network-access Enabled \
  --default-action Allow

