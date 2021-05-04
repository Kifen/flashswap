pragma solidity >=0.6.0 <0.9.0;

import "./aave/FlashLoanReceiverBaseV2.sol"

contract FlashSwap is FlashLoanReceiverBaseV2 {

  constructor(address _aaveProvider) FlashLoanReceiverBaseV2(_aaveProvider) public {}

  function aaveFlashLoan(address[] memory assets, address[] memory )
}

