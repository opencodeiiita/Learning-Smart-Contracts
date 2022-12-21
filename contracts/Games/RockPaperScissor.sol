// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract RockPaperScissor {

    address payable zeroAddress = payable(0x0);
    address payable player1=zeroAddress;
    address payable player2=zeroAddress;
    address owner;

    uint bet1=0;
    uint bet2=0;

    enum game {rock,paper,scissor}
    game state1;
    game state2;

    receive() external payable{

    }

    constructor() public {
        owner=msg.sender;
    }

    function Enter() external returns(uint){
        require(msg.sender!=owner,"The owner cannot enter the game");
        if(player1==zeroAddress){ 
            player1 = payable(msg.sender);
            return 1;
        }
        else if(player2==zeroAddress){ 
            require(msg.sender!=player1,"You have already entered the game");
            player2 = payable(msg.sender);
            return 2;
        }
        else return 0;
    }

    modifier onlyPlayer1 {
      require(msg.sender == player1,"Only player 1 can bet here");
      _;
    }

    function betPlayer1(string memory _rps) public payable onlyPlayer1 {
        require(msg.value>0,"Transferring ether is necessary");
        bet1=msg.value;
        if(keccak256(abi.encodePacked(_rps))==keccak256(abi.encodePacked("rock"))) state1=game.rock;
        else if(keccak256(abi.encodePacked(_rps))==keccak256(abi.encodePacked("paper"))) state1=game.paper;
        else state1=game.scissor;
    }

    modifier onlyPlayer2 {
      require(msg.sender == player2,"Only player 2 can bet here");
      _;
    }

    function betPlayer2(string memory _rps) public payable onlyPlayer2 {
        require(msg.value>0,"Transferring ether is necessary");
        bet2=msg.value;
        if(keccak256(abi.encodePacked(_rps))==keccak256(abi.encodePacked("rock"))) state2=game.rock;
        else if(keccak256(abi.encodePacked(_rps))==keccak256(abi.encodePacked("paper"))) state2=game.paper;
        else state2=game.scissor;
    }

    function determineWinner() public view returns(uint){
        if(state1==game.rock){
            if(state2==game.scissor) return 1;
            if(state2==game.paper) return 2;
            if(state2==game.rock) return 0;
        }
        if(state1==game.paper){
            if(state2==game.scissor) return 2;
            if(state2==game.paper) return 0;
            if(state2==game.rock) return 1;
        }
        if(state1==game.scissor){
            if(state2==game.scissor) return 0;
            if(state2==game.paper) return 1;
            if(state2==game.rock) return 2;
        }
        return 0;
    }

    function play() external payable returns(address payable){
        require((bet1>0) && (bet2>0),"Both players have still not kept their bet");
        uint winner = determineWinner();
        if(winner==1){
            player1.transfer(address(this).balance);
            return player1;
        }
        if(winner==2){
            player2.transfer(address(this).balance);
            return player2;
        }
        if(winner==0){
            (bool sent, bytes memory data) = player1.call{value: bet1}("");
            require(sent, "Failed to send Ether");
            (bool sent2, bytes memory data2) = player2.call{value: bet2}("");
            require(sent2, "Failed to send Ether");
            return zeroAddress;
        }
    }
}