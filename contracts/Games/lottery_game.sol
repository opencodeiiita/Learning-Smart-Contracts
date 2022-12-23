// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

contract lottery{
    address public owner;
    address payable[] public players;

    constructor(){
        // address of owner who is deploying the contract
        owner = msg.sender;
    }

    function enter() public payable {
        //preset entry fee;
        require(msg.value > 0.1 ether);

        // adrress of the player entering the lottery
        players.push(payable(msg.sender));
    }

    function getRandomNumber() public view returns (uint){
        // generating a hash number by concatenating both owner address and timestamp then converting it unsigned int..
        return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
    }

    function pickWinner() public onlyowner {
        uint index = getRandomNumber() % players.length;
        players[index].transfer(address(this).balance);

        // reset contract
        players = new address payable[](0);
    }

    modifier onlyowner() {
      require(msg.sender == owner);
      _;
   }
}