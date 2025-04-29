### Resource Provisioning and Configuration

Certain Terraform & bash scripts have been designed to enable you speed up the provisioning and configuration of the Azure resources necessary for the Hackathon.

The Terraform scripts are in the `terraform` folder and the bash scripts used to provision or configure the Confluent Cloud resources are named `confluent-setup-*` in the root directory of this respository.

### Getting Access to the Git Repo

You can clone the repository by using the following command to your UNIX environment where Bash and Terraform is available.

If you do not have the Git CLI, the Azure CLI and Terraform please do so before proceeding to the next steps

```bash

git --version

az --version

terraform --version

git clone git@github.com:izzymsft/Confluent-WTH.git

```

### Azure Resource Provisioning

Please ensure that whatever regions you pick, you have all the Azure resources, Kafka clusters and Flink compute pool available in that region. Some of the resources used in this hack on the Confluent Cloud end require your Kafka and Azure resources to be in the same region.

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

## Navigate back to the root directory

cd ../

# Ensure that your environment variables have been setup and loaded 
# after the Terraform deployment of the Azure Resources

# This loads the environment variables containing the secrets needed 
# to set up the Kafka connectors
source ~/.confluent-environment.sh

# Reset the connector configs if needed
./confluent-setup-populate-connector-reset.sh

# Generate new connector configs
/.confluent-setup-populate-connector-configs.sh

```


### Generate the Topics Kafka Schemas for Each Topic

Create the Kafka topics and their associated schemas in the Schema registry

```bash

# Creates the Topics and Schemas
./confluent-setup-create-topics.sh

# Deletes the Topics and Schemas
./confluent-setup-delete-topics.sh

```


### Generate the Kafka Source & Sink Connectors

Create the Source and Sink connectors

```bash

# Creates/Updates the Connectors
./confluent-setup-create-connectors.sh

# Deletes the Connectors
./confluent-setup-delete-connectors.sh

```

