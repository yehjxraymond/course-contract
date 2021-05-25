// submit the selector for this function

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Figure out the function selector to complete the challenge
contract SelectMeNot is ILevelContract {
    string public name = "Select Me Not";
    uint256 public credits = 10e18;
    ICourseContract public course;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function selectMeNot(bytes4 selector) public {
        require(selector == this.selectMeNot.selector);
        course.creditToken(msg.sender);
    }
}
