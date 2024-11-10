// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./InscriptionTokenV1.sol";

contract FactoryContractV1 {
    event TokenDeployed(
        string name,
        string symbol,
        uint totalSupply,
        uint perMint,
        address indexed tokenAddress
    );

    function deployInscription(
        string memory name,
        string memory symbol,
        uint totalSupply,
        uint perMint
    ) public returns (address) {
        InscriptionTokenV1 newToken = new InscriptionTokenV1(
            name,
            symbol,
            totalSupply,
            perMint,
            address(this)
        );
        emit TokenDeployed(name, symbol, totalSupply, perMint, address(this));

        return address(newToken);
    }

    function mintInscription(address tokenAddr) public {
        InscriptionTokenV1 token = InscriptionTokenV1(tokenAddr);
        token.mint(msg.sender);
    }
}
