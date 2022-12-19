//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract TicketCounter {
    address public ticketCounterOwner;
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
    //Ticket Structure 
    struct Ticket{
        uint id;
        address owner;
        string to;
        string from;
        uint timestamp;
        int256 price;
    }

    mapping(uint=>Ticket) public tickets;
    uint public ticketID;

    //Ticket Book Function which has hardcode price 150
    function bookTicket(string memory _to, string memory _from) public payable returns(bool){
        ticketID++;
        
        tickets[ticketID]=Ticket({  id: ticketID,
            owner: msg.sender,
            to: _to,
            from: _from,
            timestamp: block.timestamp,
            price:150
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
             int price ,
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