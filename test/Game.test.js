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
var GLXRouter = artifacts.require("GLXRouter");
var MockCErc20 = artifacts.require("MockCErc20");
var GLXGame = artifacts.require("GLXGame");

const { expect } = require('chai');

contract('Game', function (accounts) {

    const [sender, receiver] =  accounts;

    beforeEach(async function() {
        //合约实例
        // this.dai = await MockErc20.deployed()
        // this.hope = await GLXToken.deployed()
        // this.cdai = await MockCErc20.deployed()
        // this.router = await GLXRouter.deployed()
        // this.gLXFactory = await GLXFactory.deployed()
        // // console.log('factory: ' + this.gLXFactory.address)
        // console.log('router: ' + this.router.address)
        // console.log('cdai: ' + this.cdai.address)
        // console.log('hope: ' + this.hope.address)
        // console.log('dai: ' + this.dai.address)
    })

    it('should createGame', async function () {

        this.gLXFactory=  await GLXFactory.at("0x4E8c0faA057Bc6aeDBFd88420D4785e3125CA51B")
        console.log(this.gLXFactory.address)

        const result = await this.gLXFactory.createGame('0x3eBD5291F974E943E18c037960b3816cDcDd553b',
            '0x4969D629Fa7AAaC886D3326CaD983eaE8CE3E6AC', '0xE0bEA5898d8f1C680bB64F8bc09B95f17bC98f7C',
            '0xAc8f813A100f316528c9F6781e081e6f055E26aE', '0xAc8f813A100f316528c9F6781e081e6f055E26aE',
            8452371, 8452471, true, '0x4969D629Fa7AAaC886D3326CaD983eaE8CE3E6AC', 1000)
        const gameAddress = result.receipt.logs[0].args.a
        console.log(gameAddress)
        //
        // const gameExtToken = await this.gLXFactory.getGameExtToken.call(gameAddress)
        // expect(gameExtToken).equal(this.dai.address);
        //
        // this.game = await GLXGame.at(gameAddress)
        //
        // expect(await this.game.factory.call()).equal(this.gLXFactory.address)
    })
    it('should startGame', async function() {
    })

})