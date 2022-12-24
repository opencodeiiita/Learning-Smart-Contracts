// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract lottery is ERC20{
    address public owner;
    address payable[] public players;

    constructor()ERC20("OpenCode","OPC"){
        // address of owner who is deploying the contract
        owner = msg.sender;
        _mint(owner,10000*(10**18));
    }

    function enter() public payable {
        //preset entry fee;
        require(msg.value >= 100);

        // adrress of the player entering the lottery
        players.push(payable(msg.sender));
    }

    function _getRandomNumber() private view returns (uint){
        // generating a hash number by concatenating both owner address and timestamp then converting it unsigned int..
        return uint(keccak256(abi.encodePacked(owner,block.timestamp)));
    }

    function pickWinner() public onlyowner {
        uint index = _getRandomNumber() % players.length;
        super._transfer(owner, players[index], 100*(10**18));// Transfer 100 OPC tokens to winner from owner account 
        // players[index].transfer(address(this).balance);
        // reset contract
        players = new address payable[](0);
    }

    modifier onlyowner() {
      require(msg.sender == owner);
      _;
   }
}