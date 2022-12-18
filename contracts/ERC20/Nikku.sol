// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract MyToken is ERC20 {
    constructor(uint t_supply) ERC20("Nikku.Dev","NDEV"){
        _mint(msg.sender,t_supply*(10**18));
        
    }

}