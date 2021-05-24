//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.1/contracts
import "@openzeppelin/contracts/token/ERC20/ERC20Mintable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";

contract CourseToken is ERC20Mintable, ERC20Detailed {
    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) public ERC20Detailed(name, symbol, decimals) {}

    function _transfer(
        address,
        address,
        uint256
    ) internal {
        revert("Transfer is not allowed on the token");
    }
}
