// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../libraries/DataType.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract CampaignManager is Ownable, ReentrancyGuard {
    uint256 private constant INVALID_ID = 0;
    address private constant INVALID_ADDRESS = address(0);
    /**
     * @dev 已发起的所有活动记录
     */
    mapping(uint256 => DataType.CampaignInfo) private s_campaigns;
    /**
     * @dev 遍历用，记录所有活动id
     */
    uint256[] s_campaignIds;

    mapping(address donor => mapping(uint256 campaignId => uint256 amount)) s_donationsOf;

    modifier CampaignNotExists(uint256 id) {
        require(s_campaigns[id].id == 0, "campaign already exists");
        _;
    }
    modifier CampaignExists(uint256 id) {
        require(s_campaigns[id].id > 0, "campaign not exist");
        _;
    }
    modifier CampaignInPeriod(uint256 id) {
        require(
            block.timestamp >= s_campaigns[id].beginTime,
            "campaign not start"
        );
        require(
            block.timestamp <= s_campaigns[id].endTime,
            "campaign has ended"
        );
        _;
    }

    modifier onlyCampaignFinish(uint256 id) {
        require(
            s_campaigns[id].currentAmount >= s_campaigns[id].targetAmount ||
                block.timestamp > s_campaigns[id].endTime,
            "campaign not finished"
        );
        _;
    }

    modifier onlyBeneficiary(uint256 id, address beneficiary) {
        require(
            beneficiary == s_campaigns[id].beneficiary,
            "only beneficiary can withdraw"
        );
        _;
    }

    constructor() Ownable(msg.sender) {}

    function size() public view returns (uint256) {
        return s_campaignIds.length;
    }

    function empty() public view returns (bool) {
        return s_campaignIds.length == 0;
    }

    function hasCampaign(uint256 id) public view returns (bool) {
        return s_campaigns[id].id > 0;
    }

    // TODO: 直接传calldata类型的id, beginTime等字段会不会比传结构体更节约gas?
    function addCampaign(
        DataType.CampaignInfo memory info
    ) public onlyOwner CampaignNotExists(info.id) {
        uint256 id = info.id;
        require(id != INVALID_ID, "invalid camapignment id");
        require(info.beneficiary != INVALID_ADDRESS, "invalid beneficiary");
        require(info.creator != INVALID_ADDRESS, "invalid creator");
        require(info.endTime > info.beginTime, "invalid camapign time");
        require(info.targetAmount != 0, "invalid target amount");
        require(bytes(info.name).length != 0, "invalid name");
        info.currentAmount = 0;
        s_campaigns[id] = info;
        s_campaignIds.push(id);
    }

    // TODO: remove可能有问题，会影响 捐款记录
    function removeCampaign(
        uint256 campaignId
    ) public onlyOwner CampaignExists(campaignId) {
        uint256 length = s_campaignIds.length;
        for (uint256 i = 0; i < length; ++i) {
            if (s_campaignIds[i] == campaignId) {
                s_campaignIds[i] = s_campaignIds[length - 1];
                s_campaignIds.pop();
                break;
            }
        }

        delete s_campaigns[campaignId];
        s_campaigns[campaignId].id = INVALID_ID;
    }

    function donate(
        address donor,
        uint256 id,
        uint256 value
    ) public CampaignExists(id) CampaignInPeriod(id) returns (bool) {
        require(s_campaigns[id].currentAmount <= s_campaigns[id].targetAmount);
        s_campaigns[id].currentAmount += value;
        s_donationsOf[donor][id] += value;
        return true;
    }

    function setWithdrawn(
        uint256 campaignId,
        address beneficiary
    )
        public
        nonReentrant
        CampaignExists(campaignId)
        onlyCampaignFinish(campaignId)
        onlyBeneficiary(campaignId, beneficiary)
    {
        require(
            s_campaigns[campaignId].donationWithdrawn == false,
            "donation has been withdrawn"
        );
        s_campaigns[campaignId].donationWithdrawn = true;

        uint256 amount = s_campaigns[campaignId].currentAmount;
        require(amount > 0, "no amoutn to be send");
        s_campaigns[campaignId].currentAmount = 0;
    }

    function currentAmount(
        uint256 campaignId
    ) public view CampaignExists(campaignId) returns (uint256) {
        return s_campaigns[campaignId].currentAmount;
    }

    function DonationOf(
        address donor,
        uint256 campaignId
    ) public view CampaignExists(campaignId) returns (uint256) {
        return s_donationsOf[donor][campaignId];
    }
}
