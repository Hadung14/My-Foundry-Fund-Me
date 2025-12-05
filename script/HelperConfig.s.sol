//SPDX-License-Identifier: MIT

pragma solidity ^0.8.21;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {

    NetworkConfig public associatedNetworkConfig;

    struct NetworkConfig {
    address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {associatedNetworkConfig = getSepoliaConfig();} 
        else {associatedNetworkConfig = getAnvilConfig(); 
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
    NetworkConfig memory sepoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
    return sepoliaConfig;
    }

    function getAnvilConfig() public returns (NetworkConfig memory) {
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(8, 2000e8);
        vm.stopBroadcast();
        NetworkConfig memory anvilNetworkConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return anvilNetworkConfig;
    }

}