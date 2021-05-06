
// SPDX-License-Identifier: agpl-3.0

pragma solidity >=0.5.16 <0.8.0;

import { ILendingPoolAddressesProviderV2 } from '../flashloans/aave/interfaces/ILendingPoolAddressesProviderV2.sol';
import { ILendingPoolV2 } from '../flashloans/aave/interfaces/ILendingPoolV2.sol';

/**
 * @title IFlashLoanReceiverV2 interface
 * @notice Interface for the Aave fee IFlashLoanReceiver.
 * @author Aave
 * @dev implement this interface to develop a flashloan-compatible flashLoanReceiver contract
 **/
interface IFlashLoanReceiverV2 {
  function executeOperation(
    address[] calldata assets,
    uint256[] calldata amounts,
    uint256[] calldata premiums,
    address initiator,
    bytes calldata params
  ) external returns (bool);

  function ADDRESSES_PROVIDER() external view returns (ILendingPoolAddressesProviderV2);

  function LENDING_POOL() external view returns (ILendingPoolV2);
}