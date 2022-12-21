// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

import "@openzeppelin/contracts@4.8.0/token/ERC20/ERC20.sol";

contract Aynansh is ERC20 {
    constructor() ERC20("Aynansh", "AYK") {
        _mint(msg.sender,1000*10**18);
    }
}