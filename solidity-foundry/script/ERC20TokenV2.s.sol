// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC20TokenV2} from "../src/ERC20TokenV2.sol";

//forge script script/ERC20TokenV2.s.sol --sig "run()" --account solidity-foundry --rpc-url https://ethereum-sepolia-rpc.publicnode.com --broadcast --verify

contract CounterScript is Script {
    ERC20TokenV2 public kkToken;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        kkToken = new ERC20TokenV2('KK Token','KK');

        vm.stopBroadcast();
    }
}
