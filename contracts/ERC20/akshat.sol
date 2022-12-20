// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Akshat is ERC20 {
    constructor() ERC20("Akshat", "yo") {
        _mint(msg.sender, 1000 * 10 ** decimals());
    }
}
