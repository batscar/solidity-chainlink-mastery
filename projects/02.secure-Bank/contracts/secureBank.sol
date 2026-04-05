// SPDX-License-Identifier: MIT
  pragma solidity ^0.8.33;

  contract SecureBank {

    mapping(address => uint256) public balances ;

    event Deposit(address indexed user, uint256 amount);
    event Withdraw(address indexed user, uint256 amount);
    event Transfer(address indexed sender, address indexed receiver, uint256 amount);
    event WithdrawAll(address indexed user, uint256 amount);

    error InsufficientBalance();
    error ZeroAmount();

    function deposit() public payable {
        if (msg.value == 0 ) {
            revert ZeroAmount();
        }

        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 _amount) public {
        if (_amount == 0) {
            revert ZeroAmount();
            
        }

        if (balances[msg.sender] < _amount) {
            revert InsufficientBalance();
        }

        balances[msg.sender] -= _amount;
        emit Withdraw(msg.sender, _amount);

        (bool success, ) = payable(msg.sender).call{value: _amount}("");
           if (!success){
            revert ("ETH TRANSFER FAILED");
           }

  }
    
    function wtihdrawAll()  public {
        uint256 userBalance = balances[msg.sender];
        
        if (userBalance == 0){
            revert ZeroAmount();
        }

        balances[msg.sender] = 0;
        emit Withdraw(msg.sender, userBalance);
        emit WithdrawAll(msg.sender, userBalance);

        ( bool success,  ) = payable(msg.sender).call{value: userBalance}("");
    if (!success){
        revert ("ETH TRANSFER FAILED");
    }

    }
     
    function getBalance() public view returns (uint256) {
            return balances[msg.sender];
        }

    function getContractBalance() public view returns (uint256) {
            return address(this).balance;
    }

    
    }
