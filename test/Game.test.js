'use strict';
const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
const { TestHelper } = require('@openzeppelin/cli');
var MockErc20 = artifacts.require("MockErc20");
var GLXToken = artifacts.require("GLXToken");
var GLXFactory = artifacts.require("GLXFactory");
var MockCErc20 = artifacts.require("MockCErc20");

const { expect } = require('chai');

contract('Game', function (accounts) {

    const [sender, receiver] =  accounts;

    beforeEach(async function() {
        //合约实例
        this.dai = await MockErc20.deployed()
        this.hope = await GLXToken.deployed()
        this.cdai = await MockCErc20.deployed()
        this.gLXFactory = await GLXFactory.deployed()
    })

    it('should createGame', async function () {
        const a = await this.gLXFactory.createGame(this.dai.address, this.hope.address, this.cdai.address, 10000, 10100, true, this.dai.address, 1000)
        console.log(a)
    })

})