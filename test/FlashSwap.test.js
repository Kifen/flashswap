const { BN, constants, expectEvent, expectRevert,} = require('@openzeppelin/test-helpers');
const { expect, use } = require('chai');

const Token = artifacts.require('TokenMock');
const FlashSwap = artifacts.require('FlashSwap');


contract('FlashSwap', (accounts) => {
  const [owner, beneficiary, alice, bob, carl] =  accounts;
  
})