// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./IBank.sol";

contract Admin{
    address public owner;

    //定义构造函数，将合约部署者设置为owner;
    constructor(){
        owner = msg.sender;
    }

    //允许owner调用modifier
    modifier OnlyOwner(){
        require(msg.sender == owner,"Only owner can call this function");
        _;
    }

    //admin提取IBank合约ETH
    function adminWithDraw(IBank bank) public OnlyOwner {
        bank.withDraw();
        //合约中的资金转移到admin合约
        payable(owner).transfer(bank.getContractBalance());
    }

    //获取admin合约的余额
    function getAdminBalance() public view returns(uint) {
        return address(this).balance;
    }
}