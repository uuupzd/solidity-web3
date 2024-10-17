// SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./BaseERC20.sol";
import "./TokenBank.sol";

contract TokenBankV2 is TokenBank{

    //构造函数继承父合约
    constructor(BaseERC20 _token) TokenBank(_token){}

    //实现tokensReceived方法，用于处理trasferWithCallBack的存款
    function tokensReceived(address _from,uint _value) external {
        require(msg.sender == address(token),"Only the token contract can call this function");

        deposits[_from] += _value;
        emit Deposited(_from, _value);
    }

    //使用transferWithCallBack存入
    function depositWithCallback(uint _value) public {
        require(_value > 0, "Deposit amount must be greater than 0");
        token.transferWithCallback(address(this), _value);
    }

}