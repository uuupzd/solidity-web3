// SPDX-License-Identifier: MIT

pragma solidity ^0.8.5;

contract SolidityValueType{
    /*
    solidity类型可以分为三种
    1/值类型（Value）：包括布尔类型、整数类型、地址类型、定长字节数组、枚举等，这类变量赋值的时候直接传递数值
    2/引用类型（Reference Type）:包括数组和结构体、这类变量占空间大，赋值时候直接传递地址（指针）
    3/映射类型（Mapping Type）：存储键值对的数据结构，可以理解为hash表

    */

    //布尔类型，这个类型只有两个值，true&false
    //布尔值的运算符 &&(and) ||(or)  !(逻辑非) ==  !=
    // && || 运算符遵循短路规则，假如存在 f(x)||g(y)的表达式，如果f(x)是true，g(y)不会被计算，即使它和 f（x）的结果是相反的，
    //所谓短路规则 一般出现在逻辑与（&&）和逻辑非（||）中，单逻辑与（&&）的第一个条件为false时，就不会再去判断第二个条件，当逻辑非（||）的第一个条件为true时，就不会再去判断第二个条件，这就是短路规则



    bool _true = true;
    bool _fase = false;

    bool _bool1 = !_true;


    //整数类型
    //运算符包括：比较运算符和算数运算符
    //比较运算符： == != > < >= <= 
    //算数运算符：+ - * / % **

    //整数包括负数
    int public _int = -1;

    //正整数
    uint public _uint = 1;

    //256位正整数
    uint256 public _number = 202322;

    //地址类型，地址类型有两大类
    //普通地址 address 存储一个20字节的值，以太坊地址的大小
    //payable address 比普通地址多了 transfer 和 send 两个成员方法，用于接收转账
    
    address public _address = 0xDeFf00eBB5ab5688eb09eb2ab1E073A17e8F65e5;
    address payable public _address1 = payable(_address);

    uint256 public balance = _address1.balance;

    //定长字节数组，字节数组分为定长和不定长两种

    //定长字节数组，属于值类型，数组长度在声明之后不能改变，根据字节数组的长度分为bytes1, bytes8, bytes32等类型，定长字节数组最多存储32bytes数据，即bytes32
    //不定长字节数组，属于引用类型，数组长度在声明之后可以改变，包括bytes等

    //固定长度的字节数组
    bytes32 public _byte32 = "MiniSolidity";
    bytes1 public _byte1 = _byte32[1];

    //枚举类型 enum;
    //枚举类型是solidity中用户定义的数据类型，它主要用于为uint分配名称，使程序易读维护，使用名称来代替从0开始的uint;

    //用enum将uint 0 1 2 表示为buy Hold Sell
    enum ActionSet{Buy,Hold,Sell}

    ActionSet action = ActionSet.Buy;

}
