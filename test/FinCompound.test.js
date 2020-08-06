'use strict';
const {
    BN,           // Big Number support
    constants,    // Common constants, like the zero address and largest integers
    expectEvent,  // Assertions for emitted events
    expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');
const { TestHelper } = require('@openzeppelin/cli');
var MockErc20 = artifacts.require("MockErc20");
var MockCErc20 = artifacts.require("MockCErc20");
var FinCompound = artifacts.require("FinCompound");

const { expect } = require('chai');

contract('FinCompound', function (accounts) {

    const [sender, receiver] =  accounts;

    beforeEach(async function() {
        //合约实例
        this.mockErc20 = await MockErc20.deployed()
        this.mockCErc20 = await MockCErc20.deployed()
        this.finCompound = await FinCompound.deployed()
    })

    it('should set base info', async function () {
        await this.finCompound.setTokenAddress(this.mockErc20.address, this.mockCErc20.address)
        await this.mockCErc20.setTokenAddress(this.mockErc20.address)
        expect(this.mockErc20.address).to.equal(await this.finCompound.erc20Address.call())
        expect(this.mockCErc20.address).to.equal(await this.finCompound.cerc20Address.call())
        expect(this.mockErc20.address).to.equal(await this.mockCErc20.erc20Address.call())
    })
    it('should transfer token to finCompound', async function () {

        const beforeBalance = await this.mockErc20.balanceOf.call(this.finCompound.address)
        expect(beforeBalance.toNumber()).equal(0);

        await this.mockErc20.transfer(this.finCompound.address, 100)

        const afterBalance = await this.mockErc20.balanceOf.call(this.finCompound.address)
        expect(afterBalance.toNumber()).equal(100);
    })
    it('should supplyErc20 to cerc20', async function () {

        const finCompoundBeforeBalanceInCerc20 = await this.mockCErc20.balanceOf.call(this.finCompound.address)
        expect(finCompoundBeforeBalanceInCerc20.toNumber()).equal(0);

        const cerc20BeforeBalance = await this.mockErc20.balanceOf.call(this.mockCErc20.address)
        expect(cerc20BeforeBalance.toNumber()).equal(0);

        const finCompoundBeforeBalance = await this.mockErc20.balanceOf.call(this.finCompound.address)

        await this.finCompound.supplyErc20(finCompoundBeforeBalance.toNumber())

        const finCompoundAfterBalance = await this.mockErc20.balanceOf.call(this.finCompound.address)
        expect(finCompoundAfterBalance.toNumber()).equal(0);

        const cerc20AfterBalance = await this.mockErc20.balanceOf.call(this.mockCErc20.address)
        expect(cerc20AfterBalance.toNumber()).equal(finCompoundBeforeBalance.toNumber());

        const finCompoundAfterBalanceInCerc20 = await this.mockCErc20.balanceOf.call(this.finCompound.address)
        expect(finCompoundAfterBalanceInCerc20.toNumber()).equal(cerc20AfterBalance.toNumber());

    })
    it('should redeemErc20 from cerc20', async function () {

        const finCompoundBeforeBalanceInCerc20 = await this.mockCErc20.balanceOf.call(this.finCompound.address)
        expect(finCompoundBeforeBalanceInCerc20.toNumber()).greaterThan(0);

        const finCompoundBeforeBalance = await this.mockErc20.balanceOf.call(this.finCompound.address)
        expect(finCompoundBeforeBalance.toNumber()).equal(0);

        await this.finCompound.redeemErc20(finCompoundBeforeBalanceInCerc20.toNumber())

        const finCompoundAfterBalanceInCerc20 = await this.mockCErc20.balanceOf.call(this.finCompound.address)
        expect(finCompoundAfterBalanceInCerc20.toNumber()).equal(0);

        const finCompoundAfterBalance = await this.mockErc20.balanceOf.call(this.finCompound.address)
        expect(finCompoundAfterBalance.toNumber()).equal(finCompoundBeforeBalanceInCerc20.toNumber());

    })

})