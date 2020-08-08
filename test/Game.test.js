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
        this.dai = await MockErc20.deployed()
        this.hope = await GLXToken.deployed()
        this.cdai = await MockCErc20.deployed()
        this.router = await GLXRouter.deployed()
        this.gLXFactory = await GLXFactory.deployed()
        console.log('factory: ' + this.gLXFactory.address)
        console.log('router: ' + this.router.address)
        console.log('cdai: ' + this.cdai.address)
        console.log('hope: ' + this.hope.address)
        console.log('dai: ' + this.dai.address)
    })

    it('should createGame', async function () {

        let result = await this.gLXFactory.createGame(this.router.address, this.dai.address, this.hope.address,
            this.cdai.address, liquidPool, 1000, 10001, true, this.dai.address, 1000)
        console.log(result)

        result = await this.gLXFactory.createGame(this.router.address, this.dai.address, this.hope.address,
            this.cdai.address, liquidPool, 1001, 10002, true, this.dai.address, 1000)
        console.log(result)

        result = await this.gLXFactory.createGame(this.router.address, this.dai.address, this.hope.address,
            this.cdai.address, liquidPool, 1002, 10003, true, this.dai.address, 1000)
        console.log(result)
        // const gameAddress = result.receipt.logs[0].args.a
        //
        // const gameExtToken = await this.gLXFactory.getGameExtToken.call(gameAddress)
        // expect(gameExtToken).equal(this.dai.address);
        //
        // this.game = await GLXGame.at(gameAddress)
        // console.log('game: ' + this.game.address)

        // const gameApr = await this.game.getApr.call()
        // console.log(gameApr.toNumber())

        // expect(await this.game.factory.call()).equal(this.gLXFactory.address)
    })
    it('should run game', async function() {
        // 准备dai
        // let player1DaiBalance = ZWeb3.web3.utils.toWei('100','ether')
        // await this.dai.transfer(player1, player1DaiBalance)
        // player1DaiBalance = await this.dai.balanceOf.call(player1)
        // expect(ZWeb3.web3.utils.fromWei(player1DaiBalance, 'ether')).equal('100')
        //
        // //下注 - app
        // const betDaiAmount = ZWeb3.web3.utils.toWei('1','ether')
        // await this.dai.approve(this.router.address, betDaiAmount, {from: player1})
        // await this.router.bet(this.game.address, true, betDaiAmount, {from: player1})
        // player1DaiBalance = await this.dai.balanceOf.call(player1)
        // expect(ZWeb3.web3.utils.fromWei(player1DaiBalance, 'ether')).equal('99')
        //
        // expect(ZWeb3.web3.utils.fromWei(await this.game.trueAmountMap.call(player1), 'ether')).equal('1')
        //
        // //更新结果
        // await this.router.updateGameResult(this.game.address)
        //
        // //领奖
        // await this.router.getIncome(this.game.address, {from: player1})

    })

})