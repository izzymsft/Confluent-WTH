#!/bin/bash

source ./environment.sh

# Enable Public Network Access
az cosmosdb update -g ${AZURE_RESOURCE_GROUP} --name ${COSMOS_DB_ACCOUNT} --public-network-access Enabled

# Enable Local Authentication with Keys
az resource update -g ${AZURE_RESOURCE_GROUP} --name ${COSMOS_DB_ACCOUNT} --resource-type "Microsoft.DocumentDB/databaseAccounts" --set properties.disableLocalAuth=false

