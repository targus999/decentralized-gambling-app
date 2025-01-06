// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script,console2} from "forge-std/Script.sol";
import {Gamble} from "../src/Gamble.sol";

contract DeployGamble is Script {
    function run() external returns (Gamble) {
        vm.startBroadcast();

        Gamble GambleContract = new Gamble();
         // Log the deployed contract address
        console2.log("Gamble contract deployed at:", address(GambleContract));

        vm.stopBroadcast();
        return GambleContract;
    }
}
