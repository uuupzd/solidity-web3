// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "forge-std/Test.sol";
import "forge-std/mocks/MockERC20.sol";
import "../src/OwnerUponly.sol";
import "../src/Counter.sol";


contract StudyTest is Test {
    function setUp() public {}
    //修改区块高度
    function testRoll() public {
        console.log("New Block Number1:", block.number);
        uint newHeight = 100;
        vm.roll(newHeight);
        console.log("New Block Number1:", block.number);

        assertEq(block.number, newHeight);
    }

    //更改消息发送者
    function testPrank() public {
        console.log("Current contract address:", address(this));
        OwnerUponly OwnerUpOnly1 = new OwnerUponly();
        console.log("OwnerUpOnly1 owner address:", OwnerUpOnly1.owner());

        address newSender = 0xDeFf00eBB5ab5688eb09eb2ab1E073A17e8F65e5;
        vm.prank(newSender);
        OwnerUponly OwnerUpOnly2 = new OwnerUponly();
        console.log("OwnerUpOnly2 owner address:", OwnerUpOnly2.owner());
    }

    function testIncrement() public {
        address alice = address(0xDeFf00eBB5ab5688eb09eb2ab1E073A17e8F65e5);
        vm.startPrank(alice);
        OwnerUponly upOnly = new OwnerUponly();
        for (uint i = 0; i < 10; i++) {
            upOnly.increment();
        }
        vm.stopPrank();
        assertEq(upOnly.count(), 10);
    }

    function testWarp() public {
        uint newTimestamp = 1729844500;
        vm.warp(newTimestamp);
        console.log("New Block Timestamp1:", newTimestamp);
        assertEq(block.timestamp, newTimestamp);

        skip(10 seconds);
        console.log("New Block Timestamp2:", block.timestamp);
    }

    function testDeal() public {
        address recipient = address(0xDeFf00eBB5ab5688eb09eb2ab1E073A17e8F65e5);
        uint amount = 100 ether;
        deal(recipient, amount);

        console.log("Recipient Balance", recipient.balance);
        assertEq(recipient.balance, amount);
    }

    function testCallByOwner() public {
        OwnerUponly upOnly = new OwnerUponly();
        upOnly.increment();

        address alice = address(0xDeFf00eBB5ab5688eb09eb2ab1E073A17e8F65e5);
        vm.expectRevert("Unauthorized");
        vm.prank(alice);
        upOnly.increment();
    }

    function testFuzzSetNumber(uint x) public {
        Counter counter = new Counter();
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function testERC20Transfer(address to,uint amount) public {
        vm.assume(to != address(0));
        vm.assume(amount > 0 && amount < 1e9 ether);
        address alice = makeAddr("alice");
        MockERC20 erc20 = new MockERC20();
        erc20.initialize("Test Token", "TST", 18);
        deal(address(erc20), alice,1e9 ether);

        uint balanceTo = erc20.balanceOf(to);
        uint balanceAlice = erc20.balanceOf(alice);
        vm.prank(alice);
        erc20.transfer(to, amount);

        assertEq(erc20.balanceOf(to), balanceTo + amount);
        assertEq(erc20.balanceOf(alice), balanceAlice - amount);
    }

}
