

const MockErc20 = artifacts.require("MockErc20");
const MockCErc20 = artifacts.require("MockCErc20");
const FinCompound = artifacts.require("FinCompound");
const GLXToken = artifacts.require("GLXToken");

module.exports = async function (deployer) {
  await deployer.deploy(MockErc20, 100);
  await deployer.deploy(MockCErc20);
  await deployer.deploy(FinCompound);
  await deployer.deploy(GLXToken);
};
