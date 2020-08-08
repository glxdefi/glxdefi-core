'use strict';
const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
const { TestHelper } = require('@openzeppelin/cli');
const { ZWeb3 } = require('@openzeppelin/upgrades');
var MockErc20 = artifacts.require("MockErc20");
var GLXToken = artifacts.require("GLXToken");
var GLXFactory = artifacts.require("GLXFactory");
var GLXRouter = artifacts.require("GLXRouter");
var MockCErc20 = artifacts.require("MockCErc20");
var GLXGame = artifacts.require("GLXGame");

const { expect } = require('chai');

contract('Game', function (accounts) {

    const [sender, liquidPool, player1] =  accounts;

    console.log('sender: ' + sender)
    console.log('liquidPool: ' + liquidPool)
    console.log('player1: ' + player1)

    beforeEach(async function() {
        //合约实例
        this.gLXFactory = await GLXFactory.at('0x3D78d80Ebddef4bBfEa95211Bb09C628b5f6BfC8')
        this.router = await GLXRouter.at('0x6E4A62f2ddc3350031A6C1FAbF5E5456C2766955')
        this.game = await GLXGame.at('0xf7888E1A137Bd58eb7d022572b2708A3cE743319')
        this.dai = await MockErc20.at('0xED60D292438fDE4733e6DfB166A196e9e8443642')
    })

    it('should createGame', async function () {

        // const result = await this.gLXFactory.createGame('0x6E4A62f2ddc3350031A6C1FAbF5E5456C2766955', '0xED60D292438fDE4733e6DfB166A196e9e8443642',
        //     '0x1E75c133bA496Bf24D718555A732538E2D0B7111', '0x374a4c09B5eA23324eE073eb00EFBca346CEc389',
        //     liquidPool, 8456787, 8456788, true, '0xED60D292438fDE4733e6DfB166A196e9e8443642', 1000)
        // const gameAddress = result.receipt.logs[0].args.a
        // console.log(gameAddress)
    })
    it('should bet', async function () {
        // const betDaiAmount = ZWeb3.web3.utils.toWei('10','ether')
        // await this.dai.approve(this.router.address, betDaiAmount)
        // await this.router.bet(this.game.address, true, betDaiAmount)
    })
    it('should receive', async function () {
        await this.router.receiveIncome(this.game.address)
    })
})