# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
}

# Azure AI Search Instance
resource "azurerm_search_service" "search" {
  name                = "confluentizzysearch1"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "standard"
  partition_count     = 1
  replica_count       = 1
  local_authentication_enabled = true
  public_network_access_enabled = true
}

# Azure Redis Cache
# resource "azurerm_redis_cache" "redis" {
#   name                = "confluentizzyredis1"
#   location            = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
#   capacity            = 1    # C1 (1 GB)
#   family              = "C"
#   sku_name            = "Standard"  # Basic, Standard or Premium
#   non_ssl_port_enabled = false
#   minimum_tls_version  = "1.2"
#   access_keys_authentication_enabled = true
# }

# Azure Cosmos DB (SQL API)
resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "confluentizzycosmos1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }
}

# Cosmos DB SQL Database
resource "azurerm_cosmosdb_sql_database" "retailstore" {
  name                = "retailstore"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name

  throughput          = 400 # Provisioned throughput at the database level (optional if you want)
}

# Purchases Container
resource "azurerm_cosmosdb_sql_container" "purchases" {
  name                = "purchases"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.retailstore.name

  partition_key_paths  = ["/customer_id"]
  throughput          = 400 # optional: you can set throughput here too, or rely on database throughput
}

# Returns Container
resource "azurerm_cosmosdb_sql_container" "returns" {
  name                = "returns"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.retailstore.name

  partition_key_paths  = ["/customer_id"]
  throughput          = 400
}

# Replenishments Container
resource "azurerm_cosmosdb_sql_container" "replenishments" {
  name                = "replenishments"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  database_name       = azurerm_cosmosdb_sql_database.retailstore.name

  partition_key_paths  = ["/vendor_id"]
  throughput          = 400
}


# Azure Blob Storage (Storage Account)
resource "azurerm_storage_account" "storage" {
  name                     = "cfltizzyretailstore1"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"
  account_kind             = "StorageV2"
}

# Define a list of blob container names
locals {
  container_names = [
    "departments",
    "product-pricing",
    "product-skus"
  ]
}

# Create containers using a loop
resource "azurerm_storage_container" "containers" {
  for_each              = toset(local.container_names)
  name                  = each.value
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"
}

