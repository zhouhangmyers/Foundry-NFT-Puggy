// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {console} from "forge-std/console.sol";

contract DeployMoodNft is Script {
    MoodNft public moodNft;

    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./image/sad.svg");
        string memory happySvg = vm.readFile("./image/happy.svg");
        vm.startBroadcast();
        (moodNft) = new MoodNft(svgToImageUri(sadSvg), svgToImageUri(happySvg));
        vm.stopBroadcast();
        return moodNft;
    }

    function svgToImageUri(string memory svg) public pure returns (string memory) {
        string memory base64 = Base64.encode(bytes(svg));
        return string(abi.encodePacked("data:image/svg+xml;base64,", base64));
    }
}
