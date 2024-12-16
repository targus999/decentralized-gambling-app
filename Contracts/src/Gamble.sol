// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Gamble {
    enum State {
        Open,
        Dice_Rolling,
        Coin_Flipping
    }

    State public currentState;
    uint256 private immutable minimumBet;

    event DiceRolled(address indexed player, uint256 bet, uint256 result);
    event CoinFlipped(address indexed player, uint256 bet, uint256 result);
    event BetPlaced(
        address indexed player,
        uint256 bet,
        State gameType,
        uint256 currentBalance,
        uint256 timestamp
    );

    error Gamble__contract_is_busy();
    error Gamble__send_more_eth();

    constructor() {
        minimumBet = 5e10;
    }

    function rollDice(uint256 bet) external payable validRequest returns(uint256) {
        currentState = State.Dice_Rolling;
        emit BetPlaced(
            msg.sender,
            bet,
            currentState,
            address(this).balance,
            block.timestamp
        );
        //VRF CALL
        uint256 randomNumber = 5;
        if (bet == randomNumber) {
            withdraw();
        }
        emit DiceRolled(msg.sender, bet, randomNumber);
        currentState = State.Open;
        return randomNumber;
    }

    function flipCoin(uint256 bet) external payable validRequest returns(uint256){
        currentState = State.Coin_Flipping;
        emit BetPlaced(
            msg.sender,
            bet,
            currentState,
            address(this).balance,
            block.timestamp
        );
        //VRF CALL
        uint256 randomNumber = 1;
        if (bet == randomNumber) {
            withdraw();
        }
        emit CoinFlipped(msg.sender, bet, randomNumber);
        currentState = State.Open;
        return randomNumber;
    }
    function withdraw() private {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }

    modifier validRequest() {
        if (msg.value < minimumBet) {
            revert Gamble__send_more_eth();
        }
        if (currentState != State.Open) {
            revert Gamble__contract_is_busy();
        }
        _;
    }
}
