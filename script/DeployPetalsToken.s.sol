// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {PetalsToken} from "src/PetalsToken.sol";

contract DeployPetalsToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;

    function run() external returns (PetalsToken) {
        vm.startBroadcast();
        PetalsToken ptt = new PetalsToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return ptt;
    }
}
