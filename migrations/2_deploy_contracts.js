const AdminUpgradeabilityProxy = artifacts.require("AdminUpgradeabilityProxy");
const DHedgeTokenV1 = artifacts.require("DHedgeTokenV1");
const SafeMath = artifacts.require("SafeMath");

async function doDeploy(deployer, accounts) {

    await deployer.deploy(SafeMath);
    await deployer.link(SafeMath, DHedgeTokenV1);
    let token = await deployer.deploy(DHedgeTokenV1);

    let initData = web3.eth.abi.encodeFunctionCall({
        name: 'initialize',
        type: 'function',
        inputs: [{
            type: 'address',
            name: 'initialSupplyHolder'
        }]
    }, [accounts[1]]);

    let proxy = await deployer.deploy(AdminUpgradeabilityProxy, token.address, initData);

    console.log("Proxy Deployed at: " + proxy.address);
}

module.exports = (deployer, network, accounts) => {
    deployer.then(async () => {
        await doDeploy(deployer, accounts);
    });
};



