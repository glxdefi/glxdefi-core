'use strict';
const { TestHelper } = require('@openzeppelin/cli');
var GLXToken = artifacts.require("GLXToken");

const { expect } = require('chai');

contract('GLXToken', function (accounts) {

    beforeEach(async function() {
        var bcToken = await GLXToken.deployed()
        console.log(bcToken.address)
        //console.log(accounts)
    })

    it('test info', async function () {

        var bctokenInstance;

        return GLXToken.deployed().then(function (instance) {
            bctokenInstance = instance;
            console.log(bctokenInstance.name.name)
            return bctokenInstance.name.call();
        }).then(function (name) {
            expect(name).to.equal('GLXToken');
        })
    })
})