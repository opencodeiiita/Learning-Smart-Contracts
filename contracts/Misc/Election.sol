// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Election{
    mapping(address => bool) voted;
    mapping(string => uint) candidatesVotes;
    uint currentMax=1;
    string[] winners;

    // Taking the list of "strings" input and adding them to our mapping
    constructor(string[] memory list){
        for(uint i=0 ; i<list.length ; i++){
            candidatesVotes[list[i]]=1;
        }
    }

    function vote(string memory _candidate) external {
        require(voted[msg.sender]!=true);   // Make sure voter has not already voted
        require(candidatesVotes[_candidate]>0); // Make sure the candidate name is valid
        candidatesVotes[_candidate]++;
        voted[msg.sender]=true;
        if(candidatesVotes[_candidate]>currentMax){ // Logic to determine winner
            currentMax=candidatesVotes[_candidate];
            delete winners;
            winners.push(_candidate);
        }
        if(candidatesVotes[_candidate]==currentMax){    // Multiple winners if they have equal votes
            winners.push(_candidate);
        }
    }

    function winner() external view returns (string[] memory){  // Returns the results
        return winners;
    }
}
