#!/bin/bash

# Variables
RESOURCE_GROUP="my-resource-group"
COSMOS_ACCOUNT_NAME="my-cosmosdb-account"

SEARCH_SERVICE_NAME="my-search-service"
SKU="standard"  # could also be 'basic', 'standard', 'standard3', etc.

STORAGE_ACCOUNT_NAME="mystorageacct"

REDIS_NAME="my-redis-cache"
SKU="Basic"  # Basic, Standard, or Premium
REDIS_SIZE="C1"  # Sizes: C0 (250MB), C1 (1GB), C2 (2.5GB), etc.


# Create Cosmos DB SQL API account
az cosmosdb create \
  --name $COSMOS_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP \
  --kind GlobalDocumentDB \
  --locations regionName="eastus" \
  --default-consistency-level "Session" \


# Create Search service
az search service create \
  --name $SEARCH_SERVICE_NAME \
  --resource-group $RESOURCE_GROUP \
  --location eastus \
  --sku $SKU


# Create Storage Account (Blob Store)
az storage account create \
  --name $STORAGE_ACCOUNT_NAME \
  --resource-group $RESOURCE_GROUP \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2

  # Create Redis Cache
az redis create \
  --name $REDIS_NAME \
  --resource-group $RESOURCE_GROUP \
  --location eastus \
  --sku $SKU \
  --vm-size $REDIS_SIZE