# Foundry Smart Contract Lottery

## Personal notes

1. This code creates a provably random lottery using Chainlink VRF and Automation


## What we want it to do?

1. Users can pay for a ticket
  1. The ticket fees are going to go to the winner 
2. After some amount of time, the lottery will auto pick a winner
  1. Programatically
  2. Use Chainlink VRF (Randomness) & Chainlink Automation (Time-Based Trigger)

## Learning to create NatSpec Section in contract (Goes above contract, below pragma)

## Error handling
1. doesn't make sense to use require any more bc of gas
2. use revert

1. name error messages right under contract declaration
   1. error Raffle__NotEnoughEthSent as an example (Two underscores after contract name then error)

## Create Chainlink VRF Subscription

https://vrf.chain.link/sepolia/new

1. Connect Wallet and approve transaction
2. Get test LINK and ETH
3. Create Subscription using Metamask
4. Fund Subscription

## Create Chainlink Automation Account

https://automation.chain.link/

1. Register New Upkeep
2. Use custom logic
3. Fill in blanks

## State Variables 
1. cheaper to make all upper case (goes right under error message or contract name)

## Modulo function is goofy

1. It works more like take the first set of numbers and see what is left over 2334502 % 10 is just the 2 at the end bc it's what is left over

## CEI: Checks Effects and Interactions
1. do checks (require if--> error) early in function (more gas efficient)
2. do effect after checks
3. interactions with other contracts come later
   1. events come before interactions

## You can make reverts with numerous variables in them
1. error My__Error(uint256 someVariable, uint256 anotherVariable);
2. revert My_Error(address(this.balance), anotherVariable.length);

## Cyfrin ReadMe

This is a section from the Cyfrin Foundry Solidity Course.

Huge shout out to Patrick Collins for making all this!

*[⭐️ (3:04:09) | Lesson 9: Foundry Smart Contract Lottery](https://www.youtube.com/watch?v=sas02qSFZ74&t=11049s)*

- [Foundry Smart Contract Lottery](#foundry-smart-contract-lottery)
  - [Personal notes](#personal-notes)
  - [What we want it to do?](#what-we-want-it-to-do)
  - [Learning to create NatSpec Section in contract (Goes above contract, below pragma)](#learning-to-create-natspec-section-in-contract-goes-above-contract-below-pragma)
  - [Error handling](#error-handling)
  - [Create Chainlink VRF Subscription](#create-chainlink-vrf-subscription)
  - [Create Chainlink Automation Account](#create-chainlink-automation-account)
  - [State Variables](#state-variables)
  - [Modulo function is goofy](#modulo-function-is-goofy)
  - [CEI: Checks Effects and Interactions](#cei-checks-effects-and-interactions)
  - [You can make reverts with numerous variables in them](#you-can-make-reverts-with-numerous-variables-in-them)
  - [Cyfrin ReadMe](#cyfrin-readme)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Quickstart](#quickstart)
- [Usage](#usage)
  - [Start a local node](#start-a-local-node)
  - [Library](#library)
  - [Deploy](#deploy)
  - [Deploy - Other Network](#deploy---other-network)
  - [Testing](#testing)
    - [Test Coverage](#test-coverage)
- [Deployment to a testnet or mainnet](#deployment-to-a-testnet-or-mainnet)
  - [Scripts](#scripts)
  - [Estimate gas](#estimate-gas)
- [Formatting](#formatting)

# Getting Started

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

## Quickstart

```
git clone https://github.com/CPix18/FoundrySmartLottery
cd FoundrySmartLottery
forge build
```
# Usage

## Start a local node

```
make anvil
```

## Library

If you're having a hard time installing the chainlink library, you can optionally run this command. 

```
forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit
```

## Deploy

This will default to your local node. You need to have it running in another terminal in order for it to deploy.

```
make deploy
```

## Deploy - Other Network

[See below](#deployment-to-a-testnet-or-mainnet)

## Testing

We talk about 4 test tiers in the video.

1. Unit
2. Integration
3. Forked
4. Staging

This repo we cover #1 and #3.

```
forge test
```

or

```
forge test --fork-url $SEPOLIA_RPC_URL
```

### Test Coverage

```
forge coverage
```

# Deployment to a testnet or mainnet

1. Setup environment variables

You'll want to set your `SEPOLIA_RPC_URL` and `PRIVATE_KEY` as environment variables. You can add them to a `.env` file, similar to what you see in `.env.example`.

- `PRIVATE_KEY`: The private key of your account (like from [metamask](https://metamask.io/)). **NOTE:** FOR DEVELOPMENT, PLEASE USE A KEY THAT DOESN'T HAVE ANY REAL FUNDS ASSOCIATED WITH IT.
  - You can [learn how to export it here](https://metamask.zendesk.com/hc/en-us/articles/360015289632-How-to-Export-an-Account-Private-Key).
- `SEPOLIA_RPC_URL`: This is url of the sepolia testnet node you're working with. You can get setup with one for free from [Alchemy](https://alchemy.com/?a=673c802981)

Optionally, add your `ETHERSCAN_API_KEY` if you want to verify your contract on [Etherscan](https://etherscan.io/).

1. Get testnet ETH

Head over to [faucets.chain.link](https://faucets.chain.link/) and get some testnet ETH. You should see the ETH show up in your metamask.

2. Deploy

```
make deploy ARGS="--network sepolia"
```

This will setup a ChainlinkVRF Subscription for you. If you already have one, update it in the `scripts/HelperConfig.s.sol` file. It will also automatically add your contract as a consumer.

3. Register a Chainlink Automation Upkeep

[You can follow the documentation if you get lost.](https://docs.chain.link/chainlink-automation/compatible-contracts)

Go to [automation.chain.link](https://automation.chain.link/new) and register a new upkeep. Choose `Custom logic` as your trigger mechanism for automation. Your UI will look something like this once completed:

![Automation](./img/automation.png)

## Scripts

After deploying to a testnet or local net, you can run the scripts.

Using cast deployed locally example:

```
cast send <RAFFLE_CONTRACT_ADDRESS> "enterRaffle()" --value 0.1ether --private-key <PRIVATE_KEY> --rpc-url $SEPOLIA_RPC_URL
```

or, to create a ChainlinkVRF Subscription:

```
make createSubscription ARGS="--network sepolia"
```

## Estimate gas

You can estimate how much gas things cost by running:

```
forge snapshot
```

And you'll see an output file called `.gas-snapshot`

# Formatting

To run code formatting:

```
forge fmt
```

If you appreciated this, feel free to follow me or donate!

ETH/Arbitrum/Optimism/Polygon/etc Address:
0x75C875c4b81D792797c6ccCe724c03FE8d31FE0e

[![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://x.com/0xL2Explorer)
[![Linkedin](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/collinpixley/)