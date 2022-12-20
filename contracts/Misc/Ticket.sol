//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract TicketCounter {
    address public ticketCounterOwner;
    int public constant price=30;//Base price of every Ticket is 30 Dollar
    AggregatorV3Interface internal priceFeed;
     /**
     * Network: Goerli
     * Aggregator: ETH/USD
     * Address: 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
     */
    constructor() {
          ticketCounterOwner=msg.sender;
        priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
    }
    struct Ticket{
        uint id;
        address owner;
        string to;
        string from;
        uint timestamp;
        
    }

    mapping(uint=>Ticket) public tickets;
    uint public ticketID;
    function bookTicket(string memory _to, string memory _from) public payable returns(bool){
        ticketID++;
        int usd= _getEthLatestPrice();
        int val = int(msg.value)*usd;// Here we conver ether to usd 
        require(val>price,"Price Should Be 30 Dollar");// here we check weather user cross that base price or not 
        
        tickets[ticketID]=Ticket({  id: ticketID,
            owner: msg.sender,
            to: _to,
            from: _from,
            timestamp: block.timestamp
        });

        return true;
    }

    function returnOwner(uint _ticketId) public view ticketExist(_ticketId) returns(address){
        
        return tickets[_ticketId].owner;
    }

    function verifyOwner(address _owner,uint _ticketId) public view ticketExist(_ticketId) returns(bool){
        return (tickets[_ticketId].owner==_owner);
    }


    // This function give price of eth in usd      
    function _getEthLatestPrice() public view returns(int){
       (
            ,
            int price,
            ,
            ,

        ) = priceFeed.latestRoundData();

        return (price/(10**8));
    }

    modifier ticketExist(uint _ticketId){
        require(_ticketId<=ticketID,"Ticket is not exist");
        _;
    }
}