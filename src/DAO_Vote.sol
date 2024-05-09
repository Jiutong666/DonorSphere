// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract VotingContract is ERC20, Ownable {
    uint256 public _tokenIds;

    struct Proposal {
        uint256 id;
        string name;
        address creator;
        uint256 createTime;
        uint256 voteCount;
        uint256 againstCount;
        bool passed;
    }
    address[] public members;

    mapping(uint256 => Proposal) public proposals;
    mapping(address => uint256) public memberVoteToken; // 成员到其投票代币的映射
    mapping(uint256 => mapping(address => bool)) public voted;
    mapping(address => bool) public isMember;

    event MemberAdded(address member);
    event MemberRemoved(address member);
    event ProposalCreated(uint256 proposalId, string name, address creator);
    event Voted(uint256 proposalId, address voter, bool support);

    modifier onlyMember() {
        require(isMember[msg.sender], "Not a team member");
        _;
    }

    constructor() ERC20("VotingDonor", "VOTE") Ownable(msg.sender) {}

    //新增团队成员
    function addMember(address _member) public onlyOwner {
        isMember[_member] = true;
        members.push(_member);
        emit MemberAdded(_member);
    }

    //移除团队成员
    function removeMember(address _member) public onlyOwner {
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

    //创建提案
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

        distributeTokens();
        emit ProposalCreated(proposalId, name, msg.sender);
    }

    // 向所有成员分发代币
    function distributeTokens() public onlyOwner {
        //创建代币
        _mint(address(this), 100 * 10 ** uint256(decimals()));

        for (uint256 i = 0; i < members.length; i++) {
            address member = members[i];
            if (isMember[member]) {
                _transfer(address(this), member, 1 * 10 ** uint256(decimals())); // 给每个成员发放1个代币
                memberVoteToken[member] += 1;
            }
        }
    }

    //投票
    function vote(uint256 proposalId, bool support) public onlyMember {
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
        _burn(msg.sender, 1 * 10 ** uint256(decimals()));

        checkProposal(proposalId);

        emit Voted(proposalId, msg.sender, support);
    }

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

    //检查项目是否通过
    function checkPass(uint256 proposalId) public view returns (bool) {
        Proposal storage p = proposals[proposalId];
        return p.passed;
    }
}
