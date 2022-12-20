// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract faucet is ERC20{

    uint cooldown=block.timestamp;

    // Declaring the token with user input name and symbol when the contract is called
    constructor(
        string memory userName,
        string memory userSymbol
    ) ERC20(userName,userSymbol) public {}
    
    // Function to actually transfer the tokens into users account
    function mint(address _userAddress,uint amount) external {
        require(block.timestamp>(cooldown));    // Checks if the cooldown time has ended
        _mint(_userAddress,amount);
        cooldown=block.timestamp + 10 minutes;  // Sets the cooldown time so tokens can be asked for once every 10 minutes
    }
}