'use strict';
const { TestHelper } = require('@openzeppelin/cli');
var BCToken = artifacts.require("BCToken");

const { expect } = require('chai');

contract('BCToken', function (accounts) {

    beforeEach(async function() {
        var bcToken = await BCToken.deployed()
        console.log(bcToken.address)
    })

    it('test info', async function () {

        var bctokenInstance;

        return BCToken.deployed().then(function (instance) {
            bctokenInstance = instance;
            return bctokenInstance.name.call();
        }).then(function (name) {
            expect(name).to.equal('BCToken');
        })
    })
})