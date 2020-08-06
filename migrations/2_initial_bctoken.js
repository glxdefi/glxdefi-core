const GLXToken = artifacts.require("GLXToken");

module.exports = function (deployer) {
  deployer.deploy(GLXToken, 10000);
};
