# FundMe Smart Contract

A Solidity smart contract that allows users to fund an organization while ensuring that **only the contract creator (manager)** can withdraw the accumulated funds.

The contract enforces a **minimum funding value in USD** using **Chainlink Price Feeds**, allowing contributors to send ETH while maintaining a USD-denominated minimum requirement.

---

## Overview

The **FundMe** contract enables decentralized funding by allowing users to contribute ETH to a smart contract. Each contribution must meet a minimum USD value threshold to ensure meaningful participation.

To achieve this, the contract uses **Chainlink's decentralized oracle network** to retrieve the latest ETH/USD price and convert incoming ETH into its USD equivalent.

Only the **contract owner (deployer)** has permission to withdraw the collected funds.

---

## Key Features

- Accept ETH contributions from any user
- Enforce a **minimum funding requirement of 5 USD**
- Convert ETH to USD using **Chainlink Price Feeds**
- Track contributions made by each address
- Restrict withdrawals to the **contract owner**
- Automatically handle direct ETH transfers using `receive()` and `fallback()`
- Gas-efficient withdrawal implementation

---

## Smart Contracts

### `FundMe.sol`

The primary contract responsible for:

- Accepting ETH contributions
- Enforcing the minimum USD funding requirement
- Tracking contributors and their funded amounts
- Allowing the contract owner to withdraw funds

#### Main Functionalities

**Funding**

```solidity
function fund() public payable
```

Users can send ETH to the contract through this function. The contract checks whether the ETH value sent meets the minimum USD requirement using a price conversion library.

```solidity
require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough ETH");
```

If the requirement is met:

- The sender is recorded as a funder
- Their contribution is stored in a mapping

---

**Withdrawal**

```solidity
function withdraw() public onlyOwner
```

Only the contract owner can withdraw funds. The withdrawal process:

1. Resets all recorded contributions
2. Clears the funders list
3. Transfers the entire contract balance to the owner

The transfer is performed using the recommended `call` method.

```solidity
(bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
require(callSuccess, "Call failed");
```

---

**Access Control**

The `onlyOwner` modifier restricts withdrawal functionality to the contract deployer.

```solidity
modifier onlyOwner()
```

A custom error is used for gas efficiency.

```solidity
error NotOwner();
```

---

**Receive and Fallback**

The contract supports direct ETH transfers.

```solidity
receive() external payable
fallback() external payable
```

Both functions automatically redirect the transaction to the `fund()` function.

---

### `PriceConverter.sol`

A Solidity **library** that handles ETH price retrieval and conversion.

The library integrates with **Chainlink's AggregatorV3Interface** to obtain the latest ETH/USD price feed.

#### Main Functions

**Get ETH Price**

```solidity
function getPrice() internal view returns(uint256)
```

Fetches the latest ETH price from Chainlink and converts it into an 18-decimal format for consistency with Solidity's wei units.

---

**Convert ETH to USD**

```solidity
function getConversionRate(uint256 ethAmount) internal view returns(uint256)
```

Converts an ETH amount into its USD equivalent using the latest price feed.

---

**Get Feed Version**

```solidity
function getVersion() internal view returns(uint256)
```

Returns the version of the Chainlink price feed being used.

---

## Chainlink Integration

The contract uses the **ETH/USD Chainlink Price Feed** to obtain reliable off-chain price data.

Price Feed Address:

```
0x694AA1769357215DE4FAC081bf1f309aDC325306
```

This ensures that the minimum funding requirement is based on real market price data rather than hardcoded values.

---

## Minimum Funding Requirement

The contract requires each contribution to be worth **at least 5 USD**.

```solidity
uint256 public constant MINIMUM_USD = 5e18;
```

This value represents **$5 with 18 decimal precision**, matching Ethereum's wei denomination.

---

## Security Considerations

- Only the contract owner can withdraw funds
- Funding must meet a minimum USD value
- State changes occur before transferring funds during withdrawal
- Uses Chainlink's decentralized oracle network for accurate price data
- Custom errors reduce gas costs compared to revert strings

---

## Deployment

1. Compile the contracts using **Solidity ^0.8.18**
2. Deploy the `FundMe` contract
3. Send ETH using the `fund()` function or direct transfers
4. Withdraw funds using the `withdraw()` function (owner only)

---

## Requirements

- Solidity `^0.8.18`
- Chainlink Contracts

Recommended development environments:

- Remix
- Hardhat
- Foundry
