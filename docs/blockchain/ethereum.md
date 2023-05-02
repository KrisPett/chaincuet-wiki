### Ethereum

Ethereum is a decentralized platform that runs smart contracts: applications that run exactly as programmed without any possibility of downtime, censorship, fraud or third party interference.

#### ERC (Ethereum Request for Comments)

- ERC-20 -> Is the most commonly used standard for creating tokens on Ethereum. This standard defines the functions that a token contract should have, such as the ability to transfer tokens from one address to another, check the balance of an address, and approve others to spend tokens on your behalf.
- ERC-721 -> Is another standard that is used for creating unique, non-fungible tokens (NFTs). These tokens are unique and cannot be exchanged for one another as each token represents a distinct asset.
- ERC-1155 -> Is a newer standard that allows for the creation of both fungible and non-fungible tokens in a single contract. This means that developers can create a contract that can handle a variety of tokens, making it more flexible and efficient.
- 
#### Setup Metamask

Metamask is a browser extension that allows you to interact with the Ethereum blockchain.

- Install Metamask
- Install Ganache -> HTTP://127.0.0.1:7545 (RPC) -> 1337 (chain id) -> ETH (Symbol)
- Use WalletConnect for mobile (web3Modal)

#### Solidity

Solidity is an object-oriented, high-level language for implementing smart contracts.

- Ganache (local blockchain)
- Truffle (development framework)
- Create account Infura (for deploying to testnet)

#### Truffle | Ganache

```
├── build
│   └── contracts
│       ├── Adoption.json
│       └── Migrations.json
├── contracts
│   ├── Adoption.sol
│   └── Migrations.sol
├── migrations
│   ├── 1_initial_migration.js
│   └── 2_deploy_contracts.js
├── package.json
├── package-lock.json
├── src
│   ├── index.html
├── test
└── truffle-config.js
```

- truffle compile (compiles contracts - creates build folder)
- Link truffle in Ganache using truffle-config.js location
- truffle migrate (migrates contracts to blockchain) each migration cost gas
- truffle test (runs tests)

#### NFTs

Nfts are non-fungible tokens. They store metadata on the blockchain and the actual file is stored on IPFS (InterPlanetary File System).

IPFS is a decentralized storage and content-addressed distribution protocol that allows for efficient and secure sharing of files on a global scale.

#### Metadata
```
{
    "name": "My NFT",
    "description": "This is an example NFT",
    "image": "https://example.com/my-nft-image.jpg",
    "external_url": "https://example.com/my-nft",
    "attributes": [
        {
            "trait_type": "Artist",
            "value": "John Doe"
        },
        {
            "trait_type": "Year Created",
            "value": "2021"
        }
    ],
    "s3_bucket_uri": "s3://my-s3-bucket/my-nft-image.jpg"
}
```

#### Infura

Infura is a service that provides access to Ethereum and IPFS networks. It allows developers to build applications without having to run their own nodes.

Use Sepolia testnet for testing.
Get faucet from https://www.infura.io/faucet/sepolia?ref=infura.ghost.io

##### Curl Requests

```
curl https://mainnet.infura.io/v3/<API_KEY> \
    -X POST \
    -H "Content-Type: application/json" \
    --data '{"jsonrpc": "2.0", "id": 1, "method": "eth_blockNumber", "params": []}'
```

```
curl https://mainnet.infura.io/v3/<API_KEY> \
    -X POST \
    -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_getBalance","params": ["0x00000000219ab540356cBB839Cbe05303d7705Fa", "latest"],"id":1}'
```
