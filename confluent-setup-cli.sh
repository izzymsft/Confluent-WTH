#!/bin/bash


confluent login --organization "${CONFLUENT_ORGANIZATION_ID}"

confluent environment use "${CONFLUENT_ENVIRONMENT_ID}"

# Ensure the Cluster Region matches the Azure Region
confluent kafka cluster use "${CONFLUENT_CLUSTER_ID}"

# Ensure the Flink Compute Pool Region matches the Azure Region
confluent flink compute-pool use "${FINK_COMPUTE_POOL_ID}"
