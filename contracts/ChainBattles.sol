// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct TokenStats {
        uint level;
        uint speed;
        uint strength;
        uint life;
    }

    mapping(uint256 => TokenStats) public tokenIdToStats;

    constructor() ERC721("Chain Battles", "CBTLS") {}

    function getStats(uint256 tokenId) public view returns (TokenStats memory) {
        TokenStats memory _stats = tokenIdToStats[tokenId];
        return _stats;
    }

    function generateCharacter(uint256 tokenId) public view returns (string memory) {
        TokenStats memory _stats = getStats(tokenId);

        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" fill="black" />',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">',"Level: ",_stats.level.toString(),'</text>',
            '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">',"Speed: ",_stats.speed.toString(),'</text>',
            '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">',"Strength: ",_stats.strength.toString(),'</text>',
            '<text x="50%" y="80%" class="base" dominant-baseline="middle" text-anchor="middle">',"Life: ",_stats.life.toString(),'</text>',
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Chain Battles #',
            tokenId.toString(),
            '",',
            '"description": "Battles on chain",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() external {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);

        tokenIdToStats[newItemId] = TokenStats(0, 1, 2, 10);

        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function train(uint256 tokenId) external {
        require(_exists(tokenId), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to train it"
        );

        TokenStats memory currentStats = tokenIdToStats[tokenId];
        tokenIdToStats[tokenId] = TokenStats(
            currentStats.level + 1,
            currentStats.speed + 1,
            currentStats.strength + 2,
            currentStats.life + 10
        );

        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
