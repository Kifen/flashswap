// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.6.0 <0.9.0;

interface IWETH {
    function deposit() external payable;
    function transfer(address to, uint value) external returns (bool);
    function withdraw(uint) external;
}