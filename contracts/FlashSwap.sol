// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.6.10;

import "@openzeppelin/contracts/access/Ownable.sol";
//import { SafeMath } from '@openzeppelin/contracts/math/SafeMath.sol';
//import { IERC20 } from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import "./exchanges/uniswap/interfaces/IUniswapV2Router02.sol";
import "./exchanges/kyber/KyberNetworkProxy.sol";

contract FlashSwap is Ownable {
  using SafeMath for uint256;

  enum Exchanges{ Uniswap, Kyber, SushiSwap }
  uint public deadline;

  IUniswapV2Router02 public immutable uniswapV2Router;
  KyberNetworkProxy public immutable kyberNetworkProxy;

  constructor(address _uniswapRouterProvider, KyberNetworkProxy _kyberProvider) public {
    uniswapV2Router = IUniswapV2Router02(_uniswapRouterProvider);
    kyberNetworkProxy = _kyberProvider;
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
    } else if(_exchange == uint256(Exchanges.Kyber)) {

    }
  }

  function _uniswap(uint amountIn,  uint amountOutMin, address[] memory path, address to,  uint _deadline) private returns (bool) {
      //IERC20 token = IERC20(path[0]);
      //require (token.approve(address(uniswapV2Router), amountIn), "FlashSwap: Failed to set allowance");
      require(_approveSwap(address(uniswapV2Router), amountIn, path[0]), "FlashSwap: Failed to set allowance");
      uniswapV2Router.swapExactTokensForTokens(amountIn, amountOutMin, path, to, _deadline);
      return true;
  }

  function _kyber(address _src, uint256 _srcAmount, address _dest) private returns (bool) {
      ERC20 srcToken = ERC20(_src);
      ERC20 destToken = ERC20(_dest);

      require(srcToken.approve(address(kyberNetworkProxy), 0));
      require(_approveSwap(address(kyberNetworkProxy), _srcAmount, _src), "FlashSwap: Failed to set allowance");
      (uint256 expectedRate, uint256 worstRate) = kyberNetworkProxy.getExpectedRate(srcToken, destToken, _srcAmount);
      kyberNetworkProxy.swapTokenToToken(IERC20(_src), _srcAmount, IERC20(_dest), expectedRate);
  }

  function _approveSwap(address spender, uint256 amount, address tokenAddress) private returns (bool) {
    IERC20 token = IERC20(tokenAddress);
    require(token.approve(spender, amount), "FlashSwap: Failed to approve");
    return true;
  }

  function getExpectedRate(address _src, address _dest, uint256 amount) public view returns (uint256, uint256) {
    ERC20 srcToken = ERC20(_src);
    ERC20 destToken = ERC20(_dest);

    return kyberNetworkProxy.getExpectedRate(srcToken, destToken, amount);
  }
}

