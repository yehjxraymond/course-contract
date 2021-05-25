// Call with previous address

//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Simply
contract HeSaysSheSays is ILevelContract {
    string public name = "He Says She Says";
    uint256 public credits = 10e18;
    ICourseContract public course;
    address lastUser;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
        lastUser = msg.sender;
    }

    function submit(address addr) public {
        require(addr == lastUser);
        lastUser = msg.sender;
        course.creditToken(msg.sender);
    }
}
