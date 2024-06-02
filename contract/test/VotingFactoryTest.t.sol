// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VotingFactory.sol";
import "../src/VotingToken.sol";

contract VotingFactoryTest is Test {
    VotingToken votingToken;
    VotingBaseFactory votingFactory;
    address owner = address(1);
    address user1 = address(2);
    address user2 = address(3);
    address dataFeedAddress = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

    function setUp() public {
        votingToken = new VotingToken();
        votingFactory = new VotingBaseFactory(votingToken, dataFeedAddress);
    }

    function testCreateCampaign() public {
        // 用户1创建一个新的 VotingBase 实例
        vm.startPrank(user1);
        votingFactory.createCampaign();
        vm.stopPrank();

        // 验证 newCampaign 是否正确添加到 allCampaigns 数组中
        address[] memory campaigns = votingFactory.getAllCampaigns();
        assertEq(campaigns.length, 1, "There should be one campaign created");
        assertEq(campaigns[0] != address(0), true, "Campaign address should be valid");

        // 验证新创建的 VotingBase 实例的所有者是否为 user1
        VotingBase newCampaign = VotingBase(payable(campaigns[0])); // 使用 payable 类型转换
        assertEq(newCampaign.owner(), user1, "The owner of the new campaign should be user1");
    }

    function testMultipleCampaignCreations() public {
        // 用户1创建第一个 VotingBase 实例
        vm.startPrank(user1);
        votingFactory.createCampaign();
        vm.stopPrank();

        // 用户2创建第二个 VotingBase 实例
        vm.startPrank(user2);
        votingFactory.createCampaign();
        vm.stopPrank();

        // 验证 newCampaign 是否正确添加到 allCampaigns 数组中
        address[] memory campaigns = votingFactory.getAllCampaigns();
        assertEq(campaigns.length, 2, "There should be two campaigns created");

        // 验证第一个 VotingBase 实例的所有者是否为 user1
        VotingBase campaign1 = VotingBase(payable(campaigns[0])); // 使用 payable 类型转换
        assertEq(campaign1.owner(), user1, "The owner of the first campaign should be user1");

        // 验证第二个 VotingBase 实例的所有者是否为 user2
        VotingBase campaign2 = VotingBase(payable(campaigns[1])); // 使用 payable 类型转换
        assertEq(campaign2.owner(), user2, "The owner of the second campaign should be user2");


    }

    function testMember() public {
        // 用户1创建第一个 VotingBase 实例
        vm.startPrank(user1);
        votingFactory.createCampaign();
        vm.stopPrank();

        // 用户2创建第二个 VotingBase 实例
        vm.startPrank(user2);
        votingFactory.createCampaign();
        vm.stopPrank();

        // 验证 newCampaign 是否正确添加到 allCampaigns 数组中
        address[] memory campaigns = votingFactory.getAllCampaigns();
        assertEq(campaigns.length, 2, "There should be two campaigns created");

        // 验证第一个 VotingBase 实例的所有者是否为 user1
        VotingBase campaign1 = VotingBase(payable(campaigns[0])); // 使用 payable 类型转换
        assertEq(campaign1.owner(), user1, "The owner of the first campaign should be user1");

        // 验证第一个 VotingBase 实例的 initialOwner 是否被添加为成员
        assertTrue(campaign1.isMember(user1), "User1 should be a member of the first campaign");

        // 验证第二个 VotingBase 实例的所有者是否为 user2
        VotingBase campaign2 = VotingBase(payable(campaigns[1])); // 使用 payable 类型转换
        assertEq(campaign2.owner(), user2, "The owner of the second campaign should be user2");

        // 验证第二个 VotingBase 实例的 initialOwner 是否被添加为成员
        assertTrue(campaign2.isMember(user2), "User2 should be a member of the second campaign");


        // 用户1创建一个 Proposal
        vm.startPrank(user1);
        campaign1.createProposal(
            "Proposal 1",
            100,
            1717200000000,
            1717372800000,
            2,
            0xdf95df1ae2e4FD7DB0f0b5afde35b13f37f7d156,
            0
        );
        vm.stopPrank();

        // 用户2创建一个 Proposal
        vm.startPrank(user2);
        campaign2.createProposal(
            "Proposal 2",
            100,
            1717200000000,
            1717372800000,
            2,
            0xdf95df1ae2e4FD7DB0f0b5afde35b13f37f7d156,
            0
        );
        vm.stopPrank();
    }



}
