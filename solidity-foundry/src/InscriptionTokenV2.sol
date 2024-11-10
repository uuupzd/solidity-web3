// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract InscriptionTokenV2 is Initializable, ERC20Upgradeable {
    uint public totalSupplyCap;
    uint public perMint;
    uint public totalPerMint;
    address public tokenAddress;

    function initialize(
        string memory _name,
        string memory _symbol,
        uint _totalSupplyCap,
        uint _perMint,
        address _tokenAddress
    ) external initializer {
        __ERC20_init(_name, _symbol);
        totalSupplyCap = _totalSupplyCap;
        perMint = _perMint;
        tokenAddress = _tokenAddress;
    }

    function mint(address to) external {
        require(msg.sender == tokenAddress, "Only factory can mint");
        require(
            perMint + totalPerMint <= totalSupplyCap,
            "Exceeds total supply cap"
        );

        totalPerMint += perMint;
        _mint(to, perMint);
    }
}
