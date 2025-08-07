#!/bin/bash

# Authenticate with Confluent Cloud CLI
# https://docs.confluent.io/cloud/current/cli/install.html
# Ensure you have the Confluent CLI installed and configured
confluent login

confluent environment use "${CONFLUENT_ENVIRONMENT_ID}"

# Ensure the Cluster Region matches the Azure Region
confluent kafka cluster use "${KAFKA_ID}"

# Ensure the Flink Compute Pool Region matches the Azure Region
confluent flink compute-pool use "${FLINK_COMPUTE_POOL_ID}"
