// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.10;

import { SafeMath } from '@openzeppelin/contracts/math/SafeMath.sol';
import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import { SafeERC20 } from '../libraries/SafeERC20.sol';
import { IFlashLoanReceiverV2 } from './IFlashLoanReceiver.sol';
import { ILendingPoolAddressesProviderV2 } from '../flashloans/aave/interfaces/ILendingPoolAddressesProviderV2.sol';
import { ILendingPoolV2 } from '../flashloans/aave/interfaces/ILendingPoolV2.sol';

/** 
    !!!
    Never keep funds permanently on your FlashLoanReceiverBase contract as they could be 
    exposed to a 'griefing' attack, where the stored funds are used by an attacker.
    !!!
 */
abstract contract FlashLoanReceiverBaseV2 is IFlashLoanReceiverV2 {
  using SafeERC20 for IERC20;
  using SafeMath for uint256;

  ILendingPoolAddressesProviderV2 public immutable override ADDRESSES_PROVIDER;
  ILendingPoolV2 public immutable override LENDING_POOL;

  constructor(address provider) public {
    ADDRESSES_PROVIDER = ILendingPoolAddressesProviderV2(provider);
    LENDING_POOL = ILendingPoolV2(ILendingPoolAddressesProviderV2(provider).getLendingPool());
  }

  receive() payable external {}
}
