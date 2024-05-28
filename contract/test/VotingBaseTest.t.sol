// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/VotingBase.sol";
import "../src/VotingToken.sol";
import "../src/core/PriceConverter.sol";

contract VotingBaseTest is Test {
    VotingToken votingToken;
    VotingBase votingBase;
    address owner = address(1);
    address member1 = address(2);
    address member2 = address(3);
    address member3 = address(4);
    address dataFeedAddress = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419; // Mock data feed address
    address public nonMember = address(6);
    address public beneficiary = address(7);
    PriceConverter price;

    uint256 ONE_USD;
    uint256 FIVE_USD;
    uint256 TEN_USD;
    uint256 constant MIN_DONATION_FIVE_USD = 5;
    uint256 constant TARGET_DONATION_USD = 50; // 50 usd

    function setUp() public {
        votingToken = new VotingToken();
        votingBase = new VotingBase(
            votingToken,
            dataFeedAddress,
            address(this)
        );
        price = new PriceConverter(dataFeedAddress);

        // 确保调用 transferOwnership 的是当前的所有者。
        vm.startPrank(address(this)); // `address(this)` 表示当前测试合约的地址
        votingBase.transferOwnership(owner);
        vm.stopPrank();

        vm.startPrank(owner);
        votingBase.addMember(member1);
        votingBase.addMember(member2);
        votingBase.addMember(member3);
        vm.stopPrank();

        ONE_USD = price.USD(1);
        FIVE_USD = price.USD(5);
        TEN_USD = price.USD(10);

        uint256 initialBalance = 10 ether;
        vm.deal(member1, initialBalance);
        vm.deal(member2, initialBalance);
        vm.deal(member3, initialBalance);
    }

    modifier createProposalAndPassed() {
        // 成员1创建提案
        vm.startPrank(member1);
        uint256 proposalId = votingBase.createProposal(
            "Improve Voting System",
            TARGET_DONATION_USD, //targetAmount(USD)
            1653897600, //beginTime 2022-05-30 16:00:00
            16999999999, //endTime 2508-09-16 14:13:19
            7 days, //duration
            beneficiary, // beneficiary
            MIN_DONATION_FIVE_USD
        );
        vm.stopPrank();

        // 成员投票
        vm.startPrank(member1);
        votingBase.vote(proposalId, true); // member1 投支持票
        vm.stopPrank();

        vm.startPrank(member2);
        votingBase.vote(proposalId, true); // member2 投支持票
        vm.stopPrank();

        // 模拟时间流逝
        vm.warp(block.timestamp + 8 days);

        // 检查投票结果
        vm.startPrank(member1);
        votingBase.checkProposal(proposalId);
        vm.stopPrank();
        _;
    }

    /**
     * 测试创建和删除成员
     */
    function testAddAndRemoveMember() public {
        address member5 = address(5); // 定义一个新的成员地址

        // 添加成员5
        vm.startPrank(owner);
        votingBase.addMember(member5);
        assertTrue(
            votingBase.isMember(member5),
            "Member5 should be added as a member"
        );

        // 确认已添加
        bool isMember = votingBase.isMember(member5);
        assertEq(isMember, true, "Member5 should be recognized as a member");

        // 尝试重复添加相同成员应触发错误
        vm.expectRevert("Member already exists");
        votingBase.addMember(member5);

        // 移除成员5
        votingBase.removeMember(member5);
        assertEq(
            votingBase.isMember(member5),
            false,
            "Member5 should no longer be a member"
        );

        // 尝试移除已经被移除的成员应触发错误
        vm.expectRevert("Address is not a member");
        votingBase.removeMember(member5);

        vm.stopPrank();
    }

    /**
     * 测试创建提案
     */
    function testProposalCreation() public {
        // 成员1创建提案
        vm.startPrank(member1);
        uint256 id = votingBase.createProposal(
            "Improve Voting System",
            100, //targetAmount(USD)
            1653897600, //beginTime
            16999999999, //endTime
            7 days, //duration
            address(5),
            MIN_DONATION_FIVE_USD
        );
        vm.stopPrank();

        // 获取提案信息并进行基本验证
        DataType.CampaignInfo memory proposal = votingBase.getProposal(id);
        assertEq(proposal.name, "Improve Voting System");
        assertEq(proposal.creator, member1);
        assertEq(proposal.targetAmount, price.USD(100));
        assertEq(proposal.beginTime, 1653897600);
        assertEq(proposal.endTime, 16999999999);
        assertEq(proposal.voteCount, 0);
        assertEq(proposal.againstCount, 0);
        assertFalse(proposal.passed);
        assertFalse(proposal.donationWithdrawn);
    }

    /**
     * 测试创建提案时分配Token
     */
    function testProposalCreationAndTokenDistribution() public {
        // 设置初始条件
        uint256 initialMemberTokens = votingBase.getTokenBalance(member1);
        uint256 initialVoteTokens = votingBase.memberVoteToken(member1);

        // 模拟成员创建提案
        vm.startPrank(member1);
        uint256 id = votingBase.createProposal(
            "Improve Voting System777",
            100, //targetAmount
            1653897600, //beginTime
            16999999999, //endTime
            7 days, //duration
            address(5),
            50
        );
        vm.stopPrank();

        // 获取提案信息并进行基本验证
        DataType.CampaignInfo memory proposal = votingBase.getProposal(id);
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
        // 创建提案
        vm.startPrank(member1);
        uint256 id = votingBase.createProposal(
            "Improve Voting System 1",
            100,
            1653897600,
            16999999999,
            7 days, //duration
            address(5),
            50
        );
        vm.stopPrank();

        // 成员投票
        vm.startPrank(member1);
        votingBase.vote(id, true); // member1 投支持票
        vm.stopPrank();

        vm.startPrank(member2);
        votingBase.vote(id, false); // member2 投反对票
        vm.stopPrank();

        vm.startPrank(member3);
        votingBase.vote(id, false); // member3 投反对票
        vm.stopPrank();

        // 获取提案信息并进行基本验证
        DataType.CampaignInfo memory proposal = votingBase.getProposal(id);
        assertEq(proposal.voteCount, 1); //一个赞成票
        assertEq(proposal.againstCount, 2); //两个反对票

        // 模拟时间流逝
        vm.warp(block.timestamp + 8 days);

        // 检查投票结果
        vm.startPrank(member1);
        votingBase.checkProposal(id);
        vm.stopPrank();

        // 断言：结果没通过
        assertFalse(votingBase.checkPass(id));
    }

    /**
     * 创建两个提案，对第二个提案投票
     */
    function testVoting2() public {
        // 创建提案
        vm.startPrank(member1);
        uint256 id1 = votingBase.createProposal(
            "Improve Voting System 2",
            100,
            1653897600,
            16999999999,
            7 days, //duration
            makeAddr("beneficiary"),
            50
        );

        uint256 id2 = votingBase.createProposal(
            "Improve Voting System 3",
            100,
            1653897600,
            16999999999,
            7 days, //duration
            makeAddr("beneficiary"),
            50
        );
        vm.stopPrank();

        // 成员投票
        vm.startPrank(member1);
        votingBase.vote(id2, true); // member1 投支持票
        vm.stopPrank();

        vm.startPrank(member2);
        votingBase.vote(id2, true); // member2 投支持票
        vm.stopPrank();

        vm.startPrank(member3);
        votingBase.vote(id2, false); // member3 投反对票
        vm.stopPrank();

        // 获取提案信息并进行基本验证
        DataType.CampaignInfo memory proposal = votingBase.getProposal(id2);
        assertEq(proposal.voteCount, 2); //两个赞成票
        assertEq(proposal.againstCount, 1); //一个反对票

        // 模拟时间流逝
        vm.warp(block.timestamp + 8 days);

        // 检查投票结果
        vm.startPrank(member1);
        votingBase.checkProposal(id2);
        vm.stopPrank();

        // 断言：结果通过
        assertTrue(votingBase.checkPass(id2));

        // 检查第一个提案
        assertFalse(votingBase.checkPass(id1)); //结果没通过
    }

    /**
     * 测试不能重复投票
     */
    function testAlreadyVoting() public {
        // 创建提案
        vm.startPrank(member1);
        uint256 id = votingBase.createProposal(
            "Improve Voting System",
            100,
            1653897600,
            16999999999,
            7 days, //duration
            address(5),
            50
        );
        vm.stopPrank();

        // 投票
        vm.startPrank(member1);
        votingBase.vote(id, true); // member1 投支持票
        vm.stopPrank();

        // 尝试重复投票
        vm.startPrank(member1);
        vm.expectRevert("Already voted");
        votingBase.vote(id, true);
        vm.stopPrank();
    }

    /**
     * 测试投票后是否销毁了token
     */
    function testVotingAndTokenBurn() public {
        // 设置初始条件，确保用户有足够的代币
        vm.startPrank(member1);
        uint256 id = votingBase.createProposal(
            "Improve Voting System",
            100,
            1653897600,
            16999999999,
            7 days, //duration
            address(5),
            50
        );
        vm.stopPrank();

        // 记录投票前的代币余额和总供应量
        uint256 initialBalance = votingBase.getTokenBalance(member1);
        uint256 initialTotalSupply = votingToken.totalSupply();

        // 投票操作
        vm.startPrank(member1);
        votingBase.vote(id, true); // member1 投支持票
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

    /**
     * 测试在投票期未结束前查看投票结果
     */
    function testCheckProposalBeforeEnd() public {
        // 创建提案
        vm.startPrank(member1);
        uint256 id = votingBase.createProposal(
            "Test Proposal",
            100,
            1653897600,
            16999999999,
            7 days, //duration
            address(5),
            50
        );
        vm.stopPrank();
        // 成员投票
        vm.startPrank(member1);
        votingBase.vote(id, true);
        vm.stopPrank();

        // 模拟时间流逝
        vm.warp(block.timestamp + 6 days);

        // 尝试在投票期未结束前查看结果，应抛出错误
        vm.expectRevert("Voting period has not ended yet");
        votingBase.checkProposal(id);

        vm.expectRevert("Voting period has not ended yet");
        votingBase.checkPass(id);
    }

    function testDonate_NotEnoughUSD() public createProposalAndPassed {
        uint256 id = 1;

        vm.prank(member1);
        vm.expectRevert("you need to send more ETH");
        votingBase.donate{value: ONE_USD}(id);

        vm.prank(member2);
        vm.expectRevert("you need to send more ETH");
        votingBase.donate{value: 2 * ONE_USD}(id);

        vm.prank(member3);
        vm.expectRevert("you need to send more ETH");
        votingBase.donate{value: FIVE_USD - 1}(id);
    }

    function testDonate_EnoughUSD() public createProposalAndPassed {
        uint256 id = 1;
        uint256 totalDonation = 0;

        assertEq(address(votingBase).balance, 0);
        {
            // member1 捐款 5USD
            uint256 beginBalance1 = member1.balance;
            vm.prank(member1);
            votingBase.donate{value: FIVE_USD}(id);
            uint256 endBalanace1 = member1.balance;
            totalDonation += FIVE_USD;

            assertEq(beginBalance1 - endBalanace1, FIVE_USD);
            assertEq(address(votingBase).balance, totalDonation);
        }

        // member2 捐款10USD
        {
            uint256 beginBalance2 = member2.balance;
            vm.prank(member2);
            votingBase.donate{value: TEN_USD}(id);
            uint256 endBalance2 = member2.balance;
            totalDonation += TEN_USD;
            assertEq(beginBalance2 - endBalance2, TEN_USD);
            assertEq(address(votingBase).balance, totalDonation);
        }

        // member3 捐款10USD
        {
            uint256 beginBalance3 = member3.balance;
            vm.prank(member3);
            votingBase.donate{value: TEN_USD}(id);
            uint256 endBalance3 = member3.balance;
            totalDonation += TEN_USD;
            assertEq(beginBalance3 - endBalance3, TEN_USD);
            assertEq(address(votingBase).balance, totalDonation);
        }

        // 总共收到25USD
        assertEq(address(votingBase).balance, FIVE_USD + TEN_USD + TEN_USD);
        assertEq(address(votingBase).balance, totalDonation);
    }

    function testDonate_NonExistCampaign() public createProposalAndPassed {
        // createProposalAndPassed 会添加一个campaign，id为1
        vm.startPrank(member1);
        vm.expectRevert("campaign not exist");
        votingBase.donate{value: FIVE_USD}(2);
        vm.stopPrank();

        vm.startPrank(member2);
        vm.expectRevert("campaign not exist");
        votingBase.donate{value: FIVE_USD}(3);
        vm.stopPrank();

        vm.startPrank(member3);
        vm.expectRevert("campaign not exist");
        votingBase.donate{value: FIVE_USD}(440);
        vm.stopPrank();
    }

    function testDonate_NoInPeriod() public {
        uint256 votingDuration = 1 days;
        uint256 beginTime = block.timestamp + 7 days;
        uint256 endTime = beginTime + 7 days;
        uint256 proposalId = 0;
        // 创建并通过提案
        {
            // 成员1创建提案
            vm.startPrank(member1);
            proposalId = votingBase.createProposal(
                "Improve Voting System",
                100, //targetAmount(USD)
                beginTime, // 当前时间戳的 7 天后
                endTime, // beginTime的7天后
                votingDuration, //1天
                address(6), // beneficiary
                MIN_DONATION_FIVE_USD
            );
            vm.stopPrank();

            // 成员投票
            vm.startPrank(member1);
            votingBase.vote(proposalId, true); // member1 投支持票
            vm.stopPrank();

            vm.startPrank(member2);
            votingBase.vote(proposalId, true); // member2 投支持票
            vm.stopPrank();

            // 模拟时间流逝
            vm.warp(block.timestamp + votingDuration);

            // 检查投票结果
            vm.startPrank(member1);
            votingBase.checkProposal(proposalId);
            vm.stopPrank();
        }

        // 捐款活动还没开始:campaign not start
        {
            vm.startPrank(member1);
            vm.expectRevert("campaign not start");
            votingBase.donate{value: FIVE_USD}(proposalId);
            vm.stopPrank();
        }

        // 捐款活动结束了:campaign has ended
        {
            // 模拟时间流逝
            vm.warp(endTime + 1 days);
            vm.startPrank(member1);
            vm.expectRevert("campaign has ended");
            votingBase.donate{value: FIVE_USD}(proposalId);
            vm.stopPrank();
        }
    }

    function testDonate_ReachTargetAmount() public createProposalAndPassed {
        uint256 proposalId = 1;

        // member1 捐款 TARGET_DONATION_USD - 1 USD的金额
        // 距离目标金额还差1USD
        uint256 donateAmount = price.USD(TARGET_DONATION_USD) - ONE_USD; //  距离目标金额还差1USD
        vm.startPrank(member1);
        votingBase.donate{value: donateAmount}(proposalId);
        vm.stopPrank();

        // member2 捐款 5 USD
        vm.startPrank(member2);
        votingBase.donate{value: FIVE_USD}(proposalId);
        vm.stopPrank();

        // member3 捐款 5USD
        vm.startPrank(member3);
        vm.expectRevert("reached target amount");
        votingBase.donate{value: FIVE_USD}(proposalId);
        vm.stopPrank();
    }

    function createCampaign(
        address beneficiaryAddr,
        uint256 targetUSD,
        uint256 minDonationUSD,
        uint256 beginTime,
        uint256 endTime
    ) private returns (uint256) {
        // 成员1创建提案
        vm.startPrank(member1);
        uint256 proposalId = votingBase.createProposal(
            "Improve Voting System",
            targetUSD, //targetAmount(USD)
            beginTime, //beginTime 2022-05-30 16:00:00
            endTime, //endTime 2508-09-16 14:13:19
            1 days, //duration
            beneficiaryAddr, // beneficiary
            minDonationUSD
        );
        vm.stopPrank();

        // 成员投票
        vm.startPrank(member1);
        votingBase.vote(proposalId, true); // member1 投支持票
        vm.stopPrank();

        vm.startPrank(member2);
        votingBase.vote(proposalId, true); // member2 投支持票
        vm.stopPrank();

        // 模拟时间流逝
        vm.warp(block.timestamp + 1 days);

        // 检查投票结果
        vm.startPrank(member1);
        votingBase.checkProposal(proposalId);
        vm.stopPrank();

        return proposalId;
    }

    function testTransferDonations_NoAmountToBeSend() public {
        uint256 targetUSD = 100; // 100 USD
        uint256 minDonationUSD = 5;
        uint256 beginTime = block.timestamp + 2 days;
        uint256 endTime = beginTime + 7 days;
        uint256 proposalId = createCampaign(
            beneficiary,
            targetUSD,
            minDonationUSD,
            beginTime,
            endTime
        );

        // 模拟时间流逝，没人捐款
        vm.warp(endTime + 1);

        // 转账
        vm.startPrank(owner);
        vm.expectRevert("no amount to be send");
        votingBase.transferDonations(proposalId);
        vm.stopPrank();
    }

    // 测试重复转账
    function testTransferDonations_DonationHasBeenWithdrawn() public {
        uint256 targetUSD = 100; // 100 USD
        uint256 minDonationUSD = 5;
        uint256 beginTime = block.timestamp + 2 days;
        uint256 endTime = beginTime + 7 days;
        uint256 proposalId = createCampaign(
            beneficiary,
            targetUSD,
            minDonationUSD,
            beginTime,
            endTime
        );

        vm.warp(beginTime);
        // member1 捐款200USD
        uint256 TWO_HUNDRED_USD = TEN_USD * 20;
        vm.startPrank(member1);
        votingBase.donate{value: TWO_HUNDRED_USD}(proposalId);
        vm.stopPrank();
        // 模拟时间流逝，捐款活动结束
        vm.warp(endTime + 1);

        uint256 beginVotingBaseBalance = address(votingBase).balance;
        uint256 beginBeneficiaryBalance = beneficiary.balance;

        // 转账
        vm.startPrank(owner);
        votingBase.transferDonations(proposalId);
        vm.stopPrank();

        uint256 endVotingBaseBalance = address(votingBase).balance;
        uint256 endBeneficiaryBalance = beneficiary.balance;
        assertEq(endVotingBaseBalance, 0);
        assertEq(
            beginVotingBaseBalance + beginBeneficiaryBalance,
            endBeneficiaryBalance
        );

        vm.startPrank(owner);
        vm.expectRevert("donation has been withdrawn");
        votingBase.transferDonations(proposalId);
        vm.stopPrank();
    }
}
