//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Send me some small amount of Ethers to complete the challenge
contract WishingWell is ILevelContract {
    string public name = "WishingWell";
    uint256 public credits = 10e18;
    ICourseContract public course;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function() external payable {
        require(msg.value >= 1e16);
        course.creditToken(msg.sender);
    }
}
