// SPDX-License-Identifier: MIT
pragma solidity >0.8.20;

contract StorageExample {
    uint8 public a = 11;
    uint256 b = 12;
    uint[2] c = [13, 14];

    struct Entry {
        uint id;
        uint value;
    }
    Entry d;
}
