
var Asset = artifacts.require("Asset");

module.exports = function(deployer) {
  deployer.deploy(Asset,
    "Avocado",
    "Avo",);
};