// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

contract Gamble is VRFConsumerBaseV2Plus {
    enum State {
        Open,
        Dice_Rolling,
        Coin_Flipping
    }

    State public s_currentState;
    uint256 private constant SUBCHAIN_ID =92202724794086798810647618690190293995206842793648912613930328258276972656689;
    address vrfCoordinator = 0x9DdfaCa8183c41ad55329BdeeD9F6A8d53168B1B;
    bytes32 private constant KEYHASH = 0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 private constant GAS_LIMIT = 40000;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUMWORDS = 1;

    uint256 private immutable i_minimumBet;

    event DiceRolled(address indexed player, uint256 bet, uint256 result);
    event CoinFlipped(address indexed player, uint256 bet, uint256 result);
    event BetPlaced(address indexed player, uint256 bet, State gameType, uint256 currentBalance, uint256 timestamp);

    error Gamble__contract_is_busy();
    error Gamble__send_more_eth();

    constructor(address linkAddress) VRFConsumerBaseV2Plus(linkAddress) {
        i_minimumBet = 5e10;
        
    }

    function fulfillRandomWords(uint256 requestId, uint256[] calldata randomWords) internal override {}

    function rollDice(uint256 bet) external payable validRequest returns (uint256) {
        s_currentState = State.Dice_Rolling;
        emit BetPlaced(msg.sender, bet, s_currentState, address(this).balance, block.timestamp);
        //VRF CALL
        uint256 requestId = s_vrfCoordinator.requestRandomWords(
            VRFV2PlusClient.RandomWordsRequest({
                keyHash: KEYHASH,
                subId: SUBCHAIN_ID,
                requestConfirmations: REQUEST_CONFIRMATIONS,
                callbackGasLimit: GAS_LIMIT,
                numWords: NUMWORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(VRFV2PlusClient.ExtraArgsV1({nativePayment: true}))
            })
        );


        //VRF CALL
        uint256 randomNumber = 5;
        if (bet == randomNumber) {
            withdraw();
        }
        emit DiceRolled(msg.sender, bet, randomNumber);
        s_currentState = State.Open;
        return randomNumber;
    }

    function flipCoin(uint256 bet) external payable validRequest returns (uint256) {
        s_currentState = State.Coin_Flipping;
        emit BetPlaced(msg.sender, bet, s_currentState, address(this).balance, block.timestamp);
        //VRF CALL
        uint256 randomNumber = 1;
        if (bet == randomNumber) {
            withdraw();
        }
        emit CoinFlipped(msg.sender, bet, randomNumber);
        s_currentState = State.Open;
        return randomNumber;
    }

    function withdraw() private {
        (bool success,) = msg.sender.call{value: address(this).balance}("");
        require(success, "Withdrawal failed");
    }


    modifier validRequest() {
        if (msg.value < i_minimumBet) {
            revert Gamble__send_more_eth();
        }
        if (s_currentState != State.Open) {
            revert Gamble__contract_is_busy();
        }
        _;
    }
}
