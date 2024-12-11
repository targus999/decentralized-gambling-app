// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Gamble {
    enum State{
        Open,
        Calculating
    }


    State public currentState;


    error Gamble__contract_is_busy();
    error Gamble__send_more_eth();

    

    function rollDice(uint256 bet) public payable validRequest {
        currentState = State.Calculating;
        //VRF CALL
        uint256 randomNumber = 5;
        if(bet ==randomNumber){
            withdraw();
        }
        currentState = State.Open;
    }


    function flipCoin(uint256 bet) public payable validRequest {
        currentState = State.Calculating;
        //VRF CALL
        uint256 randomNumber = 1;
        if(bet == randomNumber){    
            withdraw();
        }
        currentState = State.Open;
    }
    function withdraw() private {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    modifier validRequest() {
        if(msg.value != 5e10){
            revert Gamble__send_more_eth();
        }
        if(currentState == State.Calculating){
            revert Gamble__contract_is_busy();
        }
        _;
    }
}
