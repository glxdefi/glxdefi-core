require('dotenv').config()

const HDWalletProvider = require('@truffle/hdwallet-provider');
const infuraProjectId = process.env.INFURA_PROJECT_ID;
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim()
//;


module.exports = {
  networks: {
    ropsten: {
      provider: () => new HDWalletProvider(process.env.DEV_MNEMONIC, "https://ropsten.infura.io/v3/" + infuraProjectId),
      network_id: 3,       // Ropsten's id
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
