pragma solidity ^0.4.26;

import "./DHedgeTokenV1.sol";

contract DHedgeTokenV2Example is DHedgeTokenV1 {
    uint256 public receivedEther;

    function initialize() public {
        _version = 2;
        require(!_initialized[_version]);
        _name = "DHedge  DAO Token Token New Version";
        receivedEther = 0;

        _initialized[_version] = true;
    }

    function brandNewFunction() public pure returns (string) {
        return "Hello";
    }

    //can receive ether
    function brandNewPayableFunction() public payable {
        receivedEther += msg.value;
    }

    function receivedEther() public view returns (uint256) {
        return receivedEther;
    }
}
