// SPDX-License-Identifier: agpl-3.0
pragma solidity ^0.6.10;
pragma experimental ABIEncoderV2;

import "../libraries/Account.sol";
import "../libraries/Actions.sol";

interface ISoloMargin {
    function operate(Account.Info[] memory accounts, Actions.ActionArgs[] memory actions) external;
}