// SPDX-License-Identifier: MIT
pragma solidity 0.8.36;

import {Script, console2} from "forge-std/Script.sol";
import {ClassToken} from "../src/ClassToken.sol";
import {ClassVesting} from "../src/ClassVesting.sol";

contract DeployClassVesting is Script {
    uint256 constant CLIFF = 1_790_186_400;
    uint256 constant END = 1_790_272_800;

    function run() external {
        address[] memory beneficiaries = new address[](7);

        beneficiaries[0] = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        beneficiaries[1] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        beneficiaries[2] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
        beneficiaries[3] = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
        beneficiaries[4] = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65;
        beneficiaries[5] = 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc;
        beneficiaries[6] = 0x976EA74026E726554dB657fA54763abd0C3a0aa9;

        vm.startBroadcast();

        ClassToken token = new ClassToken();

        ClassVesting vesting = new ClassVesting(
            address(token),
            beneficiaries,
            CLIFF,
            END
        );

        token.transfer(address(vesting), 7_000);

        vm.stopBroadcast();

        console2.log("Token:", address(token));
        console2.log("Vesting:", address(vesting));
        console2.log("Vesting token balance:", token.balanceOf(address(vesting)));
    }
}