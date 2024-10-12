// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

contract Bnak {
    /**
    1.接收 ETH 存款：通过 receive() 函数或者直接转账到合约地址。
    2.记录存款信息：使用一个映射（mapping）来记录每个地址的存款金额。
    3.维护前3名存款：使用一个数组来维护前3名的地址。
    4.实现管理员提款：设置管理员权限，使得只有管理员能够提取合约中的所有 ETH。
    */

    address public admin;
    mapping(address => uint256) public addrBlances;
    address[] public topAddrBlances;
    uint256[3] public topAmounts;

    constructor() {
        //合约部署人员设置为管理员
        admin = msg.sender;
    }

    event addrBlance(address addrBlances, uint256 amount);
    event Withdraw(address admin, uint256 amount);

    //接收ETH并记录每个地址的存款
    receive() external payable {
        require(msg.value > 0, "You must send some ETH");

        addrBlances[msg.sender] += msg.value;
        updateAddrBlances(msg.sender, addrBlances[msg.sender]);

        emit addrBlance(msg.sender, msg.value);
    }

    //处理存款前3地址的排名
    function updateAddrBlances(address addr, uint256 amount) internal {
        for (uint256 i = 0; i < topAddrBlances.length; i++) {
            if (amount > topAmounts[i]) {
                //更新前3名存款
                for (uint256 j = topAddrBlances.length - 1; j > i; j--) {
                    topAmounts[j] = topAmounts[j - i];
                }
                topAddrBlances[i] = addr;
                topAmounts[i] = amount;
                return;
            }
        }
        //如果前3名没有满，直接添加
        if (topAddrBlances.length < 3) {
            topAddrBlances.push(addr);
            topAmounts[topAddrBlances.length - 1] = amount;
        }
    }

    //提取所有eth，只有管理员可以操作
    function withdraw() external {
        require(msg.sender == admin, "Only the admin can withdraw");
        uint256 contractBalance = address(this).balance;
        require(contractBalance > 0, "No funds to withdraw");

        //提取所有eth
        payable(admin).transfer(contractBalance);

        //触发提取eth事件
        emit Withdraw(admin, contractBalance);
    }

    //获取当前合约的ETH余额
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    //返回前3名存款余额的地址和余额
    function getTopAddrBlances()
        public
        view
        returns (address[] memory, uint256[3] memory)
    {
        return (topAddrBlances, topAmounts);
    }
}
