## How to Provision Resources

The resources needed for this project are provisioned using Terraform

Check out the [INSTALL_CLI_DEPENDENCIES.md] resource for instructions for how to set up the following:

- Azure CLI
- Terraform CLI
- Confluent CLI

### Terraform Initialization

````bash

terraform init

terraform plan -out microsoft_hackathon.plan

terraform apply "microsoft_hackathon.plan"

````

### Terraform Reset

````bash

./terraform_cleanup.sh

````