pragma solidity ^0.5.0;

import "./DHedgeTokenV1.sol";

contract DHedgeTokenV2Example is DHedgeTokenV1 {
    uint256 public _receivedEther;

    function initialize() public {
        version_ = 2;
        require(!initialized[version_]);
        name_ = "DHedge  DAO Token Token New Version";
        _receivedEther = 0;

        initialized[version_] = true;
    }

    function brandNewFunction() public pure returns (string) {
        return "Hello";
    }

    //can receive ether
    function brandNewPayableFunction() public payable {
        _receivedEther += msg.value;
    }

    function receivedEther() public view returns (uint256) {
        return _receivedEther;
    }
}
