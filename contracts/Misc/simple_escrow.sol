// SPDX-License-Identifier: MIT

pragma solidity ^0.8.14;

contract escrow {
    address public seller;
    address payable buyer;

    // specify the buyer
    constructor(address payable _buyer) {
        seller = msg.sender;
        buyer = _buyer;
    }
    // function to deposit amount by buyer 
    function deposit() public payable {
        require(msg.sender==buyer,"Can only be accessed by the buyer");
    }
    // function to withdraw the amount
    function withdraw() public {
        require(msg.sender==seller,"Can only be accessed by seller");
        buyer.transfer(address(this).balance);
    }
    // function to check balance of contract
    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}