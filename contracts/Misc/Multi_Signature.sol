// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Multi_Signature{
    mapping (address=>bool) owners;
    uint noOfOwners=0;
    uint votes=0;
    uint oppose=0;
    bool confirm=false;
    address zeroAddress=address(0x0);
    address requester=zeroAddress;
    constructor(address[] memory _owners){
        for(uint i=0 ; i<_owners.length ; i++){
            owners[_owners[i]]=true;
            noOfOwners++;
        }
    }

    receive() external payable{

    }

    modifier onlyOwners{
      require(owners[msg.sender],"You are not an owner");
      _;
    }

    function deposit() public payable onlyOwners{
       require(msg.value>0,"You have not deposit any money");
    }

    function withdrawalRequest() public onlyOwners{
        require(requester==zeroAddress,"Someone has already made a request");
        requester=msg.sender;
        votes=0;
        oppose=0;
        confirm=false;
    }

    function confirmation(uint _vote) public onlyOwners{
        require(requester!=zeroAddress,"A withdrawal request has not been made");
        require(msg.sender!=requester,"The requester cant vote");
        if(_vote == 1) votes++;
        else oppose++;
        if((2*votes)>=(noOfOwners-1)) confirm=true;
        if((2*oppose)>=(noOfOwners-1)) requester=zeroAddress;
    }

    function transact() public payable{
        require(msg.sender==requester,"You are not the one who made the request");
        require(confirm,"The majority has not voted in your favor");
        (bool sent, ) = requester.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
        requester=zeroAddress;
    }

    function whoMadeRequest() public view onlyOwners returns(address){
        return requester;
    }
}