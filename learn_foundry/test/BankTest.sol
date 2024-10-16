// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "forge-std/Test.sol";
import "../src/Bank.sol";

contract BankTest is Test {
    Bank bank;
    address user = address(0);

    function setUp() public {
        bank = new Bank();
    }

    //测试depositETH函数
    function testBankBalance() public {
        vm.deal(user, 1 ether);
        uint depositAmount = 0.5 ether;

        //存款前余额为0
        assertEq(bank.balanceOf(user), 0);

        //用户存款
        vm.prank(user);
        bank.depositETH{value: depositAmount}();

        //存款后余额更新为0.5 ether
        assertEq(bank.balanceOf(user), depositAmount);
    }


    //测试Bank合约中Event事件
    function testBankEvent() public {
        vm.deal(user, 1 ether);
        uint depositAmount = 0.5 ether;

        //期望事件
        vm.expectEmit(true, true, false, true);
        emit Bank.Deposit(user, depositAmount);

        //用户存款
        vm.prank(user);
        bank.depositETH{value: depositAmount}();
    }
}
