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

    function testProposalCreation() public {
        vm.startPrank(member1);
        votingBase.createProposal("Improve Voting System");
        vm.stopPrank();

        VotingBase.Proposal memory proposal = votingBase.getProposal(0);
        assertEq(proposal.name, "Improve Voting System");
        assertEq(proposal.creator, member1);
    }

    function testVoting1() public {
        vm.startPrank(member1);
        votingBase.createProposal("Improve Voting System 1");
        vm.stopPrank();

        vm.startPrank(member1);
        votingBase.vote(0, true); // member1 投支持票
        vm.stopPrank();

        vm.startPrank(member2);
        votingBase.vote(0, false); // member2 投支持票
        vm.stopPrank();

        vm.startPrank(member3);
        votingBase.vote(0, false); // member3 投支持票
        vm.stopPrank();

        VotingBase.Proposal memory proposal = votingBase.getProposal(0);
        assertEq(proposal.voteCount, 1);
        assertFalse(votingBase.checkPass(0));
    }

    function testVoting2() public {
        vm.startPrank(member1);
        votingBase.createProposal("Improve Voting System 2");
        vm.stopPrank();

        vm.startPrank(member1);
        votingBase.vote(0, true); // member1 投支持票
        vm.stopPrank();

        vm.startPrank(member2);
        votingBase.vote(0, true); // member2 投支持票
        vm.stopPrank();

        vm.startPrank(member3);
        votingBase.vote(0, false); // member3 投支持票
        vm.stopPrank();

        VotingBase.Proposal memory proposal = votingBase.getProposal(0);
        assertEq(proposal.voteCount, 2);
        assertTrue(votingBase.checkPass(0));
    }
}
