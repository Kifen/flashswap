// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import { SafeMath } from '@openzeppelin/contracts/math/SafeMath.sol';
import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "./interfaces/exchanges/uniswap/IUniswapV2Router02.sol";

contract FlashSwap is Ownable {
  using SafeMath for uint256;

  enum Exchanges{ Uniswap, Kyber, SushiSwap }
  uint public deadline;

  IUniswapV2Router02 public immutable uniswapV2Router;

  constructor(address _uniswapRouterProvider) public {
    uniswapV2Router = IUniswapV2Router02(_uniswapRouterProvider);
    deadline = block.timestamp + 300;
  }

  modifier validExchanges(uint256[] memory _exchanges) {
    for(uint256 i = 0; i < _exchanges.length; i++) {
      require(i <= 2, "FlashSwap: Invalid Exchange");
    }
    _;
  }

  function flashSwap(address[] memory assets, uint256[] memory exchanges, uint256 amount) public validExchanges(exchanges)onlyOwner  returns (bool) {
    address input = assets[0];
    address output = assets[1] ;
    uint256 assetCount = 0;
    uint256 exchangeCount = 0;

    while(assetCount < assets.length) {
      address _assetIn = input;
      address _assetOut = output;
      swap(exchanges[exchangeCount], _assetIn, _assetOut, amount);
      exchangeCount.add(1);
      assetCount.add(1);
      input = assets[assetCount];
      output = assets[assetCount + 1];
    }
  }

  function swap(uint256 _exchange, address _assetIn, address _assetOut, uint amountIn) public returns (bool) {
    if(_exchange == uint256(Exchanges.Uniswap)) {
      address[] memory path = new  address[](2);
      path[0] = _assetIn;
      path[1] = _assetOut;

      uint[] memory amounts = uniswapV2Router.getAmountsOut(amountIn, path);
      uint amountOut = amounts[amounts.length - 1];

      _uniswap(amountIn, amountOut, path, address(this), deadline);
      return true;
    }
  }

  function _uniswap(uint amountIn,  uint amountOutMin, address[] memory path, address to,  uint _deadline) private returns (bool) {
      IERC20 token = IERC20(path[0]);
      require (token.approve(address(uniswapV2Router), amountIn), "FlashSwap: Failed to set allowance");
      uniswapV2Router.swapExactTokensForTokens(amountIn, amountOutMin, path, to, _deadline);
      return true;
  }

  //  function getExchange(uint256 _exchange, address _tokenA, address _tokenB) public view returns (address) {
  //   if(_exchange == uint256(Exchanges.Uniswap)) {
  //     address pairAddress = uniswapV2Factory.getPair(_tokenA, _tokenB);
  //     require(pairAddress != address(0), 'FlashSwap: This pool does not exist');
  //     return pairAddress;
  //   } else if(_exchange == uint256(Exchanges.Uniswap)) {}
  // }
}

