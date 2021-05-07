// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "../libraries/Account.sol";

// The interface for a contract to be callable after receiving a flash loan
interface ICallee {
    function callFunction(address sender, Account.Info memory accountInfo, bytes memory data) external;
}