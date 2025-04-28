# Create CosmosDB, Azure AI Search, Blob Storage, and Redis Cache

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.4.0"
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "my-resource-group"
  location = "East US"
}

# Cosmos DB (SQL API)
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "my-cosmosdb-account"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }
}

# Azure AI Search
resource "azurerm_search_service" "search" {
  name                = "my-search-service"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "standard"
  partition_count     = 1
  replica_count       = 1
}

# Azure Blob Storage (Storage Account)
resource "azurerm_storage_account" "storage" {
  name                     = "mystorageacct"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  kind                     = "StorageV2"
}

# Azure Redis Cache
resource "azurerm_redis_cache" "redis" {
  name                = "my-redis-cache"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  capacity            = 1    # C1 (1 GB)
  family              = "C"
  sku_name            = "Basic"  # or Standard/Premium
  enable_non_ssl_port = false
}

# Outputs (Optional)
output "cosmosdb_endpoint" {
  value = azurerm_cosmosdb_account.cosmosdb.endpoint
}

output "search_service_url" {
  value = azurerm_search_service.search.query_keys[0].key
}

output "storage_account_primary_endpoint" {
  value = azurerm_storage_account.storage.primary_blob_endpoint
}

output "redis_hostname" {
  value = azurerm_redis_cache.redis.hostname
}

output "redis_primary_access_key" {
  value = azurerm_redis_cache.redis.primary_access_key
  sensitive = true
}
