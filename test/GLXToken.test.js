'use strict';
const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
const { TestHelper } = require('@openzeppelin/cli');
var GLXToken = artifacts.require("GLXToken");

const { expect } = require('chai');

contract('GLXToken', function (accounts) {

    const [sender, receiver] =  accounts;

    beforeEach(async function() {
        //合约实例
        this.gLXToken = await GLXToken.deployed()
    })

    it('should set base info', async function () {
        await this.gLXToken.setMaker(sender)
        expect(sender).to.equal(await this.gLXToken.maker.call())

        const beforeBalance = await this.gLXToken.balanceOf.call(receiver)
        expect(beforeBalance.toNumber()).equal(0);

        await this.gLXToken.makeCoin(receiver, 1000);

        const afterBalance = await this.gLXToken.balanceOf.call(receiver)
        expect(afterBalance.toNumber()).equal(1000);
    })

})