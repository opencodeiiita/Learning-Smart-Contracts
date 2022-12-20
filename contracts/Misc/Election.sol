// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Election{
    mapping(address => bool) voted;
    mapping(string => uint) candidatesVotes;
    mapping(string => bool) candidates;
    string[] winners;
    uint currentMax=0;
    address owner;

    // Taking the list of "strings" input and adding them to our mapping
    constructor(string[] memory list){
        owner=msg.sender;
        for(uint i=0 ; i<list.length ; i++){
            candidatesVotes[list[i]]=0;
            candidates[list[i]]=true;
        }
    }

    function vote(string memory _candidate) external {
        require(msg.sender!=owner,"The owner of the contract cannot vote");     // Make sure owner cant vote
        require(voted[msg.sender]!=true,"You have already voted in the election");   // Make sure voter has not already voted
        require(candidates[_candidate]==true,"Invalid candidate name"); // Make sure the candidate name is valid
        candidatesVotes[_candidate]++;
        voted[msg.sender]=true;
        if(candidatesVotes[_candidate]>currentMax){ // Logic to determine winner
            currentMax=candidatesVotes[_candidate];
            delete winners;
            winners.push(_candidate);
        }
        else if(candidatesVotes[_candidate]==currentMax){    // Multiple winners if they have equal votes
            winners.push(_candidate);
        }
    }

    function winner() external view returns (string[] memory,uint){  // Returns the results
        uint temp = candidatesVotes[winners[0]];
        return (winners,temp);
    }
}
