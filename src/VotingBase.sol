// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./VotingToken.sol";

contract VotingBase is ERC721URIStorage, Ownable {
    /**
     * @dev 计数器，用于createProposal时候新增id
     */
    uint256 public _tokenIds;

    /**
     * @dev 用于存储 DAO Token 合约实例的私有变量。
     */
    VotingToken private _voting_Token;

    //提案的结构体
    struct Proposal {
        uint256 id;
        string name;
        address creator;
        uint256 createTime;
        uint256 voteCount;
        uint256 againstCount;
        bool passed;
    }

    //member数组
    address[] public members;

    mapping(uint256 => Proposal) public proposals;

    // 成员到其投票代币的映射
    mapping(address => uint256) public memberVoteToken;

    //用于检查是否投票，第一个uit指的是Proposal的id
    mapping(uint256 => mapping(address => bool)) public voted;

    mapping(address => bool) public isMember;

    event MemberAdded(address member);
    event MemberRemoved(address member);
    event ProposalCreated(uint256 proposalId, string name, address creator);
    event Voted(uint256 proposalId, address voter, bool support);

    // 只有member成员才能调用
    modifier onlyMember() {
        require(isMember[msg.sender], "Not a team member");
        _;
    }

    constructor(VotingToken token) Ownable(msg.sender) ERC721("ProposalToken", "PROP") {
        _voting_Token = token;
    }

    //新增成员
    function addMember(address _member) public onlyOwner {
        require(!isMember[_member], "Member already exists"); // 确保成员地址不是重复的
        isMember[_member] = true;
        members.push(_member);
        emit MemberAdded(_member);
    }

    //删除成员
    function removeMember(address _member) public onlyOwner {
        require(isMember[_member], "Address is not a member"); // 确保该地址是一个成员
        isMember[_member] = false;
        for (uint256 i = 0; i < members.length; i++) {
            if (members[i] == _member) {
                members[i] = members[members.length - 1];
                members.pop();
                break;
            }
        }
        emit MemberRemoved(_member);
    }

    /**
     * @dev 创建提案
     * @dev 每创建提案就创建100枚token，分给每个人
     */
    function createProposal(string memory name) public onlyMember {
        uint256 proposalId = _tokenIds;
        _tokenIds++;

        proposals[proposalId] = Proposal({
            id: proposalId,
            name: name,
            creator: msg.sender,
            createTime: block.timestamp,
            voteCount: 0,
            againstCount: 0,
            passed: false
        });

        _mint(msg.sender, proposalId);
        // _setTokenURI(proposalId, tokenURI);

        distributeTokens(); 
        emit ProposalCreated(proposalId, name, msg.sender);
    }


    /**
     *@dev 创建100个token，分发给每个成员一枚
     */
    function distributeTokens() public onlyMember {
        _voting_Token.mint(address(this),100 * 10 ** uint256(_voting_Token.decimals()));
        for (uint256 i = 0; i < members.length; i++) {
            address member = members[i];
            if (isMember[member]) {
                _voting_Token.transfer(
                    member,
                    1 * 10 ** uint256(_voting_Token.decimals())
                );
                memberVoteToken[member] += 1;
            }
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
        _voting_Token.burn( msg.sender,1 * 10 ** uint256(_voting_Token.decimals()));

        checkProposal(proposalId);

        emit Voted(proposalId, msg.sender, support);
    }

    /**
     *@dev 检查结果
     *@dev 有过一半以上的同意，则提案就通过
     */
    function checkProposal(uint256 proposalId) private {
        Proposal storage proposal = proposals[proposalId];
        //总票数
        uint256 totalVotes = proposal.voteCount + proposal.againstCount;

        if (proposal.voteCount > totalVotes / 2) {
            proposal.passed = true;
        } else {
            proposal.passed = false;
        }
    }

    // 获取所有提案的ID列表
    function getAllProposalIds() public view returns (uint256[] memory) {
        uint256[] memory ids = new uint256[](_tokenIds);
        for (uint256 i = 0; i < _tokenIds; i++) {
            ids[i] = i;
        }
        return ids;
    }

    //检查项目是否通过
    function checkPass(uint256 proposalId) public view returns (bool) {
        Proposal storage p = proposals[proposalId];
        return p.passed;
    }

    // 获取提案详细信息
    function getProposal(
        uint256 proposalId
    ) public view returns (Proposal memory) {
        return proposals[proposalId];
    }

    // 获取指定地址的VotingToken余额
    function getTokenBalance(address member) public view returns (uint256) {
        return _voting_Token.balanceOf(member);
    }
}
