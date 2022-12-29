// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
Primary is a contract where you can deposit and withdraw ETH.
This contract is vulnerable to a certain hack. Explain the hack and find the solution(s).
*/

// The problem with this code is that whenever a contract receives ether the fallback function is called,
// therefore the balance of the contract is not set to zero and ether keeps getting transferred to the 
// external contract till the balance of primary contract becomes less than that stored in mapping for external.

contract Primary {
    mapping(address => uint) public balances; 

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0);

        balances[msg.sender] = 0;
        // Here setting the balance zero before the transaction ensures this function runs only once.

        (bool sent, ) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send Ether");

        if(!sent) balances[msg.sender] = bal;
        // To provide security when the transaction fails and not cut ether unfairly
        // balances[msg.sender] = 0;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract External {
    Primary public primary;

    constructor(address _primaryAddress) {
        primary = Primary(_primaryAddress);
    }

    fallback() external payable {
        if (address(primary).balance >= 1 ether) {
            primary.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        primary.deposit{value: 1 ether}();
        primary.withdraw();
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}