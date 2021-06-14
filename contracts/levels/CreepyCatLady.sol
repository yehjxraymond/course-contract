//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

interface ERC721 {
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function ownerOf(uint256 _tokenId) external view returns (address);
}

// Let me steal a kitty from you
contract CreepyCatLady is ILevelContract {
    string public name = "Creepy Cat Lady";
    uint256 public credits = 20e18;
    ICourseContract public course;
    mapping(address => bool) nullifier;

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function notLooking(address addr, uint256 id) public {
        ERC721 nft = ERC721(addr);
        require(
            nft.ownerOf(id) == msg.sender,
            "NFT not owned by message sender"
        );
        nft.safeTransferFrom(msg.sender, address(this), id);
        require(nullifier[addr] == true, "onERC721Received not called");
        require(
            nft.ownerOf(id) == address(this),
            "ownership is not transferred"
        );
        course.creditToken(msg.sender);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public returns (bytes4) {
        require(!nullifier[msg.sender]);
        nullifier[msg.sender] = true;
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }
}
