//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Ayashika is ERC721URIStorage{
    using SafeMath for uint256;
    uint public constant mintPrice = 0;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Ayashika", "AYG") {}
    
    function mint(string memory tokenURI)
        public
        returns (uint256)
    {
        uint256 mintIndex = _tokenIds.current();
        _mint(msg.sender, mintIndex);
        _setTokenURI(mintIndex, tokenURI);

        _tokenIds.increment();
        return mintIndex;
    }
}

//Opensea Link: "https://testnets.opensea.io/assets/goerli/0x063a998D9e27B946F9Eb1ccE44302504c6d6e3e5/0"
//Etherscan Link: "https://goerli.etherscan.io/tx/0xfb0147009c12ca8f2cdae308f484dc08364e4555876327f44c82f898d2cca49e"
//Metadata Link: "https://www.jsonkeeper.com/b/BW7B"
//IPFS image Link: "https://ipfs.io/ipfs/QmeTSjK1NVANtsrvrsLkuB7ZabMi3oXgT2MrHZ1aGYtxyA"