// Crack my hash

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Simple smart contract, goal is simply to call the helloWorld function
// Hint: The input is a number between 0 - 100
contract HashCrack is ILevelContract {
    string public name = "Hash Crack";
    uint256 public credits = 20e18;
    ICourseContract public course;
    bytes32 public results =
        0x46bddb1178e94d7f2892ff5f366840eb658911794f2c3a44c450aa2c505186c1;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function hash(uint256 input) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(input));
    }

    function submit(uint256 guess) public {
        require(hash(guess) == results);
        course.creditToken(msg.sender);
    }
}
