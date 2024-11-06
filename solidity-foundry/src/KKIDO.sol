// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract KKIDO {
    address public owner;
    IERC20 public token;
    uint256 public presalePrice = 0.0001 ether;
    uint256 public totalSupply = 1_000_000 * 10 ** 18;
    uint256 public minPurchase = 0.01 ether;
    uint256 public maxPurchase = 0.1 ether;
    uint256 public fundingGoal = 100 ether;
    uint256 public maxFunding = 200 ether;
    uint256 public raisedAmount;
    uint256 public startTime;
    uint256 public endTime;

    mapping(address => uint) public contributions;
    bool public presaleActive = false;
    bool public presaleFinalized = false;

    event PresaleStarted(uint startTime, uint endTime);
    event TokensPurchased(address indexed buyer, uint amount);
    event PresaleFinalized(bool successful);

    modifier onlyWhileOpen() {
        require(presaleActive, "Presale is not active");
        require(
            block.timestamp >= startTime && block.timestamp <= endTime,
            "Presale is not ongoing"
        );
        _;
    }

    modifier onlyWhenFinalized() {
        require(presaleFinalized, "Presale is not finalized");
        _;
    }
    modifier onlyOwner() {
        require(owner == msg.sender, "is not the owner");
        _;
    }
    constructor(IERC20 _token) {
        owner = msg.sender;
        token = _token;
    }

    function startPresale(uint duration) external onlyOwner {
        require(!presaleActive, "Presale already active");
        startTime = block.timestamp;
        endTime = startTime + duration;
        presaleActive = true;
        emit PresaleStarted(startTime, endTime);
    }

    function buyTokens() external payable onlyWhileOpen {
        require(
            msg.value >= minPurchase && msg.value <= maxPurchase,
            "Invalid purchase amount"
        );
        require(raisedAmount + msg.value <= maxFunding, "Exceeds max funding");

        contributions[msg.sender] += msg.value;
        raisedAmount += msg.value;

        emit TokensPurchased(msg.sender, msg.value);
    }

    function finalizePresale() external onlyOwner {
        require(presaleActive, "Presale is not active");
        presaleActive = false;
        presaleFinalized = true;

        if (raisedAmount >= fundingGoal) {
            token.transfer(owner, totalSupply);
            emit PresaleFinalized(true);
        } else {
            emit PresaleFinalized(false);
        }
    }

    function claimRefund() external onlyWhenFinalized {
        require(
            raisedAmount < fundingGoal,
            "Presale failed, refunds available"
        );

        uint contribution = contributions[msg.sender];
        require(contribution > 0, "No contribution to refund");

        contributions[msg.sender] = 0;
        payable(msg.sender).transfer(contribution);
    }

    function withdraw() external onlyWhenFinalized {
        require(raisedAmount >= fundingGoal, "Funding goal not reached");

        payable(owner).transfer(address(this).balance);
    }
    //方便测试给 raisedAmount 状态变量赋值
    function setRaisedAmount(uint256 amount) external onlyOwner {
        raisedAmount = amount;
    }
}
