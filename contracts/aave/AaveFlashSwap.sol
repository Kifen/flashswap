// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.10;

import "./FlashLoanReceiverBaseV2.sol";
import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "@openzeppelin/contracts/access/Ownable.sol";
import "../FlashSwap.sol";

contract AaveFlashSwap is FlashLoanReceiverBaseV2, Ownable {

  constructor(address _addressProvider) FlashLoanReceiverBaseV2(_addressProvider) public {}

  function executeOperation(
  address[] calldata assets,
  uint256[] calldata amounts,
  uint256[] calldata premiums,
  address initiator,
  bytes calldata params
) external override returns (bool) {
   //Approve the LendingPool contract allowance to *pull* the owed amount
    for (uint i = 0; i < assets.length; i++) {
        uint amountOwing = amounts[i].add(premiums[i]);
        IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
    }
        
    return true;
}

function performFlashSwap(address _coin, uint256 _amount, address[] memory assets, uint256[] memory exchanges) public onlyOwner {
    address[] memory _coins = new address[](1);
    _coins[0] = _coin;

    uint256[] memory _amounts = new uint256[](1);
    _amounts[0] = _amount;

    address receiverAddress = address(this);
    address onBehalfOf = address(this);
    //bytes memory params = abi.encodeWithSelector(flashSwap.flashSwap.selector, assets, exchanges, _amount);
    bytes memory params = "";
    uint16 referralCode = 0;
    uint256[] memory modes = new uint256[](_coins.length);

    // 0 = no debt (flash), 1 = stable, 2 = variable
    for (uint256 i = 0; i < _coins.length; i++) {
        modes[i] = 0;
    }

     LENDING_POOL.flashLoan(
            receiverAddress,
            _coins,
            _amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
}

}