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


#### IPFS

IPFS is a peer-to-peer network for storing and sharing data in a distributed file system. It is designed to be a decentralized alternative to the HTTP protocol, which is used to transfer data over the internet.


#### ERC

The term "ERC" stands for Ethereum Request for Comment, which is a protocol proposal for implementing new features or standards on the Ethereum network.


##### ERC-20

ERC-20 is a standard for creating fungible tokens on the Ethereum blockchain.

##### ERC-721

ERC-721 is a standard for creating non-fungible tokens (NFTs) on the Ethereum blockchain. 

##### ERC-1155

ERC-1155 is a standard for creating both fungible and non-fungible tokens on the Ethereum blockchain.

#### OpenZeppelin

OpenZeppelin is an open-source framework for building secure smart contracts on Ethereum. It provides a set of reusable, audited, and community-vetted smart contracts that can be used to build decentralized applications (dApps).

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

#### ABI

ABI stands for Application Binary Interface. It serves as the interface definition for the contract, specifying the functions, events, and data structures that can be accessed from outside the contract.

```
docker run -v ${PWD}:/workdir ethereum/solc:0.8.19-alpine --abi \
--include-path /workdir/node_modules/ \
--base-path . /workdir/contracts/ChaincueNFT.sol \
-o /workdir/abi
```

#### Infura

Infura is a service that provides access to Ethereum and IPFS networks. It allows developers to build applications without having to run their own nodes.

- Use Sepolia testnet for testing.
- Get faucet from https://www.infura.io/faucet/sepolia?ef=infura.ghost.io
- Use https://sepolia.infura.io/v3/Your_API_Key'

#### Faucet (Sepolia)

- https://sepoliafaucet.com/
- https://www.infura.io/faucet/sepolia?ef=infura.ghost.io

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

#### Frontend integration

- web3.js is a JavaScript library for interacting with the Ethereum blockchain.
- ethers.js is a JavaScript library for interacting with the Ethereum blockchain.
- web3Modal is a library that makes it easy to integrate with Ethereum and IPFS.
- wagmi is a collection of React components that make it easy to integrate with Ethereum and IPFS.
##### WalletConnect

**Use WalletConnect for mobile (web3Modal)**

```jsx
<WagmiConfig client={wagmiClient}>
  <HomeView/>
</WagmiConfig>
<Web3Modal projectId={projectId} ethereumClient={ethereumClient}/>
```

##### Example of minting NFT

```jsx
import {CONTRACT_ABI} from "@/contracts/ContractABI";

const Web3 = require('web3');

const CONTRACT_PUBLIC_ADDRESS = "0x000";

export const mintNFTContractWeb3 = async (tokenURI: string) => {
  const web3 = await new Web3(window.ethereum);
  const signer = await web3.eth.getAccounts()
  const contract = new web3.eth.Contract(CONTRACT_ABI, CONTRACT_PUBLIC_ADDRESS);
  return contract.methods.mintNFT(signer[0], tokenURI).send({from: signer[0]});
};
```

