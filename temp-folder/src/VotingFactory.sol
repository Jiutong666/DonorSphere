// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./VotingBase.sol";

contract VotingBaseFactory {
    address[] public allCampaigns;

    event CampaignCreated(address campaignAddress, address creator);
    
    VotingToken public token;
    address public dataFeedAddr;

    constructor(VotingToken _token, address _dataFeedAddr) {
        token = _token;
        dataFeedAddr = _dataFeedAddr;
    }

    function createCampaign() external {
        VotingBase newCampaign = new VotingBase(token, dataFeedAddr, msg.sender);
        allCampaigns.push(address(newCampaign));
        emit CampaignCreated(address(newCampaign), msg.sender);
    }

    function getAllCampaigns() external view returns (address[] memory) {
        return allCampaigns;
    }
}
