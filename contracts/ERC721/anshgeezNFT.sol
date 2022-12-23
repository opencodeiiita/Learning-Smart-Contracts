// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract nftmintkaro is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    
    constructor() ERC721("AnshKothari", "AK") {}

    function mintNFT(address player, string memory tokenURI)
        public
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        return newItemId;
    }
}

//Opensea link: https://testnets.opensea.io/assets/goerli/0xD5AA38834b66B4076A1D16eD1BF9A72e32b5cA61/1
//etherscan link: https://goerli.etherscan.io/tx/0x6e2d150679d44362bdfcc9b052a97fdb2ef2b8c94ae8bf64d59df410a5191768
