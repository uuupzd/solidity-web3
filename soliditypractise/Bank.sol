// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

/**
    1. 编写一个接收ETH的合约
    2. 在合约中记录每个地址的存款余额
    3. 编写withDraw提取资金方法，仅管理员通过这个方法提起eth
    4. 用数组记录存款余额的前3名的地址

*/

//0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db 10
//0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db 100
//0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db 200
//0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db 400

contract Bank {
    address public admin;
    mapping(address => uint256) deposits;
    struct TopDepositor {
        address addr;
        uint256 balance;
    }
    TopDepositor[3] public topDepositors;

    //创建构造函数将合约部署者定义为admin
    constructor() {
        admin = msg.sender;
    }

    //接收eth函数
    receive() external payable {
        require(msg.value > 0, "You must send some ETH");
        deposits[msg.sender] += msg.value;
        updateDepositors(msg.sender, deposits[msg.sender]);
    }

    //更新前3名存款地址
    function updateDepositors(address depositor, uint256 amount) internal {
        for (uint256 i = 0; i < topDepositors.length; i++) {
            if (topDepositors[i].addr == depositor) {
                //如果用户已经在前3名中，更新其余额
                topDepositors[i].balance = amount;
                break;
            }
        }
        //检查是否将当前用户插入前3名
        for (uint256 i = 0; i < topDepositors.length; i++) {
            if (amount > topDepositors[i].balance) {
                //移动较小的用户信息，插入当前用户
                for (uint256 j = topDepositors.length - 1; j > i; j--) {
                    topDepositors[j] = topDepositors[j - 1];
                }
                topDepositors[i] = TopDepositor(depositor, amount);
                break;
            }
        }
    }

    //获取当前合约的余额
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    //获取前3地址
    function getTopDepositors() external view returns (TopDepositor[3] memory) {
        return topDepositors;
    }

    //admin用户提取所有的ETH
    function withDraw() external {
        require(msg.sender == admin, "Only admin can withDraw");
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "Insufficient funds in the contract");
        payable(admin).transfer(contractBalance);
    }
}
