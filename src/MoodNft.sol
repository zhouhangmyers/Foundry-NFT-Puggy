//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    string private s_happySvgImageUri;
    string private s_sadSvgImageUri;
    uint256 private s_tokenCounter;
    mapping(uint256 => Mood) private s_tokenIdToMood;

    enum Mood {
        HAPPY,
        SAD
    }

    constructor(string memory sadSvgImageUri, string memory happySvgImageUri) ERC721("MoodNft", "MOOD") {
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
        s_tokenCounter = 0;
    }

    function mintNft() public {
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        if (!_isAuthorized(msg.sender, msg.sender, tokenId)) {
            revert("MoodNft: not authorized");
        }
        s_tokenIdToMood[tokenId] = s_tokenIdToMood[tokenId] == Mood.HAPPY ? Mood.SAD : Mood.HAPPY;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory moodUri = s_tokenIdToMood[tokenId] == Mood.HAPPY ? s_happySvgImageUri : s_sadSvgImageUri;

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"',
                            name(), // You can add whatever name here
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            moodUri,
                            '"}'
                        )
                    )
                )
            )
        );
    }
}
