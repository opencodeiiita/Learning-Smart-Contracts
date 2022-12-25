// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Marriage{

    string status="Single";
    address payable zeroAddress = payable(0x0);
    address payable proposer=zeroAddress; 
    address payable proposed=zeroAddress;
    address payable divorcer=zeroAddress;
    address payable divorcee=zeroAddress;
    bool deposit1=false;
    bool deposit2=false;

    receive() external payable{

    }

    constructor(){

    }
    
    function propose(address payable _proposed) public {
        require(proposer==zeroAddress,"Proposal has already been made");
        proposer=payable(msg.sender);
        proposed=_proposed;
    }

    function getStatus() public view returns(string memory){
        return status;
    }

    function acceptProposal() public {
        require(payable(msg.sender)==proposed,"You are not the one who was proposed");
        status="Married";
    }

    function returnJointAccountAddress() public view returns(address){
        require((payable(msg.sender)==proposed) || (payable(msg.sender)==proposer),"You are not involved in the marriage");
        return address(this);
    }

    function Deposit() public payable {
        require(keccak256(abi.encodePacked(status))==keccak256(abi.encodePacked("Married")),"The status of contract is not married");
        require((payable(msg.sender)==proposed) || (payable(msg.sender)==proposer),"You are not involved in the marriage");
        require(msg.value>0,"Deposit non-zero ether");
        if((payable(msg.sender)==proposed)){
            deposit2=true;
        }
        if((payable(msg.sender)==proposer)){
            deposit1=true;
        }
    }

    function Divorce() public {
        require(deposit1 && deposit2,"You cannot ask for divorce if joint account not made");
        require((payable(msg.sender)==proposed)||(payable(msg.sender)==proposer),"You are not involved in the marriage");
        require(divorcer==zeroAddress,"Divorce application already made");
        divorcer=payable(msg.sender);
        if(divorcer==proposer) divorcee=proposed;
        if(divorcer==proposed) divorcee=proposer;
    }

    function acceptDivorce() public {
        require(payable(msg.sender)==divorcee,"You are not the one who was asked for divorce");
        status="Divorced";
        split();
    }

    function split() public payable {
        proposed.transfer((address(this).balance)/2);
        proposer.transfer((address(this).balance)/2);
    }
}