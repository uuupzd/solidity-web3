// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

error Unauthorized();

contract OwnerUponly {
    address public immutable owner;
    uint public count;

    constructor() {
        owner = msg.sender;
    }

    function increment() external {
        if (msg.sender != owner) {
            revert Unauthorized();
        }
        count++;
    }
}
