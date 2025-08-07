
# Define a list of Kafka topic names
locals {
  kafka_topic_names = [
    "departments",
    "product_pricing",
    "product_skus",
    "purchases",
    "replenishments",
    "returns",
    "net_sales",
    "product_inventory" 
  ]

  kafka_topic_key_names = [
    "purchases",
    "replenishments",
    "returns",
    "net_sales",
    "product_inventory" 
  ]
}

resource "confluent_schema_registry_cluster_config" "microsoft_hackathon" {
  compatibility_level = "NONE"

  lifecycle {
    prevent_destroy = false
  }
}

# Create the Retail Store Kafka Topics
resource "confluent_kafka_topic" "topics" {
  for_each            = toset(local.kafka_topic_names)
  topic_name          = each.value
  partitions_count    = var.kafka_partitions_count

  depends_on = [ 
    confluent_schema_registry_cluster_config.microsoft_hackathon 
  ]

  lifecycle {
    prevent_destroy = false
  } 
}

# Create the Schema Registry Entries for each Topic Key 
resource "confluent_schema" "key_schemas" {
  for_each            = toset(local.kafka_topic_key_names)
  subject_name        = "${each.value}-key"
  format              = "JSON"
  schema              = file("../retail_store/${each.value}/schemas/${each.value}-key.json")
  hard_delete         = true # Optional: Set to true if you want to hard delete the schema

  depends_on = [ confluent_schema_registry_cluster_config.microsoft_hackathon ]
}

# Create the Schema Registry Entries for each Topic Value 
resource "confluent_schema" "value_schemas" {
  for_each            = toset(local.kafka_topic_names)
  subject_name        = "${each.value}-value"
  format              = "JSON"
  schema              = file("../retail_store/${each.value}/schemas/${each.value}-value.json")
  hard_delete         = true # Optional: Set to true if you want to hard delete the schema
  depends_on = [ confluent_schema_registry_cluster_config.microsoft_hackathon ]
}

# Create the Source Connectors for Azure Blob Storage
resource "confluent_connector" "blob_store_connectors" {

  for_each = var.blob_store_connectors

  environment {
    id = var.confluent_environment_id
  }

  kafka_cluster {
    id = var.kafka_id
  }

  config_nonsensitive = {
    "kafka.api.key"                                 = var.kafka_api_key
    "kafka.api.secret"                              = var.kafka_api_secret
    "azblob.account.name"                           = azurerm_storage_account.storage.name
    "azblob.account.key"                            = azurerm_storage_account.storage.primary_access_key
    "connector.class"                               = "AzureBlobSource"
    "name"                                          = each.value.name
    "topic.regex.list"                              = each.value.topic
    "schema.context.name"                           = "default"
    "kafka.auth.mode"                               = "KAFKA_API_KEY"
    "azblob.container.name"                         = each.value.container
    "azblob.retry.type"                             = "EXPONENTIAL"
    "input.data.format"                             = "JSON"
    "output.data.format"                            = "JSON"
    "topics.dir"                                    = "topics"
    "directory.delim"                               = "/"
    "behavior.on.error"                             = "FAIL"
    "format.bytearray.separator"                    = "\n"
    "task.batch.size"                               = "10"
    "file.discovery.starting.timestamp"             = "0"
    "azblob.poll.interval.ms"                       = "60000"
    "record.batch.max.size"                         = "200"
    "tasks.max"                                     = "1"
    "value.converter.decimal.format"                = "BASE64"
    "value.converter.replace.null.with.default"     = "true"
    "value.converter.reference.subject.name.strategy" = "DefaultReferenceSubjectNameStrategy"
    "value.converter.schemas.enable"                = "false"
    "errors.tolerance"                              = "none"
    "value.converter.value.subject.name.strategy"   = "TopicNameStrategy"
    "key.converter.key.subject.name.strategy"       = "TopicNameStrategy"
    "value.converter.ignore.default.for.nullables"  = "false"
    "auto.restart.on.user.error"                    = "true"
  }

  depends_on = [
        azurerm_storage_account.storage,
        azurerm_storage_container.containers,
        confluent_kafka_topic.topics,
        confluent_schema.key_schemas,
        confluent_schema.value_schemas
  ]

  lifecycle {
    prevent_destroy = false
  }
}

# Create the Source Connectors for Azure Cosmos DB
resource "confluent_connector" "cosmos_db_connectors" {
  for_each = var.cosmos_db_connectors

  environment {
    id = var.confluent_environment_id
  }

  kafka_cluster {
    id = var.kafka_id
  }

  config_nonsensitive = {
    "kafka.api.key"                                 = var.kafka_api_key
    "kafka.api.secret"                              = var.kafka_api_secret
    "connect.cosmos.connection.endpoint"            = "https://${azurerm_cosmosdb_account.cosmosdb.name}.documents.azure.com:443/"
    "connect.cosmos.master.key"                     = azurerm_cosmosdb_account.cosmosdb.primary_key
    "connect.cosmos.databasename"                   = azurerm_cosmosdb_sql_database.retailstore.name
    "connector.class"                               = "CosmosDbSource"
    "name"                                          = each.value.name
    "schema.context.name"                           = "default"
    "kafka.auth.mode"                               = "KAFKA_API_KEY"
    "connect.cosmos.containers.topicmap"            = each.value.topic
    "connect.cosmos.task.timeout"                   = "5000"
    "connect.cosmos.task.buffer.size"               = "10000"
    "connect.cosmos.task.batch.size"                = "100"
    "connect.cosmos.task.poll.interval"             = "1000"
    "output.data.format"                            = "JSON_SR"
    "connect.cosmos.messagekey.enabled"             = "true"
    "connect.cosmos.messagekey.field"               = "id"
    "tasks.max"                                     = "1"
    "auto.restart.on.user.error"                    = "true"
    "value.converter.decimal.format"                = "BASE64"
    "value.converter.reference.subject.name.strategy" = "DefaultReferenceSubjectNameStrategy"
    "value.converter.value.subject.name.strategy"   = "TopicNameStrategy"
    "key.converter.key.subject.name.strategy"       = "TopicNameStrategy"
  }

  depends_on = [
    azurerm_cosmosdb_account.cosmosdb,
    azurerm_cosmosdb_sql_database.retailstore,
    azurerm_cosmosdb_sql_container.purchases,
    azurerm_cosmosdb_sql_container.returns,
    azurerm_cosmosdb_sql_container.replenishments,
    confluent_kafka_topic.topics,
    confluent_schema.key_schemas,
    confluent_schema.value_schemas  
  ]

  lifecycle {
    prevent_destroy = false
  }
}

# Create the Source Connectors for Azure AI Search
resource "confluent_connector" "ai_search_connectors" {
  for_each = var.ai_search_connectors

  environment {
    id = var.confluent_environment_id
  }

  kafka_cluster {
    id = var.kafka_id
  }

  config_nonsensitive = {
    "kafka.api.key"                                 = var.kafka_api_key
    "kafka.api.secret"                              = var.kafka_api_secret
    "azure.search.resourcegroup.name"               = var.resource_group_name
    "azure.search.service.name"                     = azurerm_search_service.search.name
    "azure.search.api.key"                          = azurerm_search_service.search.primary_key
    "azure.search.tenant.id"                        = var.service_principal_tenant_id
    "azure.search.subscription.id"                  = var.service_principal_subscription_id
    "azure.search.client.id"                        = var.service_principal_client_id
    "azure.search.client.secret"                    = var.service_principal_client_secret
    "index.name"                                    = each.value.index
    "topics"                                        = each.value.topic
    "schema.context.name"                           = "default"
    "input.data.format"                             = "JSON_SR"
    "connector.class"                               = "AzureCognitiveSearchSink"
    "name"                                          = each.value.name
    "kafka.auth.mode"                               = "KAFKA_API_KEY"
    "write.method"                                  = "Upload"
    "delete.enabled"                                = "true"
    "key.mode"                                      = "KEY"
    "max.batch.size"                                = "25"
    "max.retry.ms"                                  = "300000"
    "max.poll.interval.ms"                          = "300000"
    "max.poll.records"                              = "500"
    "tasks.max"                                     = "1"
    "auto.restart.on.user.error"                    = "true"
    "value.converter.decimal.format"                = "BASE64"
    "value.converter.reference.subject.name.strategy" = "DefaultReferenceSubjectNameStrategy"
    "value.converter.value.subject.name.strategy"   = "TopicNameStrategy"
    "key.converter.key.subject.name.strategy"       = "TopicNameStrategy"
    "transforms"                                    = "sku_id_to_key"
    "transforms.sku_id_to_key.type"                 = "org.apache.kafka.connect.transforms.ValueToKey"
    "transforms.sku_id_to_key.fields"               = "sku_id"
  }

  depends_on = [
    azurerm_search_service.search,
    confluent_kafka_topic.topics,
    confluent_schema.key_schemas,
    confluent_schema.value_schemas  
  ]

  lifecycle {
    prevent_destroy = false
  }
}