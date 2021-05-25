//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Read the public variable and submit it as the answer to complete the challenge.
contract ReadAndWrite is ILevelContract {
    string public name = "Read & Write";
    uint256 public credits = 10e18;
    ICourseContract public course;

    uint256 public notSoSecret;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
        notSoSecret = uint256(keccak256(abi.encodePacked(block.number)));
    }

    function submit(uint256 guess) public {
        require(notSoSecret == guess);
        course.creditToken(msg.sender);
        notSoSecret = uint256(keccak256(abi.encodePacked(block.number)));
    }
}
