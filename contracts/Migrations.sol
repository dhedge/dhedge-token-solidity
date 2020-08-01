pragma solidity ^0.6.0;

contract Migrations {
    address public owner;
    // solhint-disable-next-line var-name-mixedcase
    uint256 public last_completed_migration;

    constructor() public {
        owner = msg.sender;
    }

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    function setCompleted(uint256 completed) public restricted {
        last_completed_migration = completed;
    }

    // solhint-disable-next-line var-name-mixedcase
    function upgrade(address new_address) public restricted {
        Migrations upgraded = Migrations(new_address);
        upgraded.setCompleted(last_completed_migration);
    }
}
