// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract InscriptionTokenV1 is ERC20 {
    uint public totalSupplyCap;
    uint public perMint;
    uint public totalPerMint;
    address public tokenAddress;

    constructor(
        string memory _name,
        string memory _symbol,
        uint _totalSupply,
        uint _perMint,
        address _tokenAddress
    ) ERC20(_name, _symbol) {
        totalSupplyCap = _totalSupply;
        perMint = _perMint;
        tokenAddress = _tokenAddress;

        // 在初始化时铸造初始供应量
        _mint(_tokenAddress, _totalSupply);
    }

    function mint(address to) public {
        require(msg.sender == tokenAddress, "Only factory can mint");
        require(
            perMint + totalPerMint <= totalSupplyCap,
            "Exceeds total supply cap"
        );

        totalPerMint += perMint;
        _mint(to, perMint);
    }
}
