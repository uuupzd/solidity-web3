// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./Bank2.sol";

//0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 5 eth

contract BigBank is Bank2 {
    modifier minDeposit() {
        require(msg.value >= 0.001 ether, "Deposit must be >= 0.001 ETH");
        _;
    }

    //覆盖Bank合约中的receive函数
    receive() external payable override minDeposit {
        deposits[msg.sender] += msg.value;
        updateDepositors(msg.sender, deposits[msg.sender]);
    }

    //转移管理员权限
    function transferAdmin(address newAdmin) public {
        require(msg.sender == admin, "Only admin can transfer admin role");
        require(newAdmin != address(0), "New admin cannot be zero address");
        admin = newAdmin;
    }
}
