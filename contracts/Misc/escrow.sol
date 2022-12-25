// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract Escrow{
    
    address agent;
    mapping (address=> uint256) public deposits;

    modifier onlyAgent() {
        require(msg.sender == agent);
        _;
    }
    constructor () public {
        agent = msg.sender;
    }        

    //Only the buyer can call this function and this fun will transfer funds from agent to receiver
    function deposit(address payee) public onlyAgent payable {
        uint256 amount = msg.value;
        deposits[payee] = deposits[payee] + amount;
    }

    //only the seller can call withdraw function and this fun will withdarw the ether from agent's to receiver's account
    function withdraw(address payable payee) public onlyAgent {
        uint256 payment = deposits[payee];
        deposits[payee] = 0;
        payee.transfer(payment);
    }

    //this function will show agent's current balance
    function getBalance() public view returns (uint256) {
        return agent.balance;
    }
}