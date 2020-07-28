pragma solidity ^0.4.26;

import "../ERC20.sol";
import "../ApproveAndCall.sol";

contract ApproveAndCallMock is ApproveAndCall {
    event ReceivedApproval(
        address _from,
        uint256 _amount,
        address _tokenContract,
        bytes _data
    );

    address public from;
    uint256 public amount;
    address public tokenContract;
    bytes public data;

    function receiveApproval(
        address _from,
        uint256 _amount,
        address _tokenContract,
        bytes _data
    ) public returns (bool) {
        require(
            _amount <= ERC20(_tokenContract).allowance(_from, address(this))
        );
        from = _from;
        amount = _amount;
        tokenContract = _tokenContract;
        data = _data;

        emit ReceivedApproval(from, amount, tokenContract, data);
        return true;
    }
}
