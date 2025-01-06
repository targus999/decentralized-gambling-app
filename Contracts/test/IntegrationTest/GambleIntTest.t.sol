// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {DeployGamble} from "../../script/DeployGamble.s.sol";
import {Gamble} from "../../src/Gamble.sol";

contract IntegrationTestGamble is Test {
    Gamble private gamble;

    address private owner;
    address private user;

    function setUp() public {
        // Set up the deployment
        DeployGamble deployScript = new DeployGamble();
        gamble = deployScript.run();

        // Assign addresses for owner and user
        owner = vm.addr(1);
        user = vm.addr(2);

        // Fund the user with ETH
        vm.deal(user, 10 ether);
    }

    function testUserCanRollDice() public {
        // Simulate a user placing a dice roll bet
        vm.startPrank(user);

        // Place bet with sufficient ETH
        gamble.rollDice{value: 1 ether}(3);

        // Assert that the state is now "Dice_Rolling"
        assertEq(
            uint256(gamble.s_currentState()),
            uint256(Gamble.State.Dice_Rolling),
            "State should be Dice_Rolling"
        );

        vm.stopPrank();
    }

    function testVRFCallbackDiceRoll() public {
        // Simulate a user placing a dice roll bet
        vm.startPrank(user);
        gamble.rollDice{value: 1 ether}(3);
        vm.stopPrank();

        // Mock VRF callback with a random number
        uint256 requestId = gamble.requestRandomWords();
        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = 5;
        // Simulate random number 5

        gamble.fulfillRandomWords(requestId, randomWords);

        // Assert that the state is reset to "Open"
        assertEq(
            uint256(gamble.s_currentState()),
            uint256(Gamble.State.Open),
            "State should be reset to Open"
        );
    }

    function testUserCanFlipCoin() public {
        // Simulate a user placing a coin flip bet
        vm.startPrank(user);

        // Place bet with sufficient ETH
        gamble.flipCoin{value: 1 ether}(1); // Bet on heads (1)

        // Assert that the state is now "Coin_Flipping"
        assertEq(
            uint256(gamble.s_currentState()),
            uint256(Gamble.State.Coin_Flipping),
            "State should be Coin_Flipping"
        );

        vm.stopPrank();
    }

    function testVRFCallbackCoinFlip() public {
        // Simulate a user placing a coin flip bet
        vm.startPrank(user);
        gamble.flipCoin{value: 1 ether}(1); // Bet on heads (1)
        vm.stopPrank();

        // Mock VRF callback with a random number
        uint256 requestId = gamble.requestRandomWords();
        uint256[] memory randomWords = new uint256[](1);
        randomWords[0] = 1; // Simulate random number resulting in heads (1)

        gamble.fulfillRandomWords(requestId, randomWords);

        // Assert that the state is reset to "Open"
        assertEq(
            uint256(gamble.s_currentState()),
            uint256(Gamble.State.Open),
            "State should be reset to Open"
        );
    }
}
