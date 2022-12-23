// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;
import "./IERC721.sol";
contract NameNft is IERC721{
    string public name;
    string public symbol;
    uint tokenCount = 0 ;
    mapping(uint=>string) private _tokenURIs;

    constructor(string memory _name,string memory _symbol){
        name=_name;
        symbol=_symbol;
    }

    function getTokenUri(uint tokenId) view public returns(string memory){
        require(_owners[tokenId]!=address(0),"Token is Not Exist");
        return _tokenURIs[tokenId];
    }

    function mint(string memory tokenURI) public {
        tokenCount++;
        _balances[msg.sender]+=1;
        _owners[tokenCount]=msg.sender;
        _tokenURIs[tokenCount]=tokenURI;
        emit Transfer(address(0),msg.sender,tokenCount);
    }

}