pragma solidity ^0.6.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

// ---------------------------------------------------------------------
// dHedge DAO ERC20 Token - https://dhedge.org
//
// Symbol         : DHT
// Name           : dHedge DAO Token
// Decimals       : 18
// Total supply   : 100,000,000
// Version        : 1
//
// Notes          : This token is upgradable using CALLDELEGATE pattern (courtesy of https://openzeppelin.org/).
//                  It should NOT be accessed directly but through the proxy contract address using this contract's ABI.
//                  Initially only addresses with transferGrant can transfer the tokens.
//                  Once transferable flag is turned on, everyone can transfer freely.
//
// ---------------------------------------------------------------------

contract DHedgeTokenV1 is Ownable, ERC20, ERC20Detailed {

    uint256 internal _version;
    mapping(uint256 => bool) internal _initialized;

    /**
     * @dev Initialisation method representing a constructor in the DELEGATECALL proxy pattern, callable only once.
     * @param tokenOwner The address of the token owner, also holding initially minted tokens
     *
     * Parameter tokenOwner should be different then the proxy admin, otherwise the calls will not be delegated.
     */
    function initialize(address tokenOwner) public {
        _version = 1;
        require(!_initialized[_version]);
        _name = "dHedge DAO Token";
        _symbol = "DHT";
        _decimals = 18;
        _totalSupply = 100000000 * (10**uint256(_decimals));
        _balances[tokenOwner] = _totalSupply;
        emit Transfer(address(0), tokenOwner, _totalSupply);
        owner = tokenOwner;

        _initialized[_version] = true;
    }

    /**
     * @dev Gets the version of the token contract.
     * @return An uint256 representing the version of the token contract.
     */
    function version() public view returns (uint256) {
        return _version;
    }
}
