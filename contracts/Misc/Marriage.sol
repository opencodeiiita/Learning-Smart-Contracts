// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

contract Marriage{

    enum state {Single,Married,Divorced}
    state status=state.Single;
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

    // The function through which a person can propose another person
    function propose(address payable _proposed) public {
        require(proposer==zeroAddress,"Proposal has already been made");
        proposer=payable(msg.sender);
        proposed=_proposed;
    }

    // Returns the status of the contract
    function getStatus() public view returns(state){
        return status;
    }

    // The person who has been proposed can accept the offer
    function acceptProposal() public {
        require(payable(msg.sender)==proposed,"You are not the one who was proposed");
        status=state.Married;
    }

    // Returns the address of this contract
    function returnJointAccountAddress() public view returns(address){
        require((payable(msg.sender)==proposed) || (payable(msg.sender)==proposer),"You are not involved in the marriage");
        return address(this);
    }

    // The couple deposits money for their joint account
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

    // One of them could ask for divorce
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
        status=state.Divorced;
        split();
    }

    // Called from the function only, transfers the joint account balance to the ex-couple's accounts
    function split() public payable {
        proposed.transfer((address(this).balance)/2);
        proposer.transfer((address(this).balance)/2);
    }
}
