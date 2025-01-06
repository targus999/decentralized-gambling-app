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
    address private s_currentPlayer;
    uint256 private s_currentBet;

    uint256 private constant SUBCHAIN_ID =
        92202724794086798810647618690190293995206842793648912613930328258276972656689;
    bytes32 private constant KEYHASH =
        0x787d74caea10b2b357790d5b5247c2f63d1d91572a9846f780606e4d953677ae;
    uint32 private constant GAS_LIMIT = 40000;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private constant NUMWORDS = 1;
    uint256 private constant MIN_BET = 5e10;
    address private constant VRF_ADDRESS = 0x83F9AfA1bF349FB717eFcf6A8DC310F79d6aA598;

    

    event DiceRolled(address indexed player, uint256 bet, uint256 result);
    event CoinFlipped(address indexed player, uint256 bet, uint256 result);

    error Gamble__contract_is_busy();
    error Gamble__send_more_eth();

    constructor() VRFConsumerBaseV2Plus(VRF_ADDRESS) {}

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] calldata randomWords
    ) internal override {
        uint256 randomNumber;
        uint256 bet = s_currentBet;
        State state = s_currentState;
        address player = s_currentPlayer;
        if (state == State.Dice_Rolling) {
            randomNumber = (randomWords[0] % 6) + 1;
            if (randomNumber == bet && address(this).balance > 0) {
                withdraw(player);
            }
            emit DiceRolled(player, bet, randomNumber);
        } else if (state == State.Coin_Flipping) {
            randomNumber = randomWords[0] % 2;
            if (randomNumber == bet) {
                withdraw(player);
            }
            emit CoinFlipped(player, bet, randomNumber);
        }
        s_currentState = State.Open;
    }

    function placeBet(State gameType, uint256 bet) private {
        s_currentState = gameType;
        s_currentPlayer = msg.sender;
        s_currentBet = bet;

        // VRF Call
        uint256 requestId = requestRandomWords();
    }

    function rollDice(uint256 bet) external payable validRequest {
        placeBet(State.Dice_Rolling, bet);
    }

    function flipCoin(uint256 bet) external payable validRequest {
        placeBet(State.Coin_Flipping, bet);
    }

    function withdraw(address player) private {
        (bool success, ) = payable(player).call{value: address(this).balance}(
            ""
        );
        require(success, "Withdrawal failed");
    }

    function requestRandomWords() internal returns (uint256) {
        return
            s_vrfCoordinator.requestRandomWords(
                VRFV2PlusClient.RandomWordsRequest({
                    keyHash: KEYHASH,
                    subId: SUBCHAIN_ID,
                    requestConfirmations: REQUEST_CONFIRMATIONS,
                    callbackGasLimit: GAS_LIMIT,
                    numWords: NUMWORDS,
                    extraArgs: VRFV2PlusClient._argsToBytes(
                        VRFV2PlusClient.ExtraArgsV1({nativePayment: true})
                    )
                })
            );
    }

    modifier validRequest() {
        if (msg.value < MIN_BET) {
            revert Gamble__send_more_eth();
        }
        if (s_currentState != State.Open) {
            revert Gamble__contract_is_busy();
        }
        _;
    }
}
