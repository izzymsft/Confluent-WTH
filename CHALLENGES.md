## Overview of Challenges
- Challenge 0 - Set up of Infrastructure and Data Workloads
- Challenge 1 - Configuration of Agentic Resources and Deployment of Backend 
- Challenge 2 - Configuration of Chat Interface and Frontend
- Challenge 3 - Simulation of Employee - Reports, Status etc
- Challenge 4 - Simulation of Suppliers - Replenishments
- Challenge 5 - Simulation of Customers - Purchases and Returns

## Overview of SKUs and Inventory Levels

There are a total of 20 unique SKUs for the online retail store. Each product stock keeping unit (SKU) has a title, product description, unit price and maximum inventory level (MIL).

- For each SKU employees can adjust the price as well as the MIL to suit the demand and supply for each SKU.
- For each SKU, if the inventory count is below 30% of the MIL, that SKU can be replenished for up to 100% of the MIL. Replenishment should not be possible if the inventory count is above 30% of the MIL.
- For each SKU, the item should not be added to the shopping cart if the inventory count is zero.
- Each replenishment event increases the units for the SKU by the number of units added. Replenishent does not impact the revenue balance.
- Each purchase event reduces the inventory count for that SKU by the number of units purchased. The revenue balance is incremented by the product of the SKU and its unit price.
- Each return/refund event increases the inventory count for that SKU by the number of undamaged units returned. The revenue balance is decremented by the product of the SKU and its unit price.
- If the item returned is not damaged it will increase the inventory count of the SKU

## Overview of Employees, Suppliers and Customers
The online grocery store has 5 employees, 40 suppliers and 25 customers.
Customers, suppliers and employees will authenticate into the system by providing their Unique Identifier when prompted.

#### Challenge 0 - Set up of Infrastructure and Data Workloads
In this challenge, the primary objective is to ensure that all the Azure resources necessary to power the applications have been set up. 
We should also ensure that the data needed for the application has also been successfully loaded into the respective data stores.
DML queries and other validation scripts will be provided to verify that the data has been loaded successfully into the data stores.
Participants should be able to verify that all the resources are up at running from the Azure portal and the data stores are fully loaded and ready to go.

#### Challenge 1 - Configuration of Agentic Resources and Deployment of Backend
The goal of this challenge is to ensure that the backend API hosting the Agent is properly configured sucessfully deployed to Azure.
Participants should be able to run a couple of health checks to validate that the deployment is successful.

#### Challenge 2 - Configuration of Chat Interface and Frontend
The goal of this challenge is to ensure that the frontend user interface is properly configured to communicate properly with the Backend APIs and successfully deployed to Azure.
Participants should be able to run a couple of health checks to validate that the deployment is successful.

#### Challenge 3 - Simulation of Employee Persona
For this challenge, employees should be able to authenticate succesfully into the system by providing their employee ID and 4-digit PIN
Employees should be able to perform the following functions:
- Get a summary of total purchases for a specific date
- Get a summary of total replenishments for a specific date
- Get a summary of total returns for a specific date
- Get a summary of net sales (purchases - returns) for a specific date
- Get current inventory level of a specific SKU
- Modify the maximum inventory level for a specific SKU
- Modify the unit price for a specific SKU
- Add a new SKU to the list of SKUs available
- Modify a list of SKUs a vendor is able to replenish

The goal of this challenge is to observe how changes to the database via the agent is processed in realtime using the capabilities of Confluent Cloud on Azure.
Any modifications to records in the database via the agent, flows through Confluent Cloud an is reflected in the destination datastore in near realtime.

#### Challenge 4 - Simulation of Suppliers - Replenishments
For this challenge, vendors should be able to authenticate succesfully into the system by providing their vendor ID and 4-digit PIN
Vendors/suppliers should be able to perform the following functions:
- Get a list of SKUs they are authorized to replenish
- Get the MIL for each SKU they are authorized for
- Get current inventory level of a specific SKU they are authorized to replenish
- Replenish the inventory count up to 100% of the MIL

The goal of this challenge is to observe how changes to the database via the agent is processed in realtime using the capabilities of Confluent Cloud on Azure.
Any modifications to records in the database via the agent, flows through Confluent Cloud an is reflected in the destination datastore in near realtime.


#### Challenge 5 - Simulation of Customers - Purchases and Returns
For this challenge, vendors should be able to authenticate succesfully into the system by providing their vendor ID and 4-digit PIN
Clients/customers should be able to perform the following functions:
- Get a list of all the SKUs the online store provides regardless of the inventory level of the SKUs
- Get a list of all the SKUs that are not out of stock
- Get a list of all the SKUs that are out of stock
- Check the status of a specific SKU (unit price, inventory level and current discount available)
- Add a specific SKU to the shopping cart (up to the inventory count available in stock)
- Make a purchase for all the items in the cart during check out. This will generate a receipt identifier for the transaction
- Get transaction details about a specific receipt ID
- Return a specific SKU from a previous purchase with Receipt ID provided if it is within 14 days of purchase from the current date.

The goal of this challenge is to observe how changes to the database via the agent is processed in realtime using the capabilities of Confluent Cloud on Azure.
Any modifications to records in the database via the agent, flows through Confluent Cloud an is reflected in the destination datastore in near realtime.
