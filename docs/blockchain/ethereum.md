### Ethereum

Ethereum is a decentralized platform that runs smart contracts: applications that run exactly as programmed without any possibility of downtime, censorship, fraud or third party interference.

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


