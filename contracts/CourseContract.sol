//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "hardhat/console.sol";

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.1/contracts
import "@openzeppelin/contracts/ownership/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

import "./LevelContractRole.sol";
import "./CourseToken.sol";
import "./ILevelContract.sol";
import "./ICourseContract.sol";

contract CourseContract is LevelContractRole, Ownable, ICourseContract {
    event LevelAdded(address indexed level, uint256 indexed credit);

    // userProgress[level][challenger] => completion block number
    mapping(address => mapping(address => uint256)) public challengerProgress;
    CourseToken public courseToken;

    // Deploy token and assign msg.sender as token minter too
    constructor(string memory name, string memory symbol) public Ownable() {
        courseToken = new CourseToken(name, symbol, 18);
        courseToken.addMinter(msg.sender);
    }

    function creditToken(address challenger)
        public
        onlyLevelContract
        onlyNewChallenger(msg.sender, challenger)
    {
        // Save the challenger progress
        challengerProgress[msg.sender][challenger] = block.number;
        // Mint token for challenger
        courseToken.mint(challenger, ILevelContract(msg.sender).credits());
    }

    function addLevel(address levelContract) public onlyOwner {
        ILevelContract level = ILevelContract(levelContract);

        // Add role to allow level contract to access creditToken function
        addLevelContract(levelContract);

        // Emit event
        emit LevelAdded(levelContract, level.credits());
    }

    modifier onlyNewChallenger(address level, address challenger) {
        require(
            challengerProgress[level][challenger] == 0,
            "Challenger has completed level before"
        );
        _;
    }
}
