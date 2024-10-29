// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract Safe{
    receive() external payable{}

    function withDraw() external {
        payable(msg.sender).transfer(address(this).balance);
    }
}
