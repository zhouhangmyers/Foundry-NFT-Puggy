//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "src/BasicNft.sol";

contract DeployBasicNft is Script {
    BasicNft public basicNft;

    function run() external returns (BasicNft) {
        (basicNft) = deployBasicNft();
        return basicNft;
    }

    function deployBasicNft() public returns (BasicNft) {
        vm.startBroadcast();
        basicNft = new BasicNft();
        vm.stopBroadcast();
        return basicNft;
    }
}
