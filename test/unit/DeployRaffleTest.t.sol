// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {AddConsumer, CreateSubscription, FundSubscription} from "../../script/Interactions.s.sol";
import {Test, console2} from "forge-std/Test.sol";
import {Raffle} from "../../src/Raffle.sol";
import {Script} from "forge-std/Script.sol";

contract DeployRaffleTest is Test {
    DeployRaffle deployRaffle;
    Raffle raffle;
    HelperConfig helperConfig;

    uint256 subscriptionId;
    address vrfCoordinatorV2_5;
    address account;
    address link;

    address public PLAYER = makeAddr("player");

    function setUp() external {
        DeployRaffle deployer = new DeployRaffle();
        (raffle, helperConfig) = deployer.run();

        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        subscriptionId = config.subscriptionId;
        vrfCoordinatorV2_5 = config.vrfCoordinatorV2_5;
    }

    function testDeployRaffle() public {
        assert(address(raffle) != address(0));
        console2.log("This is the raffle contract address:", address(raffle));
    }

    function testCreateSubscription() public {
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        console2.log("Retrieved config values:");
        console2.log("subscriptionId:", config.subscriptionId);
        console2.log("vrfCoordinatorV2_5:", config.vrfCoordinatorV2_5);
        console2.log("account:", config.account);

        if (config.subscriptionId == 0) {
            CreateSubscription createSubscription = new CreateSubscription();
            console2.log("Creating subscription...");

            (
                config.subscriptionId,
                config.vrfCoordinatorV2_5
            ) = createSubscription.createSubscription(
                config.vrfCoordinatorV2_5,
                config.account
            );

            assert(config.subscriptionId != 0);
            console2.log("Subscription created successfully");
        }
    }

    function testFundSubscription() public {
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();

        if (config.subscriptionId == 0) {
            FundSubscription fundSubscription = new FundSubscription();
            fundSubscription.fundSubscription(
                config.vrfCoordinatorV2_5,
                config.subscriptionId,
                config.link,
                config.account
            );
            console2.log("Subscription ID has been funded successfully");
        }
    }

    function testAddConsumer() public {
        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        AddConsumer addConsumer = new AddConsumer();
        addConsumer.addConsumer(
            address(raffle),
            config.vrfCoordinatorV2_5,
            config.subscriptionId,
            config.account
        );
        console2.log("Raffle contract added as consumer successfully");
    }
}
