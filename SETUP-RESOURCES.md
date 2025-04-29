
## Azure Resource Provisioning

Azure that whatever region you pick, you have all the Azure resources, Kafka clusters and Flink compute pool available in that region.

Then use the Terraform script to provision the resources

```bash
# Navigate to the Terraform directory
cd terraform

# Run the Terraform commands
terraform init
terraform plan

# Provision the Azure resources
terraform apply

```

Make sure that the output is available for you to use in generating the configuration files



### Setting up the Environment and 

Prepare your Environment Variables from the Terraform Output

```bash

# Grab the output
terraform output

# Generate the environment variables
./generate_env_file.sh

```

### Setup Confluent Configurations

```bash

# Ensure that your environment variables have been setup and loaded 
# after the Terraform deployment of the Azure Resources

# This loads the environment variables containing the secrets needed to set up the Kafka connectors
source ~/.confluent-environment.sh

# Reset the connector configs if needed
./confluent-setup-populate-connector-reset.sh

# Generate new connector configs
/.confluent-setup-populate-connector-configs.sh

```


### Generate the Topics Kafka Schemas for Each Topic


```bash

# Creates the Topics and Schemas
./confluent-setup-create-topics.sh

# Deletes the Topics and Schemas
./confluent-setup-delete-topics.sh

```


### Generate the Kafka Source & Sink Connectors

```bash

# Creates/Updates the Connectors
./confluent-setup-create-connectors.sh

# Deletes the Connectors
./confluent-setup-delete-connectors.sh

```