// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Sanyam is ERC20{
    constructor() ERC20("Sanyam", "SAM"){
        _mint(msg.sender,100*10**18);
    }
}