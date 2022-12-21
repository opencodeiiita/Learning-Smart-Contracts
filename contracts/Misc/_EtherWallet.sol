// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherWallet {
    address payable public owner;
    
//constructor function is created for owner variable.
    constructor() {
        owner = payable(msg.sender);
    }
    
//receive() function for accepting ethers by anyone i.e. external sources.
    receive() external payable{}
    
// function withdraw() specifies and ensures that only owner can withdraw and nobody else can. 
//A custom message will be displayed "Only the owner can withdraw" if other than owner tries to withdraw .
    function withdraw(uint _amount) external {
        require(msg.sender==owner, "Only the owner can call withdraw.");
        payable(msg.sender).transfer(_amount);
    }
    
//getBalance() function will tell the current balance of wallet.
    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

}
