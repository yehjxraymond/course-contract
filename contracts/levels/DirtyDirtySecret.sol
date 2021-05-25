// Call with secret variable
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// The contract has a secret (private) variable. Guess the variable to complete the challenge.
contract DirtyDirtySecret is ILevelContract {
    string public name = "Read & Write";
    uint256 public credits = 20e18;
    ICourseContract public course;

    uint256 private dirtySecret;
    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
        dirtySecret = uint256(
            keccak256(abi.encodePacked(block.number, FACTOR))
        );
    }

    function submit(uint256 guess) public {
        require(dirtySecret == guess);
        course.creditToken(msg.sender);
        dirtySecret = uint256(
            keccak256(abi.encodePacked(block.number, FACTOR))
        );
    }
}
