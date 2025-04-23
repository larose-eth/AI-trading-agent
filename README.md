# AI-trading-agent

## Overview

The **AI Market Pricing and Trading Agent** is a decentralized smart contract designed to empower informal traders. It helps traders track local market trends, find competitive pricing tips, access bulk deals, and make informed purchasing and sales decisions. This contract provides an essential tool for traders in informal sectors, offering insights into pricing, trends, and product availability in real-time.

---

## Features

- **Product Registration**: Traders can register products to be tracked and traded.
- **Price Reporting**: Traders can report prices for specific products, contributing to a decentralized price-tracking system.
- **Market Trends**: The contract computes and stores market trends, including average prices for 7 and 30 days, for each product.
- **Bulk Deals**: Traders can post bulk deals for products, providing other traders with opportunities to purchase in larger quantities at competitive prices.
- **Personalized Recommendations**: The system provides product recommendations based on a trader's profile, location, and preferences.

---

## Contract Structure

The contract is built using **Clarity**, a smart contract language specifically designed for the Stacks blockchain. Here are the key components of the smart contract:

### Data Structures
- **Products**: Keeps track of the registered products including their name, category, and creator.
- **Price History**: Records the reported prices of products, along with details of the reporter (trader) and the location.
- **Bulk Deals**: Stores details of bulk deals for a product, including the price, quantity, location, and contact information.
- **Market Trends**: Tracks the average price trends over the past 7 and 30 days for each product.
- **User Profiles**: Stores information about each trader, including their location, preferred categories, reputation, and the date they joined.

### Functions
- **Register Product**: Allows traders to register a new product for tracking.
- **Report Price**: Allows traders to report prices for a product, which is stored in the price history and updates market trends.
- **Post Bulk Deal**: Allows traders to create and post bulk deals for products, making it available for other traders.
- **Update Profile**: Traders can update their profile with their location and preferred product categories.

---

## Setup and Installation

To deploy and interact with this contract, follow these steps:

### Prerequisites

- **Stacks Wallet**: To interact with the contract on the Stacks blockchain, you’ll need a Stacks wallet.
- **Clarity Development Tools**: You will need the Stacks CLI tools to deploy and test the contract. Ensure that you have Clarity set up on your machine.
  - [Stack CLI Installation](https://www.blockstack.org/)
  
### Deployment

1. **Deploy the Contract**: Deploy the contract to the Stacks blockchain using the Stacks CLI or your preferred Clarity deployment method.
2. **Interact with the Contract**: Once deployed, you can interact with the contract functions via the Stacks Wallet or any interface that supports interacting with Clarity smart contracts.

---

## Contract Functions

### Read-Only Functions

1. **`get-product(product-id: uint)`**:
   - Retrieves details of a registered product using its product ID.
   - **Returns**: Product details or an error if not found.

2. **`get-market-trend(product-id: uint)`**:
   - Retrieves the market trend (e.g., average prices) for a given product.
   - **Returns**: Market trend details or an error if not found.

3. **`get-bulk-deals-for-product(product-id: uint)`**:
   - Retrieves bulk deals for a specific product.
   - **Returns**: List of bulk deals or an empty list.

4. **`get-recommendations(trader: principal)`**:
   - Provides personalized product recommendations for a trader based on their profile.
   - **Returns**: A list of product recommendations.

### Public Functions

1. **`register-product(name: string, category: string)`**:
   - Registers a product for tracking.
   - **Parameters**:
     - `name`: The name of the product.
     - `category`: The category under which the product falls.
   - **Returns**: The product ID of the registered product.

2. **`report-price(product-id: uint, price: uint, location: string, notes: optional string)`**:
   - Allows a trader to report the price of a product.
   - **Parameters**:
     - `product-id`: The ID of the product.
     - `price`: The reported price.
     - `location`: The location where the product price was reported.
     - `notes`: Optional notes about the price report.
   - **Returns**: A boolean indicating success.

3. **`post-bulk-deal(product-id: uint, quantity: uint, total-price: uint, location: string, expiry: uint, contact: string)`**:
   - Allows a trader to post a bulk deal for a product.
   - **Parameters**:
     - `product-id`: The ID of the product.
     - `quantity`: The quantity in the bulk deal.
     - `total-price`: The total price for the bulk deal.
     - `location`: The location where the deal is posted.
     - `expiry`: The expiry timestamp for the deal.
     - `contact`: The contact information for the deal.
   - **Returns**: The deal ID of the posted bulk deal.

4. **`update-profile(location: string, preferred-categories: list<string>)`**:
   - Allows a trader to update their profile with their location and product preferences.
   - **Parameters**:
     - `location`: The trader's location.
     - `preferred-categories`: A list of product categories the trader prefers.
   - **Returns**: A boolean indicating success.

---

## Error Codes

This contract includes error handling for various issues:

- **ERR_UNAUTHORIZED**: Unauthorized action attempted.
- **ERR_PRODUCT_EXISTS**: The product is already registered.
- **ERR_PRODUCT_NOT_FOUND**: The specified product does not exist.
- **ERR_INVALID_PRICE**: The price specified is invalid (e.g., less than or equal to zero).
- **ERR_INVALID_QUANTITY**: The quantity specified is invalid (e.g., less than or equal to zero).
- **ERR_INVALID_DEAL**: The deal is invalid (e.g., expired).

---

## Security Considerations

- **Access Control**: The contract ensures that only authorized users can modify critical data (like registering products and posting bulk deals).
- **Data Integrity**: The contract validates inputs to ensure that prices, quantities, and deal details are correct and meaningful.
- **Reputation System**: The profile system helps build trader credibility and prevents fraudulent activity.

---

## Conclusion

The **AI Market Pricing and Trading Agent** is a blockchain-powered tool designed to benefit informal traders by offering an open, transparent, and decentralized market platform. By providing real-time insights into pricing, trends, and bulk deals, this smart contract fosters an ecosystem where small traders can thrive in a competitive market.

For any issues or contributions, please feel free to open an issue or submit a pull request!

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
