// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;
import "forge-std/Script.sol";
import {BankV2} from "../src/BankV2.sol";

contract Deloy is Script{
    function setUp() public {}
    function run() external {

        vm.startBroadcast();
        BankV2 bank = new BankV2();
        bank.setAdmin(0x0edC1769D93cC8A3f4fEB030791e0793E4Aef2d7);
        console.log("bank",address(bank));
        vm.stopBroadcast();
    }
}
