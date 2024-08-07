// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Test, console2} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";

contract HelperConfigTest is Test {
    HelperConfig helperConfig;
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ETH_MAINNET_CHAIN_ID = 1;
    uint256 public constant LOCAL_CHAIN_ID = 31337;

    function setUp() public {
        helperConfig = new HelperConfig();
    }

    function testLocalChain() public {
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        if (block.chainid == LOCAL_CHAIN_ID) {
            assertTrue(config.subscriptionId != 0);
            assertTrue(config.vrfCoordinatorV2_5 != address(0));
            assertTrue(config.account != address(0));
            assertTrue(config.automationUpdateInterval == 30);
            assertTrue(config.raffleEntranceFee == 0.01 ether);
            assertTrue(config.callbackGasLimit == 500000);
            assertTrue(config.link != address(0));
        }
    }

    function testEthSepoliaChain() public {
        if (block.chainid == ETH_SEPOLIA_CHAIN_ID) {
            HelperConfig.NetworkConfig memory sepoliaConfig = helperConfig
                .getConfigByChainId(ETH_SEPOLIA_CHAIN_ID);
            assertTrue(sepoliaConfig.subscriptionId == 0);
            assertTrue(sepoliaConfig.vrfCoordinatorV2_5 != address(0));
            assertTrue(sepoliaConfig.account != address(0));
            assertTrue(sepoliaConfig.automationUpdateInterval == 30);
            assertTrue(sepoliaConfig.raffleEntranceFee == 0.01 ether);
            assertTrue(sepoliaConfig.callbackGasLimit == 500000);
            assertTrue(sepoliaConfig.link != address(0));
        }
    }

    function testEthMainnetChain() public {
        if (block.chainid == ETH_MAINNET_CHAIN_ID) {
            HelperConfig.NetworkConfig memory mainnetConfig = helperConfig
                .getConfigByChainId(ETH_MAINNET_CHAIN_ID);
            assertTrue(mainnetConfig.subscriptionId == 0);
            assertTrue(mainnetConfig.vrfCoordinatorV2_5 != address(0));
            assertTrue(mainnetConfig.account != address(0));
            assertTrue(mainnetConfig.automationUpdateInterval == 30);
            assertTrue(mainnetConfig.raffleEntranceFee == 0.01 ether);
            assertTrue(mainnetConfig.callbackGasLimit == 500000);
            assertTrue(mainnetConfig.link != address(0));
        }
    }
}
