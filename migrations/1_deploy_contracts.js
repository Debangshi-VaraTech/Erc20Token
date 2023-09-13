var BondToken = artifacts.require("BondToken");

module.exports = function(deployer) {
  deployer.deploy(BondToken,"ABC12","ABC12",100);
};
