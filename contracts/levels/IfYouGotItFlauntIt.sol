// Show me 5 NFTs
//SPDX-License-Identifier: Unlicense
pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "../ILevelContract.sol";
import "../ICourseContract.sol";

interface ERC721 {
    function ownerOf(uint256 _tokenId) external view returns (address);
}

// Show me 5 NFT from different contracts here
contract IfYouGotItFlauntIt is ILevelContract {
    string public name = "If You Got It Flaunt It";
    uint256 public credits = 20e18;
    ICourseContract public course;
    mapping(bytes32 => bool) nullifier;

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
            require(token.ownerOf(nfts[i].id) == msg.sender);

            // Prevents the submission of the same NFT
            nullify(
                keccak256(abi.encodePacked(nfts[i].contractAddr, nfts[i].id))
            );
        }
        course.creditToken(msg.sender);
    }

    function nullify(bytes32 h) internal {
        require(!nullifier[h], "Not allowed to use this hash");
        nullifier[h] = true;
    }
}
