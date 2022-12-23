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

//Opensea Link: "https://testnets.opensea.io/assets/goerli/0x33AAfF951a292221f1896C449eDeF65b1eDd4525/0"
//Etherscan Link: "https://goerli.etherscan.io/tx/0xf62460975bf55a626f4e1a106a58a6f01ff9cd10bc44a76fba9c5df393a5c580"
//Metadata Link: "https://jsonkeeper.com/b/NCM1"
//IPFS image Link: "https://ipfs.io/ipfs/QmeTSjK1NVANtsrvrsLkuB7ZabMi3oXgT2MrHZ1aGYtxyA"