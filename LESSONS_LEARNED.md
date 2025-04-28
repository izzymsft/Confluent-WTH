## LESSONS LEARNED

This is expected to help the coaches and students based on findings and issues I have encountered during the development

- Azure and Confluent Regions Should Match
- Cosmos DB Resource Capacity Mode Must Be Throughput Provisioned
- Service Principal Must Be Provisioned for Some Managed Confluent Connectors
- Schema Registry For Each Topic Should Be in NON-Enforcement Mode until your schema is Finalized
- Cosmos DB Connector Should Only Have One Topic Per Connector Instance

#### Azure Region for Confluent and Azure Resources Should Match
There are some Confluent Resources that would not connect to Azure Resources if the Confluent Cluster and Azure Resource regions do not match
A good example of this is the AI Search Sink connector. As a result, first look at where the Confluent environment and clusters are located and provision the Azure resources in the same region.

#### Cosmos DB Capacity Mode
The Cosmos DB connector does not support the popular serverless offering from Azure Cosmos DB SQL API. Please provision the resource using the "Provisioned Throughput" capacity mode.

#### Service Principal Needed for Some Confluent Managed Connectors
Please make sure to provision a Service Principal with Contributor privileges that can read/write to the Azure Resources such as Blob Store, Cosmos DB and AI Search. Some of the connectors require the tenant id, subscription id, client id and client secret for the SP when setting up the connector instances.
