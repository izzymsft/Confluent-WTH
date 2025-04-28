
```bash

export CONFLUENT_ORGANIZATION_ID="1b2a7da3-709a-4562-9553-3cd6397c7388"
export CONFLUENT_CLUSTER_ID="lkc-xk3mgx"

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