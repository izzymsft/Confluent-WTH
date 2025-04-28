
```bash

confluent login --organization "${CONFLUENT_ORGANIZATION_ID}"

confluent kafka cluster use "${CONFLUENT_CLUSTER_ID}"

# List Schema Registry
confluent schema-registry schema list

# Remove a specific schemas
confluent schema-registry schema delete --subject departments-key --version 1 --force --permanent

confluent schema-registry schema delete --subject departments-value --version 1 --force --permanent

confluent schema-registry schema delete --subject departments-value --version 1 --force --permanent

confluent schema-registry schema delete --subject product_inventory-key --version 1 --force --permanent

confluent schema-registry schema delete --subject product_inventory-value --version 1 --force --permanent
```