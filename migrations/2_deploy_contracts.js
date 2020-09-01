const DHedgeTokenV1 = artifacts.require("./DHedgeTokenV1.sol");
const DHedgeTokenProxy = artifacts.require("./DHedgeTokenProxy.sol");

async function doDeploy(deployer, accounts) {
    let owner = accounts[0]

    let initialAccount = accounts[1] // TODO: change to initial account address

    let delegate = await deployer.deploy(DHedgeTokenV1, {from: owner})

    let initData = web3.eth.abi.encodeFunctionCall(
        {
          inputs: [
            {
              internalType: "address",
              name: "initialAccount",
              type: "address",
            },
          ],
          name: "__DHedgeTokenV1_init",
          outputs: [],
          stateMutability: "nonpayable",
          type: "function",
        },
        [initialAccount]
      );

    let proxy = await deployer.deploy(DHedgeTokenProxy, delegate.address, initData, {from: owner})

    console.log('Proxy Address: ', proxy.address)
}

module.exports = (deployer, netwrok, accounts) => {
    deployer.then(async () => {
        await doDeploy(deployer, accounts)
    })
}