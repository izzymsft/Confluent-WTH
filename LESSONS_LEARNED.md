## LESSONS LEARNED

This is expected to help the coaches and students based on findings and issues I have encountered during the development

### Azure Region for Confluent and Azure Resources Should Match

There are some Confluent Resources that would not connect to Azure Resources if the Confluent Cluster and Azure Resource regions do not match

A good example of this is the AI Search Sink connector. As a result, first look at where the Confluent environment and clusters are located and provision the Azure resources in the same region.

