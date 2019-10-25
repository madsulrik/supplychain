# supplychain
POC of an avocado supplychain smart contracts on the ethereum network.


## Quick guide to get the project running
You need to make sure that truffle is installed and ganache-cli. The project also depends on the openzeppling contracts. In this case it utilizes the ERC-721 token standard.

``` sh
npm install -g truffle
npm install -g ganache-cli
npm install
```

Then to get it running on the local blockchain and run the test suite. Start by starting a local blockchain with ganache

``` sh
ganache-cli 
```

then run the truffle commands in a new terminal window
``` sh
truffle compile
truffle migrate
truffle test
```