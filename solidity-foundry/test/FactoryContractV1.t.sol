// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {InscriptionTokenV1} from "../src/InscriptionTokenV1.sol";
import {InscriptionTokenV2} from "../src/InscriptionTokenV2.sol";
import {FactoryContractV1} from "../src/FactoryContractV1.sol";
import {FactoryContractV2} from "../src/FactoryContractV2.sol";

contract FactoryContractV1Test is Test {
    FactoryContractV1 factoryV1;

    string public name = "KK Token";
    string public symbol = "KK";
    uint public totalSupply = 1000;
    uint public perMint = 10;

    function setUp() public {
        factoryV1 = new FactoryContractV1();
    }

    //测试FactoryContractV1版本
    function testDeployInscriptionV1() public {
        address tokenAddr = factoryV1.deployInscription(
            name,
            symbol,
            totalSupply,
            perMint
        );

        InscriptionTokenV1 token = InscriptionTokenV1(tokenAddr);

        // 验证代币信息是否正确
        assertEq(token.name(), name, "Token name mismatch");
        assertEq(token.symbol(), symbol, "Token symbol mismatch");
        assertEq(token.totalSupply(), totalSupply, "Total supply mismatch");
        assertEq(
            token.balanceOf(address(factoryV1)),
            totalSupply,
            "Factory should hold initial supply"
        );

        uint initialBalance = token.balanceOf(address(this));

        // 使用 FactoryContractV1 合约进行 mint
        factoryV1.mintInscription(tokenAddr);

        // 验证 mint 后余额增加
        uint newBalance = token.balanceOf(address(this));
        assertEq(newBalance, initialBalance + perMint, "Mint amount mismatch");
    }

}
