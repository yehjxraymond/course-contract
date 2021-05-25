// Call this unverified smart contract

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Simple smart contract, goal is simply to call the helloWorld function
contract FindMyABI is ILevelContract {
    string public name = "Find My ABI";
    uint256 public credits = 10e18;
    ICourseContract public course;
    mapping(address => uint256) steps;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function initiate() public {
        require(steps[msg.sender] == 0);
        steps[msg.sender] = 1;
    }

    function meaningOfLife(uint256 guess) public {
        require(steps[msg.sender] == 1);
        require(guess == 42);
        steps[msg.sender] = 2;
    }

    function noMoneyNoHoney() public payable {
        require(steps[msg.sender] == 2);
        require(msg.value > 0);
        course.creditToken(msg.sender);
        steps[msg.sender] = 3;
    }
}
