// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VotingFactory.sol";
import "../src/VotingToken.sol";

contract VotingFinalTest is Test {
    VotingToken votingToken;
    VotingBaseFactory votingFactory;
    address owner = address(1);
    address user1 = address(2);
    address user2 = address(3);
    address member1 = address(4);
    address member2 = address(5);
    address dataFeedAddress = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;

    function setUp() public {
        votingToken = new VotingToken();
        votingFactory = new VotingBaseFactory(votingToken, dataFeedAddress);
    }

    function testCreateCampaignAndAddMembers() public {
        // 用户1创建一个新的 VotingBase 实例
        vm.startPrank(user1);
        votingFactory.createCampaign();
        address[] memory campaigns = votingFactory.getAllCampaigns();
        VotingBase votingBase = VotingBase(payable(campaigns[0]));
        vm.stopPrank();

        // 用户1添加成员
        vm.startPrank(user1);
        votingBase.addMember(member1);
        votingBase.addMember(member2);
        vm.stopPrank();

        // 验证成员添加成功
        assertTrue(votingBase.isMember(member1), "Member1 should be added as a member");
        assertTrue(votingBase.isMember(member2), "Member2 should be added as a member");
    }

    function testVotingProcess() public {
        // 用户1创建一个新的 VotingBase 实例
        vm.startPrank(user1);
        votingFactory.createCampaign();
        address[] memory campaigns = votingFactory.getAllCampaigns();
        VotingBase votingBase = VotingBase(payable(campaigns[0]));
        vm.stopPrank();

        // 用户1添加成员
        vm.startPrank(user1);
        votingBase.addMember(member1);
        votingBase.addMember(member2);
        vm.stopPrank();

        // 成员1创建提案
        vm.startPrank(member1);
        votingBase.createProposal(
            "Improve Voting System",
            100, //targetAmount
            1653897600, //beginTime
            16999999999, //endTime
            7 days, //duration
            address(6), // beneficiary
            50
        );
        vm.stopPrank();

        // 成员投票
        vm.startPrank(member1);
        votingBase.vote(0, true); // member1 投支持票
        vm.stopPrank();

        vm.startPrank(member2);
        votingBase.vote(0, false); // member2 投反对票
        vm.stopPrank();

        // 获取提案信息并进行基本验证
        DataType.CampaignInfo memory proposal = votingBase.getProposal(0);
        assertEq(proposal.voteCount, 1); //一个赞成票
        assertEq(proposal.againstCount, 1); //一个反对票

        // 模拟时间流逝
        vm.warp(block.timestamp + 8 days);

        // 检查投票结果
        vm.startPrank(user1);
        votingBase.checkProposal(0);
        vm.stopPrank();

        // 断言：结果没有通过
        assertFalse(votingBase.checkPass(0));
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
}
