# Supply Chain DApp

This repository containts an Ethereum DApp that demonstrates a generic Supply Chain flow. The supply chain models a product flow from production to consumption via the following actors:  

*Producer > Distributor > Retailer > Consumer*  
 
 The actors may perform actions which are consequently stored on the blockchain, according to their roles, as defined by access control contracts. More specifically,  
 
 * a *Producer* can produce, process, pack, and sell items
 * a *Distributor* can then buy items for sale and ship them 
 * a *Retailer* can mark an item as received 
 * a *Consumer* can purchase an item
 
 For simplicity, *Retailers* and *Consumers* do not transfer any funds in the process; we can think of the *Distributor* as the great benefactor to our *Retailers* and *Consumers*.

## UML (TODO)

### Activity Diagram

* **Actors & Interactions**
* Represents the flow from one activity to another in the system; captures dynamic behavior of the system.

### Sequence Diagram 

* **Functions**
* Represents interaction between objects in the order in which they take place.

### State Diagram 

* **Enum of states**
* Shows how an object moves through various states.

### Data Model Diagram (Class diagram for smart contracts)

* **Class diagram for smart contracts**

## Libraries

* [Ethereum](https://www.ethereum.org/) - Ethereum is a decentralized platform that runs smart contracts.
* [IPFS](https://ipfs.io/) - IPFS is the Distributed Web; a peer-to-peer hypermedia protocol.
* [Truffle Framework](http://truffleframework.com/) - Truffle is a popular development framework for Ethereum.
* [Truffle HD Wallet Provider](https://www.npmjs.com/package/truffle-hdwallet-provider) - Web3 provider to sign transactions for metamask wallet to Infura hosted Rinkeby network

## Versions

* Truffle ``v5.4.18 (core: 5.4.18)``
* Solidity ``0.8.10 (solc-js)``
* Node ``v14.15.4``
* Web3.js ``v1.5.3``
* Solidity Compiler: ``solc: 0.8.10+commit.fc410830.Emscripten.clang``


## IPFS

## Token Address (Rinkeby Network)

* [Transaction ID](https://rinkeby.etherscan.io/tx/0xd958e9c92807703e8b1eaf015c9ddb39dd7aca4d3f15f53184bd66f06cacf0b6): `` 0xd958e9c92807703e8b1eaf015c9ddb39dd7aca4d3f15f53184bd66f06cacf0b6 ``
* [Contract Address](https://rinkeby.etherscan.io/address/0xe87086644841acfc50387782b1a6952f3288a33f): `` 0xe87086644841acfc50387782b1a6952f3288a33f  ``


