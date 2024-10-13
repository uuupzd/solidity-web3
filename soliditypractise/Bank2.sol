// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

// 导入 IBank 接口
import "./IBank.sol";

//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 1 eth
//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 2 eth
//0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB 3 eth
//0x617F2E2fD72FD9D5503197092aC168c91465E7f2 4 eth



contract Bank2 is IBank {
    address public admin;
    mapping(address => uint256) deposits;
    struct TopDepositor {
        address addr;
        uint256 balance;
    }
    TopDepositor[3] public topDepositors;

    constructor() {
        admin = msg.sender;
    }

    //接收eth
    receive() external payable virtual{
        require(msg.value > 0, "You must send some ETH");
        deposits[msg.sender] += msg.value;
        updateDepositors(msg.sender, deposits[msg.sender]);
    }

    //更新前3存款地址
    function updateDepositors(address depositor, uint256 amount) internal {
        for (uint256 i = 0; i < topDepositors.length; i++) {
            if (topDepositors[i].addr == depositor) {
                topDepositors[i].balance = amount;
                break;
            }
        }

        for (uint256 i = 0; i < topDepositors.length; i++) {
            if (amount > topDepositors[i].balance) {
                for (uint256 j = topDepositors.length - 1; j > i; j--) {
                    topDepositors[j] = topDepositors[j - 1];
                }
                topDepositors[i] = TopDepositor(depositor, amount);
                break;
            }
        }
    }

    // 获取当前合约的余额
    function getContractBalance() external view override returns (uint256) {
        return address(this).balance;
    }

    //获取前3地址
    function getTopDepositors() external view returns (TopDepositor[3] memory) {
        return topDepositors;
    }

    //提取eth
    function withDraw() external override {
        require(msg.sender == admin, "Only admin can withDraw");
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "Insufficient funds in the contract");
        payable(admin).transfer(contractBalance);
    }
}
