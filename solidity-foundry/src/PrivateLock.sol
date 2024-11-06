// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

//合约部署地址：https://sepolia.etherscan.io/address/0x21881f38542e30c313b9c5c8e2f8fb4c6abfcbd5
contract PrivateLock {
    struct LockInfo {
        address user;
        uint64 startTime;
        uint256 amount;
    }

    LockInfo[] private _locks;

    constructor() {
        for (uint256 i = 0; i < 11; i++) {
            _locks.push(
                LockInfo(
                    address(uint160(i + 1)),
                    uint64(block.timestamp * 2 - i),
                    1e18 * (i + 1)
                )
            );
        }
    }

    function getLocks() public view returns(LockInfo[] memory) {
        return _locks;
        
    }
}
