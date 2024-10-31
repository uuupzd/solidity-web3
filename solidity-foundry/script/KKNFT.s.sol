// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {KKNFT} from "../src/KKNFT.sol";

//forge script script/KKNFT.s.sol --sig "run()" --account solidity-foundry --rpc-url https://ethereum-sepolia-rpc.publicnode.com --broadcast --verify

contract CounterScript is Script {
    KKNFT public kknft;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        kknft = new KKNFT(0xDeFf00eBB5ab5688eb09eb2ab1E073A17e8F65e5);

        vm.stopBroadcast();
    }
}
