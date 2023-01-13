// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts@4.8.0/token/ERC20/ERC20.sol";

contract Aastha is ERC20 {
    constructor() ERC20("Aastha", "HWO") {
        _mint(msg.sender, 100 * 10 ** decimals());
    }
}
