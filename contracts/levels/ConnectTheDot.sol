//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

interface StandardizedContract {
    function ping() external;

    function pong(uint256 value) external returns (bool);

    function ding(address from, address to) external returns (uint256, uint256);

    function dong(string calldata message) external returns (uint256, uint256);

    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

// Implement erc165 spec
contract ConnectTheDot is ILevelContract {
    string public name = "Connect The Dot";
    uint256 public credits = 20e18;
    ICourseContract public course;
    mapping(address => bool) nullifier;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function connect(address standardContract) public {
        require(!nullifier[standardContract]);
        StandardizedContract standardizedContract =
            StandardizedContract(standardContract);
        require(
            standardizedContract.supportsInterface(
                standardizedContract.ping.selector ^
                    standardizedContract.pong.selector ^
                    standardizedContract.ding.selector ^
                    standardizedContract.dong.selector
            )
        );
        require(
            !standardizedContract.supportsInterface(
                standardizedContract.ping.selector
            )
        );
        nullifier[standardContract] = true;
        course.creditToken(msg.sender);
    }
}
