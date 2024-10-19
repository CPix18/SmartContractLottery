-include .env

.PHONY: all test clean deploy fund help install snapshot format anvil 

DEFAULT_ANVIL_KEY := 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80

help:
	@echo "Usage:"
	@echo "  make deploy [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""
	@echo ""
	@echo "  make fund [ARGS=...]\n    example: make deploy ARGS=\"--network sepolia\""

all: clean remove install update build

# Clean the repo
clean  :; forge clean

# Remove modules
remove :; rm -rf .gitmodules && rm -rf .git/modules/* && rm -rf lib && touch .gitmodules && git add . && git commit -m "modules"

install :; forge install cyfrin/foundry-devops@0.2.2 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@1.1.1 --no-commit && forge install foundry-rs/forge-std@v1.8.2 --no-commit && forge install transmissions11/solmate@v6 --no-commit

# Update Dependencies
update:; forge update

build:; forge build

test :; forge test 

snapshot :; forge snapshot

format :; forge fmt

anvil :; anvil -m 'test test test test test test test test test test test junk' --steps-tracing --block-time 1

make test-fork:
	forge test --fork-url $(SEPOLIA_RPC_URL) --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv
	
make deploy-mainnet:
	forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url $(MAINNET_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

make deploy-sepolia:
	forge script script/DeployRaffle.s.sol:DeployRaffle --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

make deploy-anvil:
	forge script script/DeployRaffle.s.sol:DeployRaffle --private-key $(PRIVATE_KEY) --broadcast --verify -vvvv

make create-sepolia-sub:
	forge script script/Interactions.s.sol:CreateSubscription --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

make add-sepolia-consumer:
	forge script script/Interactions.s.sol:AddConsumer --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

make fund-sepolia-subscription:
	forge script script/Interactions.s.sol:FundSubscription --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

make create-mainnet-sub:
	forge script script/Interactions.s.sol:CreateSubscription --rpc-url $(MAINNET_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

make add-mainnet-consumer:
	forge script script/Interactions.s.sol:AddConsumer --rpc-url $(MAINNET_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

make fund-mainnet-subscription:
	forge script script/Interactions.s.sol:FundSubscription --rpc-url $(MAINNET_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast	

make enter-sepolia-raffle:
	cast send 0x3282332b209D5E109475C4B4FC5ac7760d45EF0F "enterRaffle()" --value 0.01ether --private-key $(PRIVATE_KEY) --rpc-url $(SEPOLIA_RPC_URL)

make enter-mainnet-raffle:
	cast send <Contract-Address> "enterRaffle()" --value 0.01ether --private-key $(PRIVATE_KEY) --rpc-url $(MAINNET_RPC_URL)	

make enter-anvil-raffle:
	cast send <Contract-Address> "enterRaffle()" --value 0.01ether --private-key $(PRIVATE_KEY)
