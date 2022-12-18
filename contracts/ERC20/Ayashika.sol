// SPDX-License-Identifier: MIT
// contracts Ayashika.sol
pragma solidity ^0.8.17;

import "@openzeppelin/contracts@4.8.0/token/ERC20/ERC20.sol";

contract Ayashika is ERC20 {
    constructor(uint initialSupply) ERC20("Ayashika", "AYG") {
        _mint(msg.sender,initialSupply);
    }
}