// SPDX-License-Identifier: MIT
// contracts Vedant.sol
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vedant is ERC20 {
    constructor(uint initialSupply) ERC20("Vedant", "VDT") {
        _mint(msg.sender,initialSupply);
    }
}
