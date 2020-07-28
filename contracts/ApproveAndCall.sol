pragma solidity ^0.4.26;

/**
 * @title ApproveAndCall
 * @dev Interface function called from `approveAndCall` notifying that the approval happened
 */
contract ApproveAndCall {
    function receiveApproval(
        address _from,
        uint256 _amount,
        address _tokenContract,
        bytes _data
    ) public returns (bool);
}
