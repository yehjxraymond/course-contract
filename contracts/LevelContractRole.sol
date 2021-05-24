pragma solidity ^0.5.0;

import "@openzeppelin/contracts/access/Roles.sol";
import "@openzeppelin/contracts/GSN/Context.sol";

contract LevelContractRole is Context {
    using Roles for Roles.Role;

    event LevelContractAdded(address indexed account);
    event LevelContractRemoved(address indexed account);

    Roles.Role private _levelContracts;

    constructor() internal {
        _addLevelContract(_msgSender());
    }

    modifier onlyLevelContract() {
        require(
            isLevelContract(_msgSender()),
            "LevelContractRole: caller does not have the LevelContract role"
        );
        _;
    }

    function isLevelContract(address account) public view returns (bool) {
        return _levelContracts.has(account);
    }

    function addLevelContract(address account) public onlyLevelContract {
        _addLevelContract(account);
    }

    function renounceLevelContract() public {
        _removeLevelContract(_msgSender());
    }

    function _addLevelContract(address account) internal {
        _levelContracts.add(account);
        emit LevelContractAdded(account);
    }

    function _removeLevelContract(address account) internal {
        _levelContracts.remove(account);
        emit LevelContractRemoved(account);
    }
}
