//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

interface ERC721 {
    function ownerOf(uint256 _tokenId) external view returns (address);

    function balanceOf(address _owner) external view returns (uint256);
}

// Send a non-fungible token to this contract
contract KittyBreeder is ILevelContract {
    string public name = "Kitty Breeder";
    uint256 public credits = 20e18;
    ICourseContract public course;
    mapping(address => bool) nullifier;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function hereTakeThis(address kittyFactory, uint256 id)
        public
        nullify(kittyFactory)
    {
        ERC721 token = ERC721(kittyFactory);
        require(token.balanceOf(address(this)) == 1, "Send me one cat");
        require(token.ownerOf(id) == address(this), "The cat must be mine");
        course.creditToken(msg.sender);
    }

    modifier nullify(address addr) {
        require(!nullifier[addr], "Not allowed to use this address");
        nullifier[addr] = true;
        _;
    }
}
