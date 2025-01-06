// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {Gamble} from "../../src/Gamble.sol";

contract GambleTest is Test {
    Gamble private gamble;

    // Mock address for VRF
    address private constant VRF_ADDRESS =
        0x83F9AfA1bF349FB717eFcf6A8DC310F79d6aA598;

    function setUp() public {
        // Deploy the Gamble contract
        gamble = new Gamble();
    }

    function testInitialContractState() public {
        // Assert that the contract's initial state is "Open"
        assertEq(
            uint256(gamble.s_currentState()),
            0,
            "Initial state should be Open"
        );
    }

    function testPlaceBetWithInsufficientEth() public {
        // Try to place a bet with insufficient ETH and expect a revert
        vm.expectRevert(Gamble.Gamble__send_more_eth.selector);
        gamble.rollDice{value: 1e10}(2); // Bet amount less than MIN_BET
    }

    function testContractBusyReverts() public {
        // Set up the contract in a busy state
        vm.deal(address(this), 10 ether);
        gamble.rollDice{value: 1 ether}(2);

        // Try placing another bet and expect revert
        vm.expectRevert(Gamble.Gamble__contract_is_busy.selector);
        gamble.flipCoin{value: 1 ether}(1);
    }
}
