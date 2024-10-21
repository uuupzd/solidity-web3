// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./BaseERC20.sol";

//部署账号：0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2
//购买账号：0x617F2E2fD72FD9D5503197092aC168c91465E7f2

contract NFTMarket {
    //用于描述合约状态
    struct Listing {
        address seller;
        uint256 price;
        bool isListed;
    }

    mapping(address => mapping(uint256 => Listing)) public listings;
    mapping(address => bool) public allowedTokens;

    event Listed(
        address indexed nftContract,
        uint256 indexed tokenId,
        address seller,
        uint256 price
    );
    event Sold(
        address indexed nftContract,
        uint256 indexed tokenId,
        address buyer,
        address seller,
        uint256 price
    );

    //用于指定交易NFT的ERC20Token
    constructor(address[] memory _allowedTokens) {
        for (uint256 i = 0; i < _allowedTokens.length; i++) {
            allowedTokens[_allowedTokens[i]] = true;
        }
    }

    //上架NFT并设置价格
    function list(
        address nftContract,
        uint256 tokenId,
        uint256 price
    ) external {
        IERC721 nft = IERC721(nftContract);
        require(nft.ownerOf(tokenId) == msg.sender, "Not the NFT owner");
        require(price > 0, "Price must be greater than zero");
        require(
            nft.getApproved(tokenId) == address(this),
            "Market not approved"
        );

        listings[nftContract][tokenId] = Listing({
            seller: msg.sender,
            price: price,
            isListed: true
        });
        emit Listed(nftContract, tokenId, msg.sender, price);
    }

    //授权购买NFT
    function buyNFT(
        address nftContract,
        uint256 tokenId,
        address tokenAddress
    ) external {
        Listing memory listing = listings[nftContract][tokenId];
        require(listing.isListed, "NFT not listed for sale");
        require(
            allowedTokens[tokenAddress],
            "Token not allowed for transactions"
        );

        IERC20 token = IERC20(tokenAddress);
        require(
            token.balanceOf(msg.sender) >= listing.price,
            "Insufficient token balance"
        );
        //转账给NFT持有者
        token.transferFrom(msg.sender, listing.seller, listing.price);
        //NFT持有者将NFT转让给买家
        IERC721(nftContract).safeTransferFrom(
            listing.seller,
            msg.sender,
            tokenId
        );
        //下架已经销售的NFT
        delete listings[nftContract][tokenId];

        emit Sold(
            nftContract,
            tokenId,
            msg.sender,
            listing.seller,
            listing.price
        );
    }

    //tokensReceived中实现NFT购买功能
    function tokensReceived(
        address sender,
        uint256 amount,
        address nftContract,
        uint256 tokenId
    ) external {
        require(
            allowedTokens[msg.sender],
            "Token not allowed for transactions"
        );

        Listing memory listing = listings[nftContract][tokenId];
        require(listing.isListed, "NFT not listed for sale");
        require(amount >= listing.price, "Insufficient payment");

        // 执行转账给卖家
        IERC20(msg.sender).transfer(listing.seller, listing.price);
        // 转让 NFT
        IERC721(nftContract).safeTransferFrom(listing.seller, sender, tokenId);

        // 下架 NFT
        delete listings[nftContract][tokenId];

        emit Sold(nftContract, tokenId, sender, listing.seller, listing.price);
    }
}
