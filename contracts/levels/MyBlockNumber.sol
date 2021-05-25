//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Guess(?) the block number and be rewarded
contract MyBlockNumber is ILevelContract {
    string public name = "My Block Number";
    uint256 public credits = 10e18;
    ICourseContract public course;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function submit(uint256 guess) public {
        require(block.number == guess);
        course.creditToken(msg.sender);
    }
}
