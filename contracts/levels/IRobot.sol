//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Call with smart contract
contract IRobot is ILevelContract {
    string public name = "I Robot";
    uint256 public credits = 20e18;
    ICourseContract public course;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function ping(address challenger) public {
        require(isContract(msg.sender), "Caller must be a smart contract");
        course.creditToken(challenger);
    }

    function isContract(address _addr) public view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_addr)
        }
        return (size > 0);
    }
}
