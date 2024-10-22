 
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

interface IBank {

    // 获取合约地址余额接口函数
    function getContractBalance() external view returns (uint256);

    // 提取ETH接口函数
    function withDraw() external;
}
