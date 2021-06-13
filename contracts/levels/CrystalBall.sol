// Guess the blockhash
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

contract CrystalBall is ILevelContract {
    string public name = "Crystal Ball";
    uint256 public credits = 30e18;
    ICourseContract public course;
    mapping(address => bool) nullifier;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function gaze(bytes32 guess, address challenger)
        public
        allowedToCall(msg.sender)
    {
        require(blockhash(block.number) == guess, "Wrong guess");
        course.creditToken(challenger);
    }

    modifier allowedToCall(address caller) {
        require(
            !nullifier[caller],
            "Not allowed to call again with this caller"
        );
        nullifier[caller] = true;
        _;
    }
}
