
# This script sets up a Confluent Connect cluster with the specified configuration file.


CONNECTOR_CONFIG_DIRECTORY="./connector-configurations"

AZURE_BLOB_DEPARTMENTS="${CONNECTOR_CONFIG_DIRECTORY}/azure_blob_departments.json"
AZURE_BLOB_PRODUCT_PRICING="${CONNECTOR_CONFIG_DIRECTORY}/azure_blob_product_pricing.json"
AZURE_BLOB_PRODUCT_SKUS="${CONNECTOR_CONFIG_DIRECTORY}/azure_blob_product_skus.json"

# AZURE_COSMOS_PURCHASES="${CONNECTOR_CONFIG_DIRECTORY}/azure-cosmos-purchases.json"
# AZURE_COSMOS_REPLENISHMENTS="${CONNECTOR_CONFIG_DIRECTORY}/azure-cosmos-replenishments.json"


# Create the Kafka Source Connectors for Azure Blob Storage
# confluent connect cluster create --config-file ${AZURE_BLOB_DEPARTMENTS} 
# confluent connect cluster create --config-file ${AZURE_BLOB_PRODUCT_PRICING}
# confluent connect cluster create --config-file ${AZURE_BLOB_PRODUCT_SKUS}

confluent connect cluster list