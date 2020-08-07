
const GLXFactory = artifacts.require("GLXFactory");
const GLXRouter = artifacts.require("GLXRouter");

module.exports = async function (deployer) {
  await deployer.deploy(GLXFactory);
  await deployer.deploy(GLXRouter, GLXFactory.address);
};
