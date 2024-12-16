# Decentralized Gambling App

A blockchain-based gambling platform leveraging Chainlink VRF (Verifiable Random Function) for secure, provably fair randomness. This decentralized application (dApp) ensures transparency, fairness, and security in all gambling activities by utilizing smart contracts and the Ethereum blockchain.

## Features

- **Decentralized Gambling**: A trustless platform where no central authority controls the outcomes or funds.
- **Provably Fair Randomness**: Outcomes are generated using Chainlink VRF, ensuring tamper-proof, cryptographically secure randomness.
- **Smart Contract-based**: Game logic and payouts are managed through immutable smart contracts deployed on the Ethereum blockchain.
- **Transparency**: All bets, outcomes, and payouts are recorded on-chain, allowing users to verify every transaction.
- **Security**: Funds are securely locked in smart contracts, and payouts are automated, reducing the risk of fraud or mismanagement.
- **Anonymity**: Users can participate without revealing personal information, ensuring privacy.

## Tech Stack

- **Solidity**: Smart contract development for Ethereum blockchain.
- **Ethereum**: Public blockchain for deploying and interacting with the gambling contracts.
- **Chainlink VRF**: Verifiable Random Function for generating provably fair random numbers.
- **Foundry**: Development framework for testing and deploying smart contracts.
- **Forge**: Tool for compiling, testing, and deploying contracts in Foundry.
- **Ethers.js**: JavaScript library to interact with the Ethereum blockchain from the front end.
- **Metamask**: Browser extension for managing Ethereum accounts and interacting with the blockchain.

## Games

The platform supports the following games, with more to be added in the future:

1. **Dice Roll**: Players bet on the outcome of a dice roll.
2. **Coin Flip**: A simple heads-or-tails game with fair odds.


## Installation

### Prerequisites

Before running the project, ensure you have the following installed:

- [Node.js](https://nodejs.org/) (v12.x or higher)
- [Foundry](https://getfoundry.sh/) (install using `curl -L https://foundry.paradigm.xyz | bash`)
- [Metamask](https://metamask.io/) (browser extension for interacting with the Ethereum blockchain)

### Setup Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/targus999/gambling-app.git
   cd gambling-app
