#!/bin/bash

# This script sets up the schemas for the Confluent Schema Registry.
# It creates the necessary topics and registers the schemas.
# Assumes that the Confluent CLI is installed, configured, and the user is authenticated.

# Function to create a Kafka topic and register its key/value schemas
# Example usage
# create_topic_with_schema "sales_transactions"
create_topic_with_schema() {
    
    # Check if the topic name is provided   
    if [ -z "$1" ]; then
        echo "Error: No topic name provided."
        echo "Usage: create_topic_with_schema <topic_name>"
        exit 1
    fi

    local topic_name="$1" # The name of the topic to create
    local key_schema_file="./retail_store/${topic_name}/schemas/${topic_name}-key.json" # Path to the key schema file
    local value_schema_file="./retail_store/${topic_name}/schemas/${topic_name}-value.json" # Path to the value schema file

    echo ""
    echo ""
    echo
    echo "Creating topic: $topic_name"
    confluent kafka topic create "$topic_name" --if-not-exists --partitions 6

    echo "Registering value schema for subject: ${topic_name}-value"
    confluent schema-registry schema create \
      --subject "${topic_name}-value" \
      --schema "$value_schema_file" \
      --type "json"

    echo "Registering key schema for subject: ${topic_name}-key"
    confluent schema-registry schema create \
      --subject "${topic_name}-key" \
      --schema "$key_schema_file" \
      --type "json"

    echo "Verifying registered schemas for $topic_name"
    confluent schema-registry schema list --subject-prefix "${topic_name}"

    echo "----------------------------------------------"
    echo "Topic and schemas setup complete for: $topic_name"
    echo "----------------------------------------------"
    echo ""
    echo ""
}

# Reference topics from Azure Blob Store
create_topic_with_schema "departments"
create_topic_with_schema "product_pricing"
create_topic_with_schema "product_skus"

# Transaction topics from Cosmos DB
create_topic_with_schema "purchases"
create_topic_with_schema "replenishments"
create_topic_with_schema "returns"

# Destination topics heading over to Azure AI Search
create_topic_with_schema "net_sales"
create_topic_with_schema "product_inventory"


confluent schema-registry schema list