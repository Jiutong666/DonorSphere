// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VotingBase.sol";
import "../src/VotingToken.sol";

contract VotingBaseTest is Test {
    VotingBase votingBase;
    VotingToken votingToken;
    address owner = address(1);
    address member1 = address(2);
    address member2 = address(3);
    address member3 = address(4);

    function setUp() public {
        votingToken = new VotingToken();
        votingBase = new VotingBase(votingToken);

        // 确保调用 transferOwnership 的是当前的所有者。
        vm.startPrank(address(this)); // `address(this)` 表示当前测试合约的地址
        votingBase.transferOwnership(owner);
        vm.stopPrank();

        vm.startPrank(owner);
        votingBase.addMember(member1);
        votingBase.addMember(member2);
        votingBase.addMember(member3);
        vm.stopPrank();
    }

    /**
     * 测试创建和删除成员
     */
    function testAddAndRemoveMember() public {
        address member5 = address(5); // 定义一个新的成员地址

        // 添加成员4
        vm.startPrank(owner);
        votingBase.addMember(member5);
        assertTrue(
            votingBase.isMember(member5),
            "Member4 should be added as a member"
        );

        // 确认已添加
        bool isMember = votingBase.isMember(member5);
        assertEq(isMember, true, "Member4 should be recognized as a member");

        // 尝试重复添加相同成员应触发错误
        vm.expectRevert("Member already exists");
        votingBase.addMember(member5);

        // 移除成员4
        votingBase.removeMember(member5);
        assertEq(
            votingBase.isMember(member5),
            false,
            "Member4 should no longer be a member"
        );

        // 尝试移除已经被移除的成员应触发错误
        vm.expectRevert("Address is not a member");
        votingBase.removeMember(member5);

        vm.stopPrank();
    }

    /**
     * 测试创建活动
     */
    function testProposalCreation() public {
        vm.startPrank(member1);
        votingBase.createProposal(
            "Improve Voting System",
            100, //targetAmount
            1653897600, //beginTime
            16999999999 //endTime
        );
        vm.stopPrank();

        DataType.CampaignInfo memory proposal = votingBase.getProposal(0);
        assertEq(proposal.name, "Improve Voting System");
        assertEq(proposal.creator, member1);
        assertEq(proposal.targetAmount, 100);
        assertEq(proposal.beginTime, 1653897600);
        assertEq(proposal.endTime, 16999999999);
        assertEq(proposal.voteCount, 0);
        assertEq(proposal.againstCount, 0);
        assertFalse(proposal.passed);
        assertFalse(proposal.donationWithdrawn);
    }

    /**
     * 测试创建活动的时候分配Token
     */
    function testProposalCreationAndTokenDistribution() public {
        // 设置初始条件
        uint256 initialMemberTokens = votingBase.getTokenBalance(member1);
        uint256 initialVoteTokens = votingBase.memberVoteToken(member1);

        // 模拟成员创建提案
        vm.startPrank(member1);
        votingBase.createProposal(
            "Improve Voting System777",
            100, //targetAmount
            1653897600, //beginTime
            16999999999 //endTime
        );
        vm.stopPrank();

        // 获取提案信息并进行基本验证
        DataType.CampaignInfo memory proposal = votingBase.getProposal(0);
        assertEq(proposal.name, "Improve Voting System777");

        // 验证代币是否被正确分配
        uint256 finalMemberTokens = votingBase.getTokenBalance(member1);
        uint256 finalVoteTokens = votingBase.memberVoteToken(member1);

        assertEq(
            finalMemberTokens,
            initialMemberTokens + 1 * 10 ** uint256(votingToken.decimals()),
            "Token balance should increase by 1 token"
        );
        assertEq(
            finalVoteTokens,
            initialVoteTokens + 1,
            "Vote token count should increase by 1"
        );
    }

    /**
     * 测试投票
     */
    function testVoting1() public {
        vm.startPrank(member1);
        votingBase.createProposal(
            "Improve Voting System 1",
            100,
            1653897600,
            16999999999
        );
        vm.stopPrank();

        vm.startPrank(member1);
        votingBase.vote(0, true); // member1 投支持票
        vm.stopPrank();

        vm.startPrank(member2);
        votingBase.vote(0, false); // member2 投反对票
        vm.stopPrank();

        vm.startPrank(member3);
        votingBase.vote(0, false); // member3 投反对票
        vm.stopPrank();

        DataType.CampaignInfo memory proposal = votingBase.getProposal(0);
        assertEq(proposal.voteCount, 1); //一个赞成票
        assertEq(proposal.againstCount, 2); //两个反对成票
        assertFalse(votingBase.checkPass(0)); //结果没通过
    }

    /**
     * 创建两个活动，对第二个活动投票
     */
    function testVoting2() public {
        vm.startPrank(member1);
        votingBase.createProposal(
            "Improve Voting System 2",
            100,
            1653897600,
            16999999999
        );

        votingBase.createProposal(
            "Improve Voting System 3",
            100,
            1653897600,
            16999999999
        );

        vm.stopPrank();

        vm.startPrank(member1);
        votingBase.vote(1, true); // member1 投支持票
        vm.stopPrank();

        vm.startPrank(member2);
        votingBase.vote(1, true); // member2 投支持票
        vm.stopPrank();

        vm.startPrank(member3);
        votingBase.vote(1, false); // member3 投反对票
        vm.stopPrank();

        DataType.CampaignInfo memory proposal = votingBase.getProposal(1);
        assertEq(proposal.voteCount, 2); //两个赞成票
        assertEq(proposal.againstCount, 1); //一个反对票
        assertTrue(votingBase.checkPass(1)); //结果通过

        //第一个活动
        assertFalse(votingBase.checkPass(0)); //结果通过
    }

    /**
     * 测试不能重复投票
     */
    function testAlreadyVoting() public {
        // 创建提案
        vm.startPrank(member1);
        votingBase.createProposal(
            "Improve Voting System",
            100,
            1653897600,
            16999999999
        );
        vm.stopPrank();

        // 投票
        vm.startPrank(member1);
        votingBase.vote(0, true); // member1 投支持票
        vm.stopPrank();

        // 尝试重复投票
        vm.startPrank(member1);
        vm.expectRevert("Already voted");
        votingBase.vote(0, true);
        vm.stopPrank();
    }

    /**
     * 测试投票后是否销毁了token
     */
    function testVotingAndTokenBurn() public {
        // 设置初始条件，确保用户有足够的代币
        vm.startPrank(member1);
        votingBase.createProposal(
            "Improve Voting System",
            100,
            1653897600,
            16999999999
        );
        vm.stopPrank();

        // 记录投票前的代币余额和总供应量
        uint256 initialBalance = votingBase.getTokenBalance(member1);
        uint256 initialTotalSupply = votingToken.totalSupply();

        // 投票操作
        vm.startPrank(member1);
        votingBase.vote(0, true); // member1 投支持票
        vm.stopPrank();

        // 记录投票后的代币余额和总供应量
        uint256 finalBalance = votingBase.getTokenBalance(member1);
        uint256 finalTotalSupply = votingToken.totalSupply();

        // 断言：检查代币余额减少
        assertEq(
            finalBalance,
            initialBalance - 1 * 10 ** uint256(votingToken.decimals()),
            "Token balance should decrease by 1 token"
        );

        // 断言：检查代币总供应量减少
        assertEq(
            finalTotalSupply,
            initialTotalSupply - 1 * 10 ** uint256(votingToken.decimals()),
            "Total supply should decrease by 1 token"
        );
    }
}
