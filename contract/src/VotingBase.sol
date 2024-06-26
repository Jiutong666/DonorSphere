// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
import "./VotingToken.sol";
import "./libraries/DataType.sol";
import "./core/CampaignManager.sol";
import "./core/PriceConverter.sol";

contract VotingBase is ERC721URIStorage, Ownable, ReentrancyGuard {
    // TODO: 用DataFeed获取价格，设置一个minimum donation
    //uint256 private _minimum_donations;
    PriceConverter private _price;
    /**
     * @dev 计数器，用于createProposal时候新增id
     * 0 在 CampaignManager 用作 无效id
     * mapping貌似不能真正的删除key，只能置0，所以把0当作 无效id
     */
    uint256 private _tokenIds = 0;

    /**
     * @dev 用于存储 DAO Token 合约实例的私有变量。
     */
    VotingToken private _voting_Token;
    /**
     * @dev 管理所有已发起的活动
     */
    CampaignManager private _manager;
    //member数组
    address[] public members;

    mapping(uint256 => DataType.CampaignInfo) public proposals;

    // 成员到其投票代币的映射
    mapping(address => uint256) public memberVoteToken;

    //用于检查是否投票，第一个uit指的是Proposal的id
    mapping(uint256 => mapping(address => bool)) public voted;

    mapping(address => bool) public isMember;
    mapping(address => uint256) private memberIndex; // 新增：成员索引映射
    mapping(uint256 => uint256) public proposalEndTimes; // 新增：提案结束时间
    mapping(uint256 => uint256) private _minimum_donations; // 将minimum donations设置为每个提案的

    event MemberAdded(address member);
    event MemberRemoved(address member);
    event ProposalCreated(uint256 proposalId, string name, address creator);
    event Voted(uint256 proposalId, address voter, bool support);

    // 只有member成员才能调用
    modifier onlyMember() {
        require(isMember[msg.sender], "Not a team member");
        _;
    }

    constructor(
        VotingToken token,
        address dataFeddAddr,
        address initialOwner
    ) Ownable(initialOwner) ERC721("ProposalToken", "PROP") {
        _voting_Token = token;
        _manager = new CampaignManager();
        _price = new PriceConverter(dataFeddAddr);

        isMember[initialOwner] = true;
        members.push(initialOwner);
        memberIndex[initialOwner] = members.length - 1;
        emit MemberAdded(initialOwner);
    }

    //添加成员
    function addMember(address _member) external onlyOwner {
        require(members.length < 100, "Cannot add more than 100 members");
        require(!isMember[_member], "Member already exists");
        isMember[_member] = true;
        members.push(_member);
        memberIndex[_member] = members.length - 1; // 更新索引映射
        emit MemberAdded(_member);
    }

    //删除成员
    function removeMember(address _member) external onlyOwner {
        require(isMember[_member], "Address is not a member");
        isMember[_member] = false;
        uint256 lastIndex = members.length - 1;
        uint256 idx = memberIndex[_member];
        if (idx != lastIndex) {
            address lastMember = members[lastIndex];
            members[idx] = lastMember;
            memberIndex[lastMember] = idx;
        }
        members.pop();
        delete memberIndex[_member];
        emit MemberRemoved(_member);
    }

    /**
     * @dev 创建提案
     * @dev 每创建提案就创建100枚token，分给每个人
     */
    function createProposal(
        string memory name,
        uint256 targetAmount, // 目标金额(单位USD)
        uint256 beginTime, // 捐款开始时间
        uint256 endTime, //捐款结束时间
        uint256 duration, //持续的日期
        address beneficiary, // 受益人
        uint256 minDonationInUSD // 最小捐款数
    ) public onlyMember returns (uint256) {
        _tokenIds++;
        uint256 proposalId = _tokenIds;

        proposals[proposalId] = DataType.CampaignInfo({
            id: proposalId, //捐款id
            name: name, //捐款名字
            creator: msg.sender, //创建者
            createTime: block.timestamp, //创建时间
            voteCount: 0,
            againstCount: 0,
            passed: false,
            targetAmount: _price.USD(targetAmount),
            currentAmount: 0,
            beginTime: beginTime,
            endTime: endTime,
            donationWithdrawn: false,
            beneficiary: beneficiary
        });

        proposalEndTimes[proposalId] = block.timestamp + duration;
        _minimum_donations[proposalId] = _price.USD(minDonationInUSD);

        _mint(msg.sender, proposalId);
        // _setTokenURI(proposalId, tokenURI);

        distributeTokens();
        emit ProposalCreated(proposalId, name, msg.sender);
        return proposalId;
    }

    /**
     *@dev 创建100个token，分发给每个成员一枚
     */
    function distributeTokens() internal onlyMember {
        _voting_Token.mint(
            address(this),
            100 * 10 ** uint256(_voting_Token.decimals())
        );

        uint256 amount = 1 * 10 ** uint256(_voting_Token.decimals());

        for (uint256 i = 0; i < members.length; i++) {
            address member = members[i];
            _voting_Token.transfer(member, amount);
            memberVoteToken[member] += 1;
        }
    }

    /**
     *@dev 投票
     *@dev 每次投票成功后就销毁一枚token
     */
    function vote(uint256 proposalId, bool support) public onlyMember {
        //只能投票一次
        require(!voted[proposalId][msg.sender], "Already voted");
        require(memberVoteToken[msg.sender] > 0, "Not enough voting tokens");
        //require(proposals[proposalId].creator != msg.sender, "Creator cannot vote on their own proposal"); //创建者不能投票

        voted[proposalId][msg.sender] = true;
        memberVoteToken[msg.sender] -= 1;

        if (support) {
            proposals[proposalId].voteCount += 1;
        } else {
            proposals[proposalId].againstCount += 1;
        }
        // 销毁投票所使用的代币
        _voting_Token.burn(
            msg.sender,
            1 * 10 ** uint256(_voting_Token.decimals())
        );

        emit Voted(proposalId, msg.sender, support);
    }

    /**
     *@dev 检查结果
     *@dev 有过一半以上的同意，则提案就通过
     *@dev 同意就创建Campaign
     */
    function checkProposal(uint256 proposalId) public {
        require(
            block.timestamp >= proposalEndTimes[proposalId],
            "Voting period has not ended yet"
        );

        DataType.CampaignInfo storage proposal = proposals[proposalId];
        uint256 totalVotes = proposal.voteCount + proposal.againstCount;

        if (proposal.voteCount > totalVotes / 2) {
            // 同意就创建Campaign
            proposal.passed = true;
            _manager.addCampaign(proposal);
        } else {
            proposal.passed = false;
        }
    }

    // 获取所有提案的ID列表
    function getAllProposalIds() external view returns (uint256[] memory) {
        uint256[] memory ids = new uint256[](_tokenIds);
        for (uint256 i = 0; i < _tokenIds; i++) {
            ids[i] = i;
        }
        return ids;
    }

    //检查项目是否通过
    function checkPass(uint256 proposalId) external view returns (bool) {
        require(
            block.timestamp >= proposalEndTimes[proposalId],
            "Voting period has not ended yet"
        );
        DataType.CampaignInfo storage p = proposals[proposalId];
        return p.passed;
    }

    // 获取提案详细信息
    function getProposal(
        uint256 proposalId
    ) external view returns (DataType.CampaignInfo memory) {
        return proposals[proposalId];
    }

    // 获取指定地址的VotingToken余额
    function getTokenBalance(address member) external view returns (uint256) {
        return _voting_Token.balanceOf(member);
    }

    function donate(uint256 id) public payable nonReentrant {
        require(
            msg.value >= _minimum_donations[id],
            "you need to send more ETH"
        );

        _manager.donate(msg.sender, id, msg.value);
    }

    function transferDonations(uint256 id) public nonReentrant onlyOwner {
        DataType.CampaignInfo storage proposal = proposals[id];
        address payable beneficiary = payable(proposal.beneficiary);
        // setWithdrawn会清零amount，所以先取出来
        uint256 amount = _manager.currentAmount(id);
        // 这里会检查 currentAmount 和 是否被提取过
        _manager.setWithdrawn(id, beneficiary);
        (bool send, ) = beneficiary.call{value: amount}("");
        require(send, "faild to send ETH");

        // 更新提案状态为资金已提取
        proposal.donationWithdrawn = true;
    }

    receive() external payable {}
}
