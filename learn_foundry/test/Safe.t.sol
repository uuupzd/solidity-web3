// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "forge-std/Test.sol";
import "../src/Safe.sol";

contract SafeTest is Test {
    Safe safe;
    receive() external payable {}

    function setUp() public {
        safe = new Safe();
    }

    function testWithDraw() public {
        payable(address(safe)).transfer(1 ether);
        uint preBalance = address(this).balance;
        safe.withDraw();
        uint postBalance = address(this).balance;

        assertEq(preBalance + 1 ether, postBalance);
    }

    function testWithDrawFuzz(uint96 amount) public {
        payable(address(safe)).transfer(1 ether);
        uint preBalance = address(this).balance;
        safe.withDraw();
        uint postBalance = address(this).balance;

        assertEq(preBalance + 1 ether, postBalance);
    }
}
