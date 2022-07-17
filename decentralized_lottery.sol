// SPDX-License-Identifier: GPL-3.0

/*
Lottery implementation:
Participants contribute -> manager gets the lottery fee -> winner gets the remaining amount
*/

pragma solidity ^0.8;

contract Lottery {

    address public manager; 
    address payable[] public participants;

    constructor() {
        manager = payable(msg.sender);
    }

    modifier onlyManager {
        require( msg.sender == manager, "Only manager can call this method" );
        _;
    }

    function getBalance() public view onlyManager returns(uint) {
        return address(this).balance;
    }

    receive() external payable {
        require( msg.value >= 2 ether );
        participants.push( payable(msg.sender) );
    }

    function runLottery() external onlyManager {

        uint winnerIdx = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length))) % participants.length;
        address payable winner;
        winner = participants[winnerIdx];
        winner.transfer( address(this).balance );
        participants =  new address payable[](0); //reset the participant list
    }

    function deleteMe() public onlyManager {
        selfdestruct( payable(manager) );
    }

}
