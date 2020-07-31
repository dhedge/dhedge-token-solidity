const DHedgeTokenProxy = artifacts.require('./DHedgeTokenProxy.sol');
const DHedgeTokenV1 = artifacts.require('./DHedgeTokenV1.sol');
const DHedgeTokenV2Example = artifacts.require('./DHedgeTokenV2Example.sol');
const BigNumber = require('bignumber.js');

let tokenOwner;
let proxyAdmin;
let user1;
let user2;

let token;
let delegate;
let proxy;

//100 million
const totalSupply = new BigNumber("100000000e+18");
const oneToken = new BigNumber("1e+18");
const twoTokens = new BigNumber("2e+18");
const addressZero = '0x0000000000000000000000000000000000000000';

contract('DHedgeTokenTest', (accounts) => {

    beforeEach(async () => {
        tokenOwner = accounts[0];
        proxyAdmin = accounts[1];
        user1 = accounts[2];
        user2 = accounts[3];

        delegate = await DHedgeTokenV1.new({from: tokenOwner});

        let initData = web3.eth.abi.encodeFunctionCall({
            name: 'initialize',
            type: 'function',
            inputs: [{
                type: 'address',
                name: 'tokenOwner'
            }]
        }, [tokenOwner]);

        proxy = await DHedgeTokenProxy.new(delegate.address, initData, {from: proxyAdmin});
        token = await DHedgeTokenV1.at(proxy.address, {from: proxyAdmin});
    });

    function expectRevert(e, msg) {
        assert(e.message.search('revert') >= 0, msg);
    }

    it("First version of token is initialized correctly", async () => {

        assert("dHedge DAO Token" === await token.name.call({from: user1}), "name doesn't match");
        assert("DHT" === await token.symbol.call({from: user1}), "symbol doesn't match");
        assert(1 === (await token.version.call({from: user1})).toNumber(), "version doesn't match");
        assert(totalSupply.isEqualTo(await token.balanceOf.call(tokenOwner, {from: user1})), "token owner doesn't have all supply");
        assert(tokenOwner === await token.owner.call({from: user1}), "token owner is different");

        assert(delegate.address === await proxy.implementation.call({from: proxyAdmin}), "delegate address doesn't match");

        try {
            await token.initialize(user1, {from: user1});
            assert(false);
        } catch (e) {
            expectRevert(e, "cannot be initialized again");
        }

    });

    it("Token upgrade 2in1 works correctly", async () => {

        //deploy new version of the contract
        let delegate2 = await DHedgeTokenV2Example.new();

        //update the implementation address at proxy and initialize
        let initData = web3.eth.abi.encodeFunctionSignature('initialize()');
        await proxy.upgradeToAndCall(delegate2.address, initData, {from: proxyAdmin});

        //update abi, proxy address stays the same
        token = await DHedgeTokenV2Example.at(proxy.address);

        //check we updated the previous state
        assert("DHedge  DAO Token Token New Version" === await token.name.call({from: user1}), "name doesn't match");
        assert(2 === (await token.version.call({from: user1})).toNumber(), "version doesn't match");

        //check new function works
        assert("Hello" === await token.brandNewFunction.call({from: user1}), "new function doesn't work");

        //check sending ether works
        await token.brandNewPayableFunction({from: user1, value: 1});
        assert(new BigNumber(1).isEqualTo(await web3.eth.getBalance(token.address)), "ether balance matches");
        assert(new BigNumber(1).isEqualTo(await token.receivedEther.call({from: user1})), "receivedEther value matches");

    });

    it("Token upgrade 1by1 works correctly", async () => {

        //deploy new version of the contract
        let delegate2 = await DHedgeTokenV2Example.new();

        //1) update the implementation address at proxy
        await proxy.upgradeTo(delegate2.address, {from: proxyAdmin});

        //update abi, proxy address stays the same
        token = await DHedgeTokenV2Example.at(proxy.address);

        //2) and initialize token
        await token.initialize({from: user1});

        //check we updated the previous state
        assert("DHedge  DAO Token Token New Version" === await token.name.call({from: user1}), "name doesn't match");
        assert(2 === (await token.version.call({from: user1})).toNumber(), "version doesn't match");

        //check new function works
        assert("Hello" === await token.brandNewFunction.call({from: user1}), "new function doesn't work");

        //check sending ether works
        await token.brandNewPayableFunction({from: user1, value: 1});
        assert(new BigNumber(1).isEqualTo(await web3.eth.getBalance(token.address)), "ether balance matches");
        assert(new BigNumber(1).isEqualTo(await token.receivedEther.call({from: user1})), "receivedEther value matches");

        assert(tokenOwner === await token.owner.call({from: user1}), "token admin doesn't match");
    });

    it("Can transfer tokens to any address", async () => {
        let tokenBalanceUserBefore = await token.balanceOf.call(user1);
        await token.transfer(user1, oneToken, {from: tokenOwner});
        let tokenBalanceUserAfter = await token.balanceOf.call(user1);
        assert(oneToken.plus(tokenBalanceUserBefore).isEqualTo(tokenBalanceUserAfter), "user token balance doesn't match");
    });

    it("Anyone can burn tokens", async () => {
        await token.transfer(user1, twoTokens, {from: tokenOwner});
        await token.burn(oneToken, {from: tokenOwner});
        await token.burn(oneToken, {from: user1});
        try {
            await token.burn(twoTokens, {from: user1});
            assert(false);
        } catch (e) {
            expectRevert(e, "trying to burn more then the user has");
        }
        assert(oneToken.isEqualTo(await token.balanceOf.call(user1)));
    });

    it("Token refuses to accept ether transfers", async () => {
        const tx = {from: user1, to: token.address, value: 10000};

        try {
            await web3.eth.sendTransaction(tx);
            assert(false);
        } catch (e) {
            expectRevert(e, "token doesn't accept ether");
        }
    });

});
