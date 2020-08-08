const { ZWeb3 } = require('@openzeppelin/upgrades');
const CompoundHelper = artifacts.require("CompoundHelper");
const GLXFactory = artifacts.require("GLXFactory");
const GLXRouter = artifacts.require("GLXRouter");
const MockCErc20 = artifacts.require("MockCErc20");
const GLXToken = artifacts.require("GLXToken");
const MockErc20 = artifacts.require("MockErc20");

module.exports = async function (deployer) {
  await deployer.deploy(CompoundHelper);
  await deployer.link(CompoundHelper, GLXFactory);
  const gLXFactory = await deployer.deploy(GLXFactory);
  await deployer.deploy(GLXRouter, GLXFactory.address);
  const mockErc20 = await deployer.deploy(MockErc20, ZWeb3.web3.utils.toWei('1000000000000','ether'));
  await deployer.deploy(MockCErc20, MockErc20.address);
  await deployer.deploy(GLXToken, GLXRouter.address, MockErc20.address);
  // const result = await gLXFactory.createGame(GLXRouter.address, MockErc20.address, GLXToken.address,
  //     MockCErc20.address, '0x18617b737032741B50D0f47e0Ad66ab3cBC94f6d', 8457100, 8457200, true, GLXToken.address, 1000)
  // const gameAddress = result.receipt.logs[0].args.a
  // console.log('gameAddress: ' + gameAddress)
  //cdai充值dai
  await mockErc20.transfer(MockCErc20.address, ZWeb3.web3.utils.toWei('100000000','ether'))
};
