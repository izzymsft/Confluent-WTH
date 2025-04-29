## Lessons Learned Setting Up Confluent and Azure Resources

This document captures important lessons learned during development and environment setup, intended to help coaches and students avoid common pitfalls and streamline their workflows.

---

## Summary of Key Lessons
- **Automate the Provisioning of Confluent Resources with the Confluent CLI**  
- **Never Store Credentials in GitHub Code**
- **Ensure Azure and Confluent Regions Match**
- **Use Throughput Provisioned Mode for Cosmos DB**
- **Provision a Service Principal for Some Managed Confluent Connectors**
- **Use Non-Enforcement Mode in Schema Registry Until Schemas Are Finalized**
- **One Connector per Cosmos DB Source Topic**

---

## Detailed Lessons

### 1. Automate the Provisioning of Confluent Resources with the Confluent CLI

To reduce setup errors and increase repeatability, automate the provisioning of the following Confluent Cloud resources:

- Kafka Topics
- Kafka Schemas for the Topics
- Managed Source and Sink Connectors
- Flink SQL Tables and Queries

Although the Confluent Cloud web portal is convenient for visualizing resources, manual setup is prone to mistakes.  
Install the **Confluent CLI** on your machine or use **Azure Cloud Shell**, then authenticate and bind your local session to your environment and cluster:

```bash
# Authenticate to Confluent Cloud
confluent login --organization "${CONFLUENT_ORGANIZATION_ID}"

# Retrieve your list of environments and then set environment identifier
confluent environment list
confluent environment use "${CONFLUENT_ENVIRONMENT_ID}"

# Retrieve your list of clusters and then set the cluster identifier
confluent kafka cluster list
confluent kafka cluster use "${CONFLUENT_CLUSTER_ID}"
```

Using CLI scripts ensures consistency and reduces troubleshooting time.

---

### 2. Never Store Credentials in GitHub Code

**Credentials should never be hardcoded or checked into source control**.  
Instead, dynamically generate configuration files with credentials at runtime using tools like **bash**, **awk**, or **sed**.  

Ensure sensitive files are added to `.gitignore` locally or globally.  
This helps prevent accidental leaks and reduces the risk of exploitation attacks.

---

### 3. Ensure Azure and Confluent Regions Match

Many managed connectors, such as **Azure Cognitive Search Sink**, require the Confluent Kafka cluster and the Azure service (e.g., Cognitive Search, Blob Storage, Cosmos DB) to be in the **same region**.

Mismatch between regions often causes unexpected connection errors. 

✅ Always verify the Confluent environment and cluster region before provisioning Azure resources.

---

### 4. Use Throughput Provisioned Mode for Cosmos DB SQL API

The Cosmos DB Source Connector does **not support** the Cosmos DB **Serverless** mode.  

You **must provision Cosmos DB with "Provisioned Throughput"** capacity mode to ensure compatibility with Confluent connectors.

> If you mistakenly provision in serverless mode, the connector will fail during deployment or runtime.

---

### 5. Provision a Service Principal for Some Confluent Managed Connectors

Certain Confluent Managed Connectors (e.g., Cosmos DB Source, Blob Store Sink, AI Search Sink) require authentication using an Azure **Service Principal**.

You must create a Service Principal with **Contributor** permissions on the relevant Azure resources.  
During connector setup, you will need the following Service Principal properties:

- Azure Tenant ID
- Azure Subscription ID
- Client ID
- Client Secret

Ensure that these credentials are securely managed.

---

### 6. Use Non-Enforcement Mode in Schema Registry Until Schemas Are Finalized

During early development, **set Schema Registry compatibility to "NONE"** (Non-Enforcement Mode).  
This allows you to freely evolve the schemas without triggering compatibility errors.

Once the schema is stable, you can **switch back to a stricter compatibility mode** (e.g., BACKWARD, FORWARD) to enforce safe schema evolution practices.

---

### 7. One Connector per Cosmos DB Source Topic

Each Cosmos DB Source Connector should be configured to **handle only one Kafka topic** per connector instance.

Managing multiple topics through a single connector instance can cause data inconsistencies or operational complexities.

✅ Provision **one connector per topic** for best results and simpler troubleshooting.

---

# Final Note
Setting up environments correctly from the start saves a significant amount of troubleshooting time later.  

Following these lessons will enable faster setup, better security, and smoother integrations between Confluent Cloud and Azure resources.


### Confluent Schema Registry Compatibility Modes

| Compatibility Mode     | Meaning                                                                 | Typical Use Case                                                                |
|-------------------------|------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| BACKWARD                | New schema is backward compatible with the last registered schema. New schema can read old data. | New consumers must be able to read old data. |
| BACKWARD_TRANSITIVE     | New schema is backward compatible with all previous schemas. New schema can read all historical data. | New consumers must read any past data. |
| FORWARD                 | New schema is forward compatible with the last registered schema. Old schema can read new data. | Old consumers must read new data. |
| FORWARD_TRANSITIVE      | New schema is forward compatible with all previous schemas. Old schemas can read all future data. | Legacy consumers must always work with new data. |
| FULL                    | New schema is both backward and forward compatible with the last schema. Both new and old consumers understand all data. | Producers and consumers evolve independently but must interoperate. |
| FULL_TRANSITIVE         | New schema is both backward and forward compatible with all previous schemas. Full compatibility across history. | Mission-critical systems with strict compatibility needs. |
| NONE                    | No compatibility checks are performed. Any schema can be registered. | Development, prototyping, or manual schema control. |


##### Visual Summary

| Mode                  | New reads old? | Old reads new? | Applies to all past schemas? |
|------------------------|:--------------:|:--------------:|:----------------------------:|
| BACKWARD               | ✅              | ❌              | ❌                            |
| BACKWARD_TRANSITIVE    | ✅              | ❌              | ✅                            |
| FORWARD                | ❌              | ✅              | ❌                            |
| FORWARD_TRANSITIVE     | ❌              | ✅              | ✅                            |
| FULL                   | ✅              | ✅              | ❌                            |
| FULL_TRANSITIVE        | ✅              | ✅              | ✅                            |
| NONE                   | ❌              | ❌              | ❌                            |

