// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./InscriptionTokenV2.sol";

//https://sepolia.etherscan.io/address/0xf5a63f139275aa7a2a8b39ae2b0db81e2cec21f3#code
contract FactoryContractV2 is Initializable {
    using Clones for address;

    mapping(address => uint) public tokenPrices;

    address public insription;
    address public owner;

    event InsriptionDeployed(
        address indexed tokenAddress,
        uint totalSupply,
        uint price
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
    function initialize(address _owner) external initializer {
        owner = _owner;

        InscriptionTokenV2 token = new InscriptionTokenV2();
        insription = address(token);
    }

    function deployInscription(
        string memory name,
        string memory symbol,
        uint totalSupply,
        uint perMint,
        uint price
    ) public returns (address) {
        address token = insription.clone();
        InscriptionTokenV2(token).initialize(
            name,
            symbol,
            totalSupply,
            perMint,
            address(this)
        );

        tokenPrices[token] = price;

        emit InsriptionDeployed(token, totalSupply, price);

        return token;
    }

    function mintInscription(address tokenAddr) external payable {
        require(tokenPrices[tokenAddr] > 0, "Invalid token address");

        uint price = tokenPrices[tokenAddr];

        if (msg.value > price) {
            payable(msg.sender).transfer(msg.value - price);
        }

        InscriptionTokenV2(tokenAddr).mint(msg.sender);
    }

    function withDraw() external onlyOwner {
        uint balance = address(this).balance;
        require(balance > 0, "No ETH to withdraw");

        (bool success, ) = owner.call{value: balance}("");
        require(success, "WithDraw faild");
    }
}
