// Show me 5 NFTs
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

interface ERC721 {
    function ownerOf(uint256 _tokenId) external view returns (address);

    function balanceOf(address _owner) external view returns (uint256);
}

// Send 5 NFT from different contracts here
contract IfYouGotItFlauntIt is ILevelContract {
    string public name = "If You Got It Flaunt It";
    uint256 public credits = 20e18;
    ICourseContract public course;
    mapping(address => bool) nullifier;

    struct NFT {
        address contractAddr;
        uint256 id;
    }

    constructor(address courseContract) public {
        course = ICourseContract(courseContract);
    }

    function showOff(NFT[5] memory nfts) public {
        require(nfts.length == 5, "Show me 5 NFTs");
        for (uint256 i = 0; i < nfts.length; i++) {
            ERC721 token = ERC721(nfts[i].contractAddr);
            require(token.balanceOf(address(this)) == 1);
            require(token.ownerOf(nfts[i].id) == address(this));
            nullify(nfts[i].contractAddr);
        }
        course.creditToken(msg.sender);
    }

    function nullify(address addr) internal {
        require(!nullifier[addr], "Not allowed to use this address");
        nullifier[addr] = true;
    }
}
