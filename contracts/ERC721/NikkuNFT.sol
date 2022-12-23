// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NameNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Nikku.Dev", "NDEV") {}

    function MintNameNFT( string memory tokenURI)
        public
        returns (uint256)
    {
        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        return newItemId;
    }
}
// OpenSea Link: https://testnets.opensea.io/assets/goerli/0xdf7a1263e64e735a00f67db0f8d2ea2ef17cb801/0
// IPFS metadata link : https://gateway.pinata.cloud/ipfs/QmUiq6XLMUE3PhfQcYqA8FoGUbnbQNzSe9H1xiTzndbHpT
// Etherscan Link : https://goerli.etherscan.io/address/0xdf7a1263e64e735a00F67db0f8d2Ea2EF17cB801

