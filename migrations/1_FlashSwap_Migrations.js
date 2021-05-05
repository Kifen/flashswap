const FlashSwap = artifacts.require("FlashSwap");

module.exports = function (deployer) {
  deployer.deploy(FlashSwap, "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D");
};
