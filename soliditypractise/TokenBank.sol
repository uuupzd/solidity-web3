// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./BaseERC20.sol";

//0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB 部署地址
//0x4AE56F8B3fc7B78Fc36582033b8722E258f74A64 

contract TokenBank {
    BaseERC20 public token;

    mapping(address => uint256) deposits;

    //事件用于记录存入和提取
    event Deposited(address indexed user, uint256 amount);
    event WithDraw(address indexed user, uint256 amount);

    constructor(BaseERC20 _token) {
        token = _token;
    }


    //存入代币
    function deposit(uint256 amount) public {
        require(amount > 0, "Deposit amount must be greater than 0");

        token.transferFrom(msg.sender, address(this), amount);
        deposits[msg.sender] += amount;
        emit Deposited(msg.sender, amount);
    }

    //提取代币
    function Withdraw(uint  amount) public {
        require(amount > 0 ,"Withdraw amount must be greater than 0");
        require(deposits[msg.sender] >= amount,"Insufficient balance in TokenBank");

        deposits[msg.sender] -= amount;
        token.transfer(msg.sender, amount);
        emit WithDraw(msg.sender, amount);
    }
}
