require('dotenv').config()

const HDWalletProvider = require('@truffle/hdwallet-provider');
const infuraProjectId = process.env.INFURA_PROJECT_ID;
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim()
//;


module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 7545,
      network_id: "*",
      gas: 8000000,
    },
    ropsten: {
      provider: () => new HDWalletProvider(process.env.DEV_MNEMONIC, "http://parity.test.finance.sparkpool.com:18545"),
      network_id: 3,       // Ropsten's id
      gas: 8000000,
    },
    goerli: {
      provider: () => new HDWalletProvider(process.env.DEV_MNEMONIC, "https://goerli.infura.io/v3/" + infuraProjectId),
      network_id: 5,       // Goerli's id
      gas: 8000000,
    }
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.6.2",
    }
  }
};
