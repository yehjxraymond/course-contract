//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

contract HelloWorld is ILevelContract {
    string public name = "Hello World";
    uint256 public credits = 10e18;
    ICourseContract public course;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function helloWorld() public {
        course.creditToken(msg.sender);
    }
}
