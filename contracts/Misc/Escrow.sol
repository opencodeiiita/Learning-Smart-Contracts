// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

contract Escrow{

    address public buyer;
    address payable public seller;//seller made payable so that ethers can be transferred to its address
    //variable of current state of escrow
    bool deposited=false;
    bool delivered=false;
    bool withdrawn=false;
    uint256 amount=0;

    //modifiers made to make functions to be called only by seller or buyer according to the requirement

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this method");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this method");
        _;
    }

    //events to store address of buyer and seller and amount deposited and withdrawn respectively in transaction log
    event Deposited(address buyer, uint256 amount);
    event Withdrawn(address seller, uint256 amount);

    constructor(address _buyer, address payable _seller) {
        buyer = _buyer;
        seller = _seller;
    }     

    //Only the buyer can call this function and this will transfer funds from his account to the contract
    function deposit() public onlyBuyer payable  {
        require(msg.sender!=seller,"seller cannot be buyer");
        //Each time buyer call this function, the deposit is added to the total amount
        amount+= msg.value;
        deposited=true;
        emit Deposited(msg.sender,msg.value);
    }

    //Function called by buyer once it has recieved the Asset
    function confirm_delivery() public onlyBuyer{
        require(deposited==true,"First make the required payment");
        delivered=true;
    }

    //Function called by seller to withdarw the amount from contract to his account
    //It can be called only once and only by the seller
    function withdraw() public payable onlySeller{
        require(delivered==true,"Asset not transferred yet");//It can withdraw only when asset has been transferred
        require(!withdrawn,"Already withdrawn");
        uint256 payment = amount;
        amount = 0;//to ensure that amount is withdrawn only once
        seller.transfer(payment);
        withdrawn=true;
        emit Withdrawn(msg.sender,msg.value);
    }

    //function to check balance of contract
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}