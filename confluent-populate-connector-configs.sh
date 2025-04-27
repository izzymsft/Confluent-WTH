#!/bin/bash

connector_config_populate_secrets()
{


    # Path to the input and output files
    FILE_PREFIX="$1"
    DIRECTORY_PREFIX="./connector-configurations"
    INPUT_FILE="${DIRECTORY_PREFIX}/${FILE_PREFIX}.example.json"
    OUTPUT_FILE="${DIRECTORY_PREFIX}/${FILE_PREFIX}.final.json"

    # Replace placeholders and output to a new file 
    sed \
        -e "s|\[AZURE_RESOURCE_GROUP\]|${AZURE_RESOURCE_GROUP}|g" \
        -e "s|\[KAFKA_API_KEY\]|${KAFKA_API_KEY}|g" \
        -e "s|\[KAFKA_API_SECRET\]|${KAFKA_API_SECRET}|g" \
        -e "s|\[AZURE_SEARCH_SERVICE_NAME\]|${AZURE_SEARCH_SERVICE_NAME}|g" \
        -e "s|\[AZURE_SEARCH_API_KEY\]|${AZURE_SEARCH_API_KEY}|g" \
        -e "s|\[AZURE_STORAGE_ACCOUNT_NAME\]|${AZURE_STORAGE_ACCOUNT_NAME}|g" \
        -e "s|\[AZURE_STORAGE_ACCOUNT_KEY\]|${AZURE_STORAGE_ACCOUNT_KEY}|g" \
        -e "s|\[SERVICE_PRINCIPAL_CLIENT_ID\]|${SERVICE_PRINCIPAL_CLIENT_ID}|g" \
        -e "s|\[SERVICE_PRINCIPAL_CLIENT_SECRET\]|${SERVICE_PRINCIPAL_CLIENT_SECRET}|g" \
        -e "s|\[SERVICE_PRINCIPAL_TENANT_ID\]|${SERVICE_PRINCIPAL_TENANT_ID}|g" \
        -e "s|\[SERVICE_PRINCIPAL_SUBSCRIPTION_ID\]|${SERVICE_PRINCIPAL_SUBSCRIPTION_ID}|g" \
        "$INPUT_FILE" > "$OUTPUT_FILE"

    echo "Replacement complete. Modified file saved as $OUTPUT_FILE."   
}

connector_config_populate_secrets "ai_search_product_inventory"
connector_config_populate_secrets "azure_blob_departments"
connector_config_populate_secrets "azure_blob_product_skus"
connector_config_populate_secrets "azure_blob_product_pricing"