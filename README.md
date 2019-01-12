# Applying Blockchain Technology for Land Ownership Management of Bangladesh

## What is this repository for?

* Thesis topic about developing a smart contract using Ethereum blockchain to have serverless online land ownership management system.
* Version: 1.0

## How do I get set up?
* install [ganache-cli](https://github.com/trufflesuite/ganache-cli).
* Install [metamask](https://metamask.io/).
* Run ganache-cli.
```bash
ganache-cli -l 1000000000
```
* Import one of the accounts in metamask which is provided by ganache-cli.
* Use Online Solidity compiler [remix](https://remix.ethereum.org/#optimize=false&version=soljson-v0.4.25+commit.59dbf8f1.js/) to deploy smart contract.
* Compiler version should be 0.4.25+commit.59dbf8f1.
* Copy content of Contract/LandRegistry.sol in remix. and deploy the contract.
* Copy contract address from remix and edit Asset/Js/web3init.js.
```js
var contract = LandContract.at('contact address goes here');
```
* Now run web application. 

## Contributors

J. M. Ashfiqur Rahman,
Student ID: 150231,
CSE Discipline, Khulna University,
Bangladesh.

Anisha Tasnim,
Student ID: 150213,
CSE Discipline, Khulna University,
Bangladesh.

## Supervisors

Dr. Kazi Masudul Alam,
Associate Professor,
Computer Science and Engineering Discipline,
Khulna University,
Bangladesh.

Dr. Abu Shamim Mohammad Arif,
Professor,
Computer Science and Engineering Discipline,
Khulna University,
Bangladesh.