## LESSONS LEARNED

This is expected to help the coaches and students based on findings and issues I have encountered during the development

- Automate the Provisioning of Confluent Resources with Confluent CLI
- Do Not Store Credentials in GitHub Code
- Azure and Confluent Regions Should Match
- Cosmos DB Resource Capacity Mode Must Be Throughput Provisioned
- Service Principal Must Be Provisioned for Some Managed Confluent Connectors
- Schema Registry For Each Topic Should Be in NON-Enforcement Mode until your schema is Finalized
- Cosmos DB Connector Should Only Have One Topic Per Connector Instance

#### Automate the Provisioning of Confluent Resources with Confluent CLI
The provisioning of the following Confluent resources in Confluent Cloud should be automated to reduce the probability of configuration errors during setup:

- Kafka Topics
- Kafka Schema Schemas for the Topics
- Confluent Managed Source and Sink Connectors
- Flink SQL Tables and Queries

The Confluent Cloud portal is good for visualing the resources but you could easily make mistakes during the setup. So to simplify things, we can install the confluent cli on your machine or in Azure Cloud Shell and then use the scripts provided to provision the resources.

You will need to authenticate and then bind your local session to your target environment and cluster so that these values will be used as the default when provisioning your Confluent Cloud resources.

```bash

# Authenticate to Confluent Cloud
confluent login --organization "${CONFLUENT_ORGANIZATION_ID}"

# List the Environments and Clusters that you have
confluent environment list

confluent environment use "${CONFLUENT_ENVIRONMENT_ID}"

confluent cluster list

confluent kafka cluster use "${CONFLUENT_CLUSTER_ID}"

```


#### Do Not Store Credentials in GitHub Code
When provisioning resources, find a mechanism to generate temporary scripts with the credentials using bash, awk, sed or similar tools to generate the credential-containing configuration files for the resources and ensure that they are ignored by git (using local or global .gitignore settings) so that they don't accidentally end up in the repository and used later in exploitation attacks.

#### Azure Region for Confluent and Azure Resources Should Match
There are some Confluent Resources that would not connect to Azure Resources if the Confluent Cluster and Azure Resource regions do not match
A good example of this is the AI Search Sink connector. As a result, first look at where the Confluent environment and clusters are located and provision the Azure resources in the same region.

#### Cosmos DB Capacity Mode
The Cosmos DB connector does not support the popular serverless offering from Azure Cosmos DB SQL API. Please provision the resource using the "Provisioned Throughput" capacity mode.

#### Service Principal Needed for Some Confluent Managed Connectors
Please make sure to provision a Service Principal with Contributor privileges that can read/write to the Azure Resources such as Blob Store, Cosmos DB and AI Search. Some of the connectors require the tenant id, subscription id, client id and client secret for the SP when setting up the connector instances.
