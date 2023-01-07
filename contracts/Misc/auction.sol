//SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;

interface IERC721{
    function transferFrom( address from, address to, uint nftId) external;
}

contract Auction {
    //auctioneer is made payable so that ethers can be transferred to his account 
    address payable public immutable auctioneer;
    uint public auctionEndTime;
    IERC721 public immutable nft;
    uint public immutable nftId;

    // variables of current state of auction
    address public highestBidder;
    uint public highestBid;
    uint public basePrice;//minimum price below which seller will not sell his nft
    bool public started;
    bool public ended;

    //a data structure to store value of bids of all the bidders with key as their respective address
    mapping(address => uint) public allBids;

    constructor(uint _basePrice, address _nft, uint _nftId) {
        auctioneer = payable(msg.sender);
        basePrice=_basePrice*10**18;
        nft=IERC721(_nft);
        nftId=_nftId;
    }

    //function called by auctioneer to start the auction
    function auctionStart() public{
        require(msg.sender==auctioneer,"Only owner can start the auction");
        require(!started, "started");//can be called only once by the auctioneer
        started=true;
        nft.transferFrom(auctioneer,address(this),nftId);
        auctionEndTime= uint(block.timestamp + 259200);//auction will run only for 3 days(259200 seconds)
    }


    //function called by user when each time user place their bids;
    function bid() public payable {
        require(msg.sender!=auctioneer,"Owner cannot bid");
        require(started, "Auction not yet started");//users can bid only when auction has started
        require(block.timestamp < auctionEndTime, "Auction has ended");//no user can bid after auction has ended
        require((msg.value+allBids[msg.sender])> highestBid, "Total bid is not more than the highest bid");
        require((msg.value+allBids[msg.sender])>= basePrice, "Bid should be at least equal to baseprice");

        highestBidder = msg.sender;//address of highestBidder updated is there is new bid which exceeds highestBid
        highestBid = msg.value+allBids[msg.sender];
        allBids[highestBidder] += msg.value;//updated the value of total bid corresponding to the address
    }

    // function called by all the users who did not win the auction to get their amount back
    //can be called only once by each user only after the auction has ended
    function withdraw() public {
        require(ended, "Auction has not yet ended");
        require(msg.sender!=highestBidder,"You won the auction");//user who won the auction cannot withdraw his amount back
        address payable recipient;
        uint amount;
        amount = allBids[msg.sender];
        require(amount>0,"You did not bid or amount already withdrawn");

        recipient = payable(msg.sender);
        allBids[recipient] = 0;//to ensure that no user withdraw amount more then once
        recipient.transfer(amount);//transfers the amount to the user's account
    }

    // function called by the auctioneer after the auction has ended to transfer the highestbid amount to his account
    //can be called only once by the auctioneer
    function auctionEnd() public {
        require(msg.sender==auctioneer);
        require(block.timestamp>=auctionEndTime, "The auction not ended yet");
        require(started,"not started");
        if(ended){
            revert("The function auction ended has already been called");//to ensure that auctioneer gets the highestBid amount only once
        }
        ended = true;
        nft.transferFrom(address(this),highestBidder,nftId);//nft is transferred to the highest bidder 
        auctioneer.transfer(highestBid);//highestBid is transferred to the auctioneer's account
    }
    
    //function to check balance of contract
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

}