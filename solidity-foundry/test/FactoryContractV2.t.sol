// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {InscriptionTokenV2} from "../src/InscriptionTokenV2.sol";
import {FactoryContractV2} from "../src/FactoryContractV2.sol";

contract FactoryContractV2Test is Test {
    FactoryContractV2 public factory;
    InscriptionTokenV2 public tokenImplementation;
    address public owner;
    address public user;
    address public tokenAddr;

    uint totalSupply = 1000 ether;
    uint perMint = 100 ether;
    uint price = 0.1 ether;

    function setUp() public {
        owner = address(this);
        user = address(0x1234);
        factory = new FactoryContractV2();
        factory.initialize(owner);

        tokenImplementation = new InscriptionTokenV2();

        tokenAddr = factory.deployInscription(
            "KK Token",
            "KK",
            totalSupply,
            perMint,
            price
        );
    }

    // 测试工厂合约的部署和初始化
    function testFactoryDeploymentAndInitialization() public view {
        assertEq(
            factory.owner(),
            owner,
            "Factory owner should be set to deployer"
        );
        assertTrue(
            factory.insription() != address(0),
            "Token implementation address should be set"
        );
    }

    // 测试代币克隆和初始化
    function testDeployInscription() public view {
        InscriptionTokenV2 deployedToken = InscriptionTokenV2(tokenAddr);
        assertEq(
            deployedToken.totalSupplyCap(),
            totalSupply,
            "Total supply cap should be set correctly"
        );
        assertEq(
            deployedToken.perMint(),
            perMint,
            "Per mint amount should be set correctly"
        );
        assertEq(
            factory.tokenPrices(tokenAddr),
            price,
            "Token price should be set in the factory"
        );
    }

    // 测试用户调用 mintInscription 正常铸造代币
    function testMintInscription() public {
        vm.deal(user, 1 ether);
        vm.startPrank(user);

        factory.mintInscription{value: price}(tokenAddr);

        assertEq(
            InscriptionTokenV2(tokenAddr).balanceOf(user),
            perMint,
            "User balance should increase by perMint amount"
        );

        vm.stopPrank();
    }

    // 测试铸造代币时多付的金额返回给用户
    function testMintWithExcessPayment() public {
        vm.deal(user, 1 ether);
        vm.startPrank(user);

        uint userBalanceBefore = user.balance;
        factory.mintInscription{value: 0.5 ether}(tokenAddr);

        uint userBalanceAfter = user.balance;

        assertEq(
            userBalanceAfter,
            userBalanceBefore - price,
            "Excess payment should be returned to user"
        );

        vm.stopPrank();
    }

    // 测试仅限 owner 调用 withDraw 提取资金
    function testWithDrawByOwner() public {
        vm.deal(user, 1 ether);
        vm.startPrank(user);

        factory.mintInscription{value: price}(tokenAddr);

        vm.stopPrank();

        uint contractBalanceBefore = address(factory).balance;
        assertEq(
            contractBalanceBefore,
            price,
            "Contract balance should be equal to price after minting"
        );

        uint ownerBalanceBefore = owner.balance;

        factory.withDraw();

        uint ownerBalanceAfter = owner.balance;
        assertEq(
            ownerBalanceAfter,
            ownerBalanceBefore + price,
            "Owner balance should increase by contract balance after withdrawal"
        );
    }

    // 测试非 owner 调用 withDraw 失败
    function testWithDrawByNonOwner() public {
        vm.deal(user, 1 ether);
        vm.startPrank(user);
        factory.mintInscription{value: price}(tokenAddr);
        vm.stopPrank();

        vm.expectRevert("Not the owner");
        vm.startPrank(user);
        factory.withDraw();
        vm.stopPrank();
    }

    receive() external payable {}
}
