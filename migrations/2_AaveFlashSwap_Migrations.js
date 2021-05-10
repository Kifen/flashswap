const AaveFlashSwap = artifacts.require("AaveFlashSwap");

module.exports = function (deployer) {
  deployer.deploy(AaveFlashSwap, "0x88757f2f99175387ab4c6a4b3067c77a695b0349");
};
