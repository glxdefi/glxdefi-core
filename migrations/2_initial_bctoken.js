const { ZWeb3 } = require('@openzeppelin/upgrades');
const CompoundHelper = artifacts.require("CompoundHelper");
const GLXFactory = artifacts.require("GLXFactory");
const GLXRouter = artifacts.require("GLXRouter");
const MockCErc20 = artifacts.require("MockCErc20");
const GLXToken = artifacts.require("GLXToken");
const MockErc20 = artifacts.require("MockErc20");

module.exports = async function (deployer) {
  // await deployer.deploy(CompoundHelper);
  // await deployer.link(CompoundHelper, GLXFactory);
  // await deployer.deploy(GLXFactory);
  // await deployer.deploy(GLXRouter, GLXFactory.address);
  // await deployer.deploy(MockErc20, ZWeb3.web3.utils.toWei('1000000','ether'));
  // await deployer.deploy(MockCErc20, MockErc20.address);
  // await deployer.deploy(GLXToken, GLXRouter.address, MockErc20.address);
};
