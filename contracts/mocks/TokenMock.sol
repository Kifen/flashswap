// SPDX-License-Identifier: MIT
pragma solidity ^0.6.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract TokenMock is ERC20, Ownable {
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals
    )
    public
    ERC20(name, symbol)
    {
        _setupDecimals(decimals);
    }

    function mint(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) external onlyOwner {
        _burn(account, amount);
    }
}