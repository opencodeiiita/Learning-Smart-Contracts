//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Crowdfunding{
    uint fundingEnds;
    uint votingEnds;
    uint fundingTarget;
    uint totalDonors=0;
    uint votes=0;
    mapping (address=>uint) donations;
    mapping (address=>uint) voted;
    address fundraiser;

    receive() external payable{

    }

    constructor(uint target,uint time){
        fundingTarget = target;
        fundingEnds = block.timestamp + time;
        votingEnds = fundingEnds + 1 minutes;
        fundraiser = msg.sender;
    }

    function deposit() public payable {
        require(block.timestamp<fundingEnds,"The crowd funding time has ended");
        require(msg.sender!=fundraiser,"The fundraiser cannot donate");
        require(msg.value>0,"You have not deposit any money");
        if(donations[msg.sender]==0) totalDonors++;
        donations[msg.sender]+=msg.value;
    }

    function vote(uint _vote) public {  // 0 for against 1 for support
        require(block.timestamp>fundingEnds,"The funding period has still not ended");
        require(block.timestamp<votingEnds,"The voting period has ended");
        require(msg.sender!=fundraiser,"The fundraiser cant vote");
        require(donations[msg.sender]>0,"You are not allowed to vote in this contract");
        require(voted[msg.sender]==0,"You have already voted");
        voted[msg.sender]=1;
        if(_vote==1) votes++;
    }

    function withdraw() public payable {
        require(block.timestamp>votingEnds,"The voting period has still not ended");
        require((2*votes)<=totalDonors,"The fundraiser has won the voting");
        require(donations[msg.sender]>0,"You either did not donate or already have withdrawn the amount");

        uint val = donations[msg.sender];
        (bool sent, ) = msg.sender.call{value: val}("");
        require(sent, "Failed to send Ether");

        if(!sent) donations[msg.sender] = val;
    }

    function sendToFundraiser() public payable {
        require(block.timestamp>votingEnds,"The voting period has still not ended");
        require((2*votes)>totalDonors,"The fundraiser has lost the voting");
        (bool sent, ) = fundraiser.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function getTargetAmount() public view returns(uint){
        return fundingTarget;
    }
}