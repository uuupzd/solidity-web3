// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.2;

contract FistConctract{

    uint public counter;

    //创建get函数
    function get() public view returns(uint x){
        return counter;
    }

    //创建add函数
    function add(uint x) public{
        counter += x;
    }

}
