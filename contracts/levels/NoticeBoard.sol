// Call with secret variable
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// The contract has a secret (private) variable. Guess the variable to complete the challenge.
contract NoticeBoard is ILevelContract {
    string public name = "Notice Board";
    uint256 public credits = 10e18;
    ICourseContract public course;

    bytes32[] board;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
        board.length -= 1;
    }

    function scribble(uint256 index, bytes32 note) public {
        board[index] = note;
    }

    function submit() public {
        require(board[uint256(msg.sender)] != 0);
        course.creditToken(msg.sender);
    }
}
