// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Election{
    mapping(address => bool) voted;
    mapping(string => uint) candidatesVotes;
    string[] winners;
    uint currentMax=1;
    address owner;

    // Taking the list of "strings" input and adding them to our mapping
    constructor(string[] memory list){
        owner=msg.sender;
        for(uint i=0 ; i<list.length ; i++){
            candidatesVotes[list[i]]=1;
        }
    }

    function vote(string memory _candidate) external {
        require(msg.sender!=owner);     // Make sure owner cant vote
        require(voted[msg.sender]!=true);   // Make sure voter has not already voted
        require(candidatesVotes[_candidate]>0); // Make sure the candidate name is valid
        candidatesVotes[_candidate]++;
        voted[msg.sender]=true;
        if(candidatesVotes[_candidate]>currentMax){ // Logic to determine winner
            currentMax=candidatesVotes[_candidate];
            for(uint i=0 ; i<winners.length ; i++){
                winners.pop();
            }
            winners.push(_candidate);
        }
        else if(candidatesVotes[_candidate]==currentMax){    // Multiple winners if they have equal votes
            winners.push(_candidate);
        }
    }

    function winner() external view returns (string[] memory,uint){  // Returns the results
        uint temp = candidatesVotes[winners[0]];
        return (winners,temp-1);
    }
}
