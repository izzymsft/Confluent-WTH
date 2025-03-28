## Overview of Hack

We have a fictitious grocery store that has a list of products from various departments and categories. The grocery company has created an application that allows customers, suppliers and employees to interact with it using conversations.

Customers are able to make purchases by providing a list of items they would love to purchase and at the end of the transaction they will be given a receipt identifier and a breakdown of the items purchases, the quantity of each item and the taxes as well as the total amount for the purchase. They can also come back later to make a return of items that were previously purchased as long as they were purchased within a 14-day period.

Supplies are also able to chat with the application to replenish the inventory for items that are out of stock or low in supply.

Employees of the grocery store should be able to find out the quantity of any item that was purchased on any specific date as well as the inventory count at hand for any product at any time considering how replenishments, returns and purchases can impact the inventory count at any given instant.

All the data and transactions are happening in the Cosmos DB database and we are using Confluent cloud to capture the data changes and process the inventory count in real time so that the results can be sent to Azure AI search for the AI agent to query in real time for providing answers to supplies trying to replenish, buyers attempting to make a purchase and employees trying to get a picture of the sales numbers and inventory count. Data from Cosmos DB is going into Kafka Topics via Cosmos DB Source Connectors and then we are using KSQLDB to process the joins of replenishments, sales and returns/refunds in realtime to update another Kafka Topic whose contents are then shipped to AI Search via a Sink Connector.
