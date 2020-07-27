pragma solidity ^0.4.26;

import './AdminUpgradeabilityProxy.sol';

// ---------------------------------------------------------------------
// dHedge DAO Token Proxy - https://dhedge.org
//
// Notes          : This contract is a proxy to the dHedge DAO Token.
//                  It allows upgradeability using CALLDELEGATE pattern (code courtesy of https://openzeppelin.org/).
//                  This address should be accessed with the ABI of the current token delegate contract.
//
// ---------------------------------------------------------------------

contract DHedgeTokenProxy is AdminUpgradeabilityProxy {

    constructor(address _implementation, bytes _data) AdminUpgradeabilityProxy(_implementation, _data) public payable {
    }
}
