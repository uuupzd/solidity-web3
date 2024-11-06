// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PrivateLock} from "../src/PrivateLock.sol";

//forge script ./script/PrivateLock.s.sol --sig "run()" --account solidity-foundry --rpc-url https://ethereum-sepolia-rpc.publicnode.com --broadcast --verify

contract CounterScript is Script {
    PrivateLock public lock;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        lock = new PrivateLock();

        vm.stopBroadcast();
    }
}
