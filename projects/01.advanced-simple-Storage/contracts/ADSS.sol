//SPDX-License-Identifier:MIT

pragma solidity ^0.8.21;

contract AdvancedSimpleStorage {
    //state variable
    uint256 public favoriteNumber;
    string public name;
    bool public isActive;

    // immutable variable
    address public immutable owner;

    event NumberUpdated(uint256 oldNumber, uint256 newNumber , address changedBy);
    event NameUpdated(string oldName, string newName);
    event ActiveStatusChanged(bool newStatus, address changedBy);

  
    error OnlyOwnerCanCall();

    constructor() {
        owner = msg.sender;
        name = "rodger";
        isActive = true;

    }

    function setFavoriteNumber(uint256 _newNumber) public {
        uint256  oldNumber = favoriteNumber;
        favoriteNumber = _newNumber ;

        emit NumberUpdated(oldNumber, _newNumber,  msg.sender );

    }

    function setName(string memory _newName)  public {
        if (msg.sender != owner) {
            revert OnlyOwnerCanCall();
        }

        string memory  oldName = name;
         name = _newName;

        emit NameUpdated(oldName, _newName);

    }

      function toggleActive() public onlyOwner {
        isActive = !isActive;
        emit ActiveStatusChanged(isActive, msg.sender);
    }

    function getFavoriteNumber() public view returns (uint256){

        return favoriteNumber;
    }

    modifier onlyOwner() {
     if (msg.sender != owner) {
        revert OnlyOwnerCanCall();
     }
     _;

    }

    function resetAll() public onlyOwner {
        uint256 oldNumber = favoriteNumber;
        string memory oldName = name;

        favoriteNumber = 0;
        name = "Default";
        emit NameUpdated(oldName, "Default");
        emit NumberUpdated(oldNumber, 0, msg.sender);

    }

}