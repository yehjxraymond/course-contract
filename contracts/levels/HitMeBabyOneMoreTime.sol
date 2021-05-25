//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Hit the contract. The challenge is completed when the counter is a multiple of 30
// What happens when everyone is hitting it at the same time?
contract HitMeBabyOneMoreTime is ILevelContract {
    string public name = "HitMeBabyOneMoreTime";
    uint256 public credits = 20e18;
    ICourseContract public course;
    uint256 public hits = 1;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function hit() public {
        hits += 1;
    }

    function submit(address challenger) public {
        require(hits % 30 == 0);
        hit();
        course.creditToken(challenger);
    }
}
