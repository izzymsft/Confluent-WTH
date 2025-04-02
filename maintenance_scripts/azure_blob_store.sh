#!/bin/bash

source ./environment.sh

az storage account update -g ${AZURE_RESOURCE_GROUP} --name ${STORAGE_ACCOUNT}  --allow-shared-key-access true
