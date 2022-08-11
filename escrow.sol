// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Escrow {

    address public payer;
    address payable public payee;
    address public lawyer;
    uint public contractAmount;
    bool public contractActive;

    constructor( address _payer, address payable _payee, address _lawyer, uint _contractAmount ) {
        payer          = _payer;
        payee          = _payee;
        lawyer         = _lawyer;
        contractAmount = _contractAmount; //this is in wei by default
        contractActive  = false;
    }

    function initEscrowContract() payable external {
        require( msg.sender == payer, "Contract will be initiated when payer sends ether.");
        require( msg.value >= contractAmount, "Cannot accept ether less than the contract amount.");
        contractActive = true;
    }

    function endEscrowContract() external {
        require( msg.sender == lawyer, "Only lawyer can end the contract.");
        require( contractActive == true, "Only active contract can be called off." );
        payee.transfer( contractAmount );
    }

    function balance() view external returns(uint){
        return address(this).balance;
    }
}
