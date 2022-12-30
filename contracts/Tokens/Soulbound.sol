// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts@4.7.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.7.0/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.0/utils/Counters.sol";

contract Soulbound_OpenCode is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    
    event Attest(address indexed to, uint256 indexed tokenId); // event Attest created and will be emitted while minting
    event Revoke(address indexed to, uint256 indexed tokenId); // event Revoke created and will be emitted while revoke.

    constructor() ERC721("OpenCode", "OC") {}

    //safeMint function is used to mint NFT. It takes wallet address in "address to" and metadata file ipfs link in "string memory uri"
    function safeMint(address to, string memory uri) public onlyOwner { 
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    //burn function will be sending a token to an account which can only receive them.
    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only owner of the token can burn it"); //only owner can burn the token
        _burn(tokenId);
    }

    //revoke function ensures the NFT cannot be bought, sold, or transferred without first approving the allowance.
    function revoke(uint256 tokenId) external onlyOwner {
        _burn(tokenId);
    }

//before token transfer function is used while you try to transfer token to other account. 
//from == address(0) means token is being issued
//to == address(0) means token is being burnt
    function _beforeTokenTransfer(address from, address to, uint256) pure override internal {
        require(from == address(0) || to == address(0), "Not allowed to transfer token"); //this is necessary condition otherwise token will not be transfered
    }

//after token transfer function is used after you burnt the transfer of token to other account. 
    function _afterTokenTransfer(address from, address to, uint256 tokenId) override internal {

        if (from == address(0)) { //if from == address(0) then it is minted
            emit Attest(to, tokenId); // we have to emit those events when needed
        } else if (to == address(0)) { //if to == address(0) then it is revoked
            emit Revoke(to, tokenId);
        }
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    // fucntion tokenURI on an NFT is a unique identifier of what the token "looks" like. In this case URI is IPFS hash. This shows what a NFT looks like. 
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
