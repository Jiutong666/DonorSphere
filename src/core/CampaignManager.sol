// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/DataType.sol";

contract CampaignManager {
    constructor() {}

    /**
     * @dev 活动是否发起
     */
    mapping(uint256 campaignId => bool exists) private s_campaignIdExists;
    /**
     * @dev 已发起的所有活动记录
     */
    DataType.CampaignInfo[] private s_campaigns;
    /**
     * @dev 活动 id 在 s_campaigns 的索引
     * 当 s_campaignIdExists[id] 为 true 时索引有效
     */
    mapping(uint256 campaignId => uint256 index) private s_campaignIdIdx;

    /**
     * 规定 uint256 的最大值是非法活动id
     */
    function INVALID_INDEX() public pure returns (uint256) {
        return type(uint256).max;
    }

    /**
     * CampaignManager的最大容量
     * 最多支持 type(uint256).max - 1 个活动
     */
    function capacity() public pure returns (uint256) {
        return type(uint256).max - 1;
    }

    function size() public view returns (uint256) {
        return s_campaigns.length;
    }

    function empty() public view returns (bool) {
        return s_campaigns.length == 0;
    }

    function addCampaign(DataType.CampaignInfo memory info) public {
        uint256 id = info.id;
        require(id != 0, "invalid campaign id");
        require(s_campaignIdExists[id] == false, "duplicate campaign id");
        require(info.beneficiary != address(0), "invalid beneficiary address");
        require(info.endTime > info.beginTime, "invalid campaign period");
        uint256 length = s_campaigns.length;
        require(
            length < capacity(),
            "achieve maximum number of supported campaings"
        );
        s_campaignIdExists[id] = true;
        s_campaigns.push(info);
        s_campaignIdIdx[id] = s_campaigns.length - 1;
    }

    function removeCampaign(uint256 campaignId) public {
        bool campaignExist = s_campaignIdExists[campaignId];
        if (campaignExist == false) {
            return;
        }

        s_campaignIdExists[campaignId] = false;

        uint256 idx = s_campaignIdIdx[campaignId];
        uint256 length = s_campaigns.length;
        if (idx < length) {
            s_campaigns[idx] = s_campaigns[length - 1];
            s_campaigns.pop();
        }
        // 让索引失效
        s_campaignIdIdx[campaignId] = INVALID_INDEX();
    }

    function hasCampaign(uint256 id) public view returns (bool) {
        return s_campaignIdExists[id] == true;
    }
}
