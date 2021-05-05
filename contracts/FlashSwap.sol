// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "./interfaces/exchanges/uniswap/IUniswapV2Router02.sol";

contract FlashSwap is Ownable {

  enum Exchanges{ Uniswap, Kyber, SushiSwap }
  uint constant deadline = 10 minutes;

  IUniswapV2Router02 public immutable uniswapV2Router;

  constructor(address _uniswapRouterProvider) {
    uniswapV2Router = IUniswapV2Router02(_uniswapRouterProvider);
  }

  // modifier validExchanges(uint256[][] memory _exchanges) {
  //   for(uint256 i = 0; i < _exchanges.length; i++) {
  //     require(i <= 2, "FlashSwap: Invalid Exchange");
  //   }
  //   _;
  // }

  modifier checkExchangesAndAssets(address[][] memory assets, uint256[][] memory exchanges) {
    uint256 exchangeCount = exchanges.length;
    uint256 assetsCount = assets.length;
    for(uint256 i = 0; i < assetsCount; i++) {
      require(assets[i].length == 2, "FlashSwap: Invalid Assets Length");
    }

     for(uint256 i = 0; i < exchangeCount; i++) {
      require(exchanges[i].length == assetsCount, "FlashSwap: Invalid Exchanges Length");
    }
    _;
  }

  function flashSwap(address[][] memory assets, uint256[][] memory exchanges, address wallet, uint256 amount) public onlyOwner checkExchangesAndAssets(assets, exchanges) returns (bool) {
    
  }

  function _swap(uint256 _exchange, address _assetIn, address _assetOut, uint amountIn) private returns (bool) {
    //address exchange = getExchange(_exchange, _assetIn, _assetOut);
    if(_exchange == uint256(Exchanges.Uniswap)) {
      address[] memory path = new  address[](2);
      path[0] = _assetIn;
      path[1] = _assetOut;

      uint[] memory amounts = uniswapV2Router.getAmountsOut(amountIn, path);
      uint amountOut = amounts[amounts.length - 1];

      require(_uniswap(amountIn, amountOut, path, address(this), deadline), "FlashSwap: Failed to swap on uniswap");
      return true;
    }
  }

  function _uniswap(uint amountIn,  uint amountOutMin, address[] memory path, address to,  uint _deadline) private returns (bool) {
      IERC20 token = IERC20(path[0]);
      require (token.approve(address(uniswapV2Router), amountIn), "FlashSwap: Failed to set allowance");
      uniswapV2Router.swapExactTokensForTokens(amountIn, amountOutMin, path, to, _deadline);
      return true;
  }

   // function getExchange(uint256 _exchange, address _tokenA, address _tokenB) public view returns (address) {
  //   if(_exchange == uint256(Exchanges.Uniswap)) {
  //     address pairAddress = uniswapV2Factory.getPair(_tokenA, _tokenB);
  //     require(pairAddress != address(0), 'FlashSwap: This pool does not exist');
  //     return pairAddress;
  //   } else if(_exchange == uint256(Exchanges.Uniswap)) {}
  // }
}

