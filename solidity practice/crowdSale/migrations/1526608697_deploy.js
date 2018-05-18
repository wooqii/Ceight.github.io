const CeightToken = artifacts.require("./CeightToken");
const CeightTokenSale = artifacts.require("./CeightTokenSale");
const CeightTokenWhitelist = artifacts.require("./CeightTokenWhitelist");

module.exports = function(deployer) {
  // Use deployer to state migration tasks.
  deployer.deploy(CeightToken).then(function () {
    deployer.deploy(CeightTokenWhitelist).then(function () {
      deployer.deploy(CeightTokenSale, CeightToken.address, CeightTokenWhitelist.address);
    });
  });
};
