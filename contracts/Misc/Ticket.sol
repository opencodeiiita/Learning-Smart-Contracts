//SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
contract TicketCounter {
    address public ticketCounterOwner;
    AggregatorV3Interface public instance = AggregatorV3Interface(0x9326BFA02ADD2366b30bacB125260Af641031331);
    constructor(){
        ticketCounterOwner=msg.sender;
    }
    struct Ticket{
        uint id;
        address owner;
        string to;
        string from;
        uint timestamp;
        int price;
    }

    mapping(uint=>Ticket) public tickets;
    uint public ticketID;
    function bookTicket(string memory _to, string memory _from) public payable returns(bool){
        ticketID++;
        //Here 150 is hardcoded price of ticket in rupee
        uint _priceInEth = (msg.value)/(10**18);//Here Convert Wei Into Ether
        int _priceInINR= _getEthLatestPrice()*int(_priceInEth);// Here conver eth in to Rupee By It Latest Price
        require(150==msg.value,"You Can't Buy Ticket");
        tickets[ticketID]=Ticket({  id: ticketID,
         owner: msg.sender,
         to: _to,
         from: _from,
         timestamp: block.timestamp,price:(_priceInINR)});

         return true;
    }

    function returnOwner(uint _ticketId) public view ticketExist(_ticketId) returns(address){
        
        return tickets[_ticketId].owner;
    }

    function verifyOwner(address _owner,uint _ticketId) public view ticketExist(_ticketId) returns(bool){
        return (tickets[_ticketId].owner==_owner);
    }


         
    function _getEthLatestPrice() public view returns(int){
        (
        uint80 roundID, 
        int price,
        uint startedAt,
        uint timeStamp,
        uint80 answeredInRound
    ) = instance.latestRoundData();
    return price;
    }

    function convertETHToINR(int _eth) public view returns(int){
        int256 latest= _getEthLatestPrice();
        return latest*_eth;
    }
    modifier ticketExist(uint _ticketId){
        require(_ticketId<=ticketID,"Ticket is not exist");
        _;
    }
}