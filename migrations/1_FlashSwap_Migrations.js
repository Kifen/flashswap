const FlashSwap = artifacts.require("FlashSwap");

module.exports = function (deployer) {
  deployer.deploy(FlashSwap, "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D", "0xd719c34261e099Fdb33030ac8909d5788D3039C4", "0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F");
};
