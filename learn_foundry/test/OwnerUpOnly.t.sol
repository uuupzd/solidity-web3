// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "../src/OwnerUponly.sol";

contract OwnerUpOnlyTest is Test{
    OwnerUponly upOnly;

    function setUp() public {
        upOnly = new OwnerUponly();
    }

    function testIncrementAsOwner() public {
        assertEq(upOnly.count(), 0);
        upOnly.increment();
        assertEq(upOnly.count(), 1);
    }

    function testFailIncrementAsNotOwner() public {
        //vm.expectRevert(Unauthorized.selector);
        vm.prank(address(0));
        upOnly.increment();
    }

}
