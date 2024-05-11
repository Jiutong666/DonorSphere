// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../libraries/DataType.sol";

contract CampaignManager {
    /**
     * @dev array最多存放 type(uint256).max - 1 个元素
     * 最后一个索引是 type(uint256).max - 2
     * CampaignManager将 索引为 type(uint256).max - 2 的设置为非法活动
     * s_campaignIdIdx 返回的索引是 type(uint256).max - 2 表示该活动已被删除
     */
    uint256 private constant INVALID_INDEX = type(uint256).max - 2;
    /**
     * 最多支持 type(uint256).max - 3 == INVALID_INDEX 个活动
     */
    uint256 private constant CAPACITY = type(uint256).max - 3;

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

    constructor() {}

    /**
     * CampaignManager的最大容量
     * 最多支持 type(uint256).max - 1 个活动
     */
    function capacity() public pure returns (uint256) {
        return CAPACITY;
    }

    function size() public view returns (uint256) {
        return s_campaigns.length;
    }

    function empty() public view returns (bool) {
        return s_campaigns.length == 0;
    }

    // TODO: 直接传calldata类型的id, beginTime等字段会不会比传结构体更节约gas?
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

    function removeCampaign(uint256 deleteCampaignId) public {
        if (hasCampaign(deleteCampaignId) == false) {
            return;
        }

        s_campaignIdExists[deleteCampaignId] = false;

        uint256 findIndex = s_campaignIdIdx[deleteCampaignId];
        uint256 currentLength = s_campaigns.length;
        if (findIndex < currentLength) {
            uint256 lastId = s_campaigns[currentLength - 1].id;
            s_campaigns[findIndex] = s_campaigns[currentLength - 1];
            s_campaignIdIdx[lastId] = findIndex;
            s_campaigns.pop();
        }
        // 让索引失效
        s_campaignIdIdx[deleteCampaignId] = INVALID_INDEX;
    }

    function hasCampaign(uint256 id) public view returns (bool) {
        return s_campaignIdExists[id] == true;
    }
}
