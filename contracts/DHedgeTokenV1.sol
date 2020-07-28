pragma solidity ^0.4.26;

import "./SafeMath.sol";
import "./ApproveAndCall.sol";
import "./Ownable.sol";
import "./ERC20.sol";

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

contract DHedgeTokenV1 is Ownable, ERC20 {
    using SafeMath for uint256;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    string internal _name;
    string internal _symbol;
    uint8 internal _decimals;
    uint256 internal _totalSupply;
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) internal _allowed;

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
     * @dev Transfer token for a specified address
     * @param _to The address to transfer to.
     * @param _value The amount to be transferred.
     */
    function transfer(address _to, uint256 _value) public returns (bool) {
        require(_to != address(0));
        require(_value <= _balances[msg.sender]);
        // SafeMath.sub will throw if there is not enough balance.
        _balances[msg.sender] = _balances[msg.sender].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool) {
        require(_to != address(0));
        require(_value <= _balances[_from]);
        require(_value <= _allowed[_from][msg.sender]);
        _balances[_from] = _balances[_from].sub(_value);
        _balances[_to] = _balances[_to].add(_value);
        _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
        _allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner _allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender)
        public
        view
        returns (uint256)
    {
        return _allowed[_owner][_spender];
    }

    /**
     * @dev Increase the amount of tokens that an owner _allowed to a spender.
     *
     * approve should be called when _allowed[_spender] == 0. To increment
     * _allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _addedValue The amount of tokens to increase the allowance by.
     */
    function increaseApproval(address _spender, uint256 _addedValue)
        public
        returns (bool)
    {
        _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender].add(
            _addedValue
        );
        emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
        return true;
    }

    /**
     * @dev Decrease the amount of tokens that an owner _allowed to a spender.
     *
     * approve should be called when _allowed[_spender] == 0. To decrement
     * _allowed value is better to use this function to avoid 2 calls (and wait until
     * the first transaction is mined)
     * From MonolithDAO Token.sol
     * @param _spender The address which will spend the funds.
     * @param _subtractedValue The amount of tokens to decrease the allowance by.
     */
    function decreaseApproval(address _spender, uint256 _subtractedValue)
        public
        returns (bool)
    {
        uint256 oldValue = _allowed[msg.sender][_spender];
        if (_subtractedValue > oldValue) {
            _allowed[msg.sender][_spender] = 0;
        } else {
            _allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
        }
        emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
        return true;
    }

    /**
     * @dev Function to approve the transfer of the tokens and to call another contract in one step
     * @param _recipient The target contract for tokens and function call
     * @param _value The amount of tokens to send
     * @param _data Extra data to be sent to the recipient contract function
     */
    function approveAndCall(
        address _recipient,
        uint256 _value,
        bytes _data
    ) public returns (bool) {
        _allowed[msg.sender][_recipient] = _value;
        ApproveAndCall(_recipient).receiveApproval(
            msg.sender,
            _value,
            address(this),
            _data
        );
        emit Approval(msg.sender, _recipient, _allowed[msg.sender][_recipient]);
        return true;
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param _value The amount of token to be burned.
     */
    function burn(uint256 _value) public returns (bool) {
        require(_value <= _balances[msg.sender]);
        address burner = msg.sender;
        _balances[burner] = _balances[burner].sub(_value);
        _totalSupply = _totalSupply.sub(_value);
        emit Transfer(burner, address(0), _value);
        return true;
    }

    /**
     * @dev Gets the balance of the specified address.
     * @param _owner The address to query the the balance of.
     * @return An uint256 representing the amount owned by the passed address.
     */
    function balanceOf(address _owner) public view returns (uint256) {
        return _balances[_owner];
    }

    /**
     * @dev Gets the total supply of the token.
     * @return An uint256 representing the total supply of the token.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Gets the name of the token.
     * @return A string representing the name of the token.
     */
    function name() public view returns (string) {
        return _name;
    }

    /**
     * @dev Gets the symbol of the token.
     * @return A string representing the symbol of the token.
     */
    function symbol() public view returns (string) {
        return _symbol;
    }

    /**
     * @dev Gets the decimals of the token.
     * @return An uint8 representing the decimals of the token.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Gets the version of the token contract.
     * @return An uint256 representing the version of the token contract.
     */
    function version() public view returns (uint256) {
        return _version;
    }
}