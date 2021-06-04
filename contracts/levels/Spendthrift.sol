//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

// Let me spend your coins
interface ERC20 {
    function balanceOf(address owner) external returns (uint256);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);
}

contract Spendthrift is ILevelContract {
    string public name = "Spendthrift";
    uint256 public credits = 20e18;
    ICourseContract public course;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function gimmeYourCard(address token) public {
        ERC20 tokenContract = ERC20(token);

        // Check that initial balance is 0
        require(tokenContract.balanceOf(address(this)) == 0);

        // Transfer from msg.sender
        tokenContract.transferFrom(msg.sender, address(this), 10000e18);

        // Check that initial balance is 10000
        require(tokenContract.balanceOf(address(this)) == 10000e18);

        course.creditToken(msg.sender);
    }
}
