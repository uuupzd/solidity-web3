// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "forge-std/Test.sol";
import "../src/BaseERC20V2.sol";
import "../src/KKNFT.sol";
import "../src/NFTMarket.sol";

contract NFTMarketTest is Test {
    BaseERC20 public token;
    KKNFT public nft;
    NFTMarket public market;

    address[] public allowedTokens;

    address seller = address(0xC53a1D30470d60Eb8357caF15076B303C8583c54);
    address buyer = address(0x9B9453FA91634c0305789708A135A0e42c23eF0A);

    function setUp() public {
        token = new BaseERC20();
        nft = new KKNFT(seller);
        allowedTokens.push(address(token));
        market = new NFTMarket(allowedTokens);

        //mint nft to seller
        vm.startPrank(seller);
        nft.safeMint(seller, "token-url");
        nft.approve(address(market), 0);
        vm.stopPrank();
    }

    // Test case: List NFT successfully
    function testListNFT() public {
        vm.prank(seller);
        market.list(address(nft), 0, 100);
        (address listedSeller, uint price, bool isListed) = market.listings(
            address(nft),
            0
        );
        assertEq(listedSeller, seller);
        assertEq(price, 100);
        assertEq(isListed, true);
    }

    // Test case: List NFT without ownership
    function testListNFTWithoutOwnership() public {
        vm.expectRevert("Not the NFT owner");
        vm.prank(buyer);
        market.list(address(nft), 0, 100);
    }

    // Test case Buy NFT successfully
    function testBuyNFT() public {
        vm.prank(seller);
        market.list(address(nft), 0, 100);

        token.transfer(buyer, 100);
        vm.startPrank(buyer);
        token.approve(address(market), 100);
        market.buyNFT(address(nft), 0, address(token));

        assertEq(nft.ownerOf(0), buyer);
        (address listedSeller, , bool isListed) = market.listings(
            address(nft),
            0
        );
        assertEq(listedSeller, address(0));
        assertTrue(!isListed);
    }

    // Test case: Buy own nft
    function testBuyOwnNFT() public {
        vm.prank(seller);
        market.list(address(nft), 0, 100);

        token.transfer(seller, 100);
        vm.startPrank(seller);
        token.approve(address(market), 100);

        vm.expectRevert("Cannot buy your own NFT");
        market.buyNFT(address(nft), 0, address(token));
    }

    // Test case: Attempt to buy already sold NFT
    function testBuyAlreadySoldNFT() public {
        vm.prank(seller);
        market.list(address(nft), 0, 100);

        token.transfer(buyer, 100);
        vm.startPrank(buyer);
        token.approve(address(market), 100);
        market.buyNFT(address(nft), 0, address(token));

        vm.expectRevert("NFT not listed for sale");
        market.buyNFT(address(nft), 0, address(token));
    }

    // Test case: Test various token amounts for listing
    function testFuzzRandomPriceListtings(uint randomPrice) public {
        vm.prank(seller);
        vm.assume(randomPrice >= 1 && randomPrice <= 100);
        market.list(address(nft), 0, randomPrice);
    }

    // Test case: Buy NFT with insufficient payment
    function testBuyNFTWithInsufficientPayment() public {
        vm.prank(seller);
        market.list(address(nft), 0, 100);

        token.transfer(buyer, 50);
        vm.startPrank(buyer);
        token.approve(address(market), 50);

        vm.expectRevert("Insufficient token balance");
        market.buyNFT(address(nft), 0, address(token));
    }

    // Test case: Buy NFT with excessive payment

    function testBuyNFTWithExcessivePayment() public {
        vm.prank(seller);
        market.list(address(nft), 0, 100);

        token.transfer(buyer, 200);
        vm.startPrank(buyer);
        token.approve(address(market), 200);

        market.buyNFT(address(nft), 0, address(token));

        assertEq(nft.ownerOf(0), buyer);
        (address listedSeller, , bool isListed) = market.listings(
            address(nft),
            0
        );
        assertEq(listedSeller, address(0));
        assertTrue(!isListed);
    }

    // Test case: Check market has no token balance after sales
    function testMarketTokenBalanceIsZero() public {
        vm.prank(seller);
        market.list(address(nft), 0, 100);

        token.transfer(buyer, 100);
        vm.startPrank(buyer);
        token.approve(address(market), 100);

        market.buyNFT(address(nft), 0, address(token));

        uint marketBalance = token.balanceOf(address(market));
        assertEq(marketBalance,0);
    }
}
