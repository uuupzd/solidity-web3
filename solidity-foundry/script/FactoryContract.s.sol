// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;
import "forge-std/Script.sol";
import {InscriptionTokenV1} from "../src/InscriptionTokenV1.sol";
import {FactoryContractV1} from "../src/FactoryContractV1.sol";
import {InscriptionTokenV2} from "../src/InscriptionTokenV2.sol";
import {FactoryContractV2} from "../src/FactoryContractV2.sol";

contract FactoryContract is Script{

        address owner = 0xDeFf00eBB5ab5688eb09eb2ab1E073A17e8F65e5;
        function setUp() public {}
    function run() external {
        vm.startBroadcast();

        FactoryContractV1 factoryv1 = new FactoryContractV1();
        console.log("FactoryContractV1 deployed at:", address(factoryv1));

        FactoryContractV2 factoryv2 = new FactoryContractV2();
        factoryv2.initialize(owner);
        console.log("FactoryContractV2 deployed at:", address(factoryv2));

        vm.stopBroadcast();
    }
}