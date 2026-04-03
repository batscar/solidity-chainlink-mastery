// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.21;

 contract RodgerToken {

    string public name = "Rodger";
    string public symbol= "ROD";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    error InsufficientBalance();
    error InsufficientAllowance();
    error ZeroAddress();
    error OnlyOwnerCanMint();

    address public immutable owner;

    constructor(uint256 _initialSupply) {
        owner = msg.sender;
        totalSupply = _initialSupply * (10 ** decimals);
        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0), msg.sender, totalSupply);

    }

        function transfer(address _to, uint256 _value) public returns (bool) {
            if (_to == address(0)) revert ZeroAddress();
            if (balanceOf[msg.sender] < _value )revert InsufficientBalance();

            balanceOf[msg.sender] -= _value;
            balanceOf[_to] += _value;

            emit Transfer(msg.sender, _to, _value);
            return true;
        }

        function approve(address _spender, uint256 _value) public returns (bool) {
            if (_spender == address(0)) revert ZeroAddress();

            allowance[msg.sender][_spender] = _value ;
            emit Approval(msg.sender, _spender, _value);
            return true;
        }
    
        function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
            if (_from == address(0) || _to == address(0)) revert ZeroAddress();
            if (balanceOf[_from] < _value )revert InsufficientBalance() ;
            if (allowance[_from][msg.sender] < _value )revert InsufficientAllowance();

            balanceOf[_from] -= _value;
            balanceOf[_to] += _value;
            allowance[_from][msg.sender] -= _value;

            emit Transfer(_from, _to, _value);
            return true;

        }

        function increaseAllowance(address _spender, uint256 _addedValue) public returns (bool) {
            if (_spender == address(0)) revert ZeroAddress();
            allowance[msg.sender][_spender] += _addedValue;
            emit Approval(msg.sender, _spender, allowance[msg.sender][_spender]);
            return true;
        }

        function decreaseAllowance(address _spender, uint256 _subtractedValue) public returns (bool) {
            if (_spender == address(0)) revert ZeroAddress();
            if (allowance[msg.sender][_spender] < _subtractedValue) revert InsufficientAllowance();

            allowance[msg.sender][_spender] -= _subtractedValue;
            emit Approval(msg.sender, _spender , allowance[msg.sender][_spender]);
            return true;
        }
        
        function mint(uint256 _amount) public {
            if (msg.sender != owner) revert OnlyOwnerCanMint();

            totalSupply += _amount;
            balanceOf[msg.sender] += _amount;
            emit Transfer(address(0), msg.sender, _amount);

        }

         function burn(uint256 _amount) public {
        if (balanceOf[msg.sender] < _amount) revert InsufficientBalance();

        balanceOf[msg.sender] -= _amount;
        totalSupply -= _amount;

        emit Transfer(msg.sender, address(0), _amount);
    }
        function getBalance(address _account) public view returns (uint256) {
            return balanceOf[_account];
        }



 }
