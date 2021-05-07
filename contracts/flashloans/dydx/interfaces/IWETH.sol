// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.10;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';

interface IWETH is IERC20 {
    function deposit() external payable;
    function withdraw(uint wad) external;
}