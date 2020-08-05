const BCToken = artifacts.require("BCToken");

module.exports = function (deployer) {
  deployer.deploy(BCToken, 10000);
};
