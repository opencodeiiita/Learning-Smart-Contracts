// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Escrow{
    
    address public buyer;
    address payable public seller;
    mapping (address=> uint256) public deposits;

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this method");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this method");
        _;
    }

   

    constructor(address _buyer, address payable _seller) {
        buyer = _buyer;
        seller = _seller;
    }     

    //Only the buyer can call this function and this fun will transfer funds from his account to seller's account
    function deposit(address payee) public onlyBuyer payable  {
        uint256 amount = msg.value;
        deposits[payee] = deposits[payee] + amount;
    }

    //only the seller can call withdraw function and this fun will withdarw the ether from buyer's to seller's account
    function withdraw(address payable payee) onlySeller external {
        uint256 payment = deposits[payee];
        deposits[payee] = 0;
        payee.transfer(payment);
    }

    //this function will show agent's current balance
    function getBalance() external view returns (uint256) {
        return seller.balance;
    }
}
