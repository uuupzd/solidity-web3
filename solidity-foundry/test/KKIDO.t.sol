// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MockERC20} from "../test/MockERC20.sol";
import {KKIDO} from "../src/KKIDO.sol";

contract KKIDOTest is Test {
    KKIDO public kkido;
    MockERC20 public mockToken;
    address[] public users;

    uint256 public constant totalSupply = 1_000_000 * 10 ** 18;
    uint256 public constant minPurchase = 0.01 ether;
    uint256 public constant maxPurchase = 0.1 ether;
    uint256 public constant fundingGoal = 100 ether;
    uint256 public constant maxFunding = 200 ether;

    address public owner;
    address public buyer = address(0xBEEF);
    uint256 public PRESALE_DURATION = 1 days;

    function setUp() public {
        owner = address(0x1333);
        mockToken = new MockERC20("KK Token", "KK", 1_000_000 * 10 ** 18);
        kkido = new KKIDO(mockToken);
        mockToken.transfer(address(kkido), totalSupply);

        //随机添加100个用户
        for (uint i = 0; i < 100; i++) {
            address user = address(uint160(i + 1));
            users.push(user);
            //给每个账户一定的余额
            vm.deal(user, 10 ether);
        }
    }

    // test startPresale
    function testStartPresale() public {
        kkido.startPresale(PRESALE_DURATION);
        assertTrue(kkido.presaleActive(), "Presale should be active");
    }

    //test buyTokens
    function testBuyTokens() public {
        kkido.startPresale(PRESALE_DURATION);
        uint initialRaisedAmount = kkido.raisedAmount();
        uint totalContribution = 0;

        for (uint i = 0; i < 100; i++) {
            uint256 randomAmount = 0.03 ether;
            address user = users[i];
            vm.prank(user);
            kkido.buyTokens{value: randomAmount}();
            totalContribution += randomAmount;
        }
        assertEq(
            kkido.raisedAmount(),
            initialRaisedAmount + totalContribution,
            "Raised amount mismatch"
        );

        assertEq(
            address(kkido).balance,
            totalContribution,
            "The raised amount has been deposited into the kkido contract"
        );
    }

    // test finalizePresale
    function testFinalizePresale() public {
        uint256 raisedAmount = 110 ether;
        vm.startPrank(owner);
        kkido.startPresale(PRESALE_DURATION);
        kkido.setRaisedAmount(raisedAmount);

        kkido.finalizePresale();

        assertTrue(kkido.presaleFinalized(), "presale should be finalized");
        assertFalse(kkido.presaleActive(), "presale should not be active");

        uint ownerBalance = mockToken.balanceOf(owner);
        assertEq(
            ownerBalance,
            totalSupply,
            "owner should receive totalSupply tokens"
        );

        vm.stopPrank();
    }

    function testClaimRefund() public {
        uint256 buyAmount = 0.03 ether;
        uint256 raisedAmount = 90 ether;

        kkido.startPresale(PRESALE_DURATION);

        vm.deal(address(0xBEEF), buyAmount);
        vm.prank(address(0xBEEF));
        kkido.buyTokens{value: buyAmount}();

        kkido.setRaisedAmount(raisedAmount);
        kkido.finalizePresale();

        vm.prank(address(0xBEEF));
        kkido.claimRefund();

        assertEq(address(0xBEEF).balance, buyAmount, "Successful refund");
    }

    function testWithDrawIDO() public {
        uint256 raisedAmount = 110 ether;
        kkido.startPresale(PRESALE_DURATION);

        uint256 buyAmount = 0.1 ether;
        vm.deal(address(0xBEEF), buyAmount);
        vm.prank(address(0xBEEF));
        kkido.buyTokens{value: buyAmount}();

        kkido.setRaisedAmount(raisedAmount);
        kkido.finalizePresale();

        assertTrue(kkido.presaleFinalized(), "Presale should be finalized");

        vm.prank(owner);
        kkido.withdraw();

        assertEq(address(kkido).balance, 0, "IDO contract balance should be 0");
        assertEq(
            address(owner).balance,
            raisedAmount,
            "Owner should receive the raised funds"
        );
    }

    receive() external payable {}
}
