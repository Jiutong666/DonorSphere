// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";
import "../src/core/CampaignManager.sol";
import "../src/libraries/DataType.sol";

contract TestCampaignManager is Test {
    CampaignManager manager;
    DataType.CampaignInfo info1;
    DataType.CampaignInfo info2;
    DataType.CampaignInfo info3;
    uint256 constant targetAmount = 10000;
    address beneficiary;
    address creator;
    uint256 beginTime;
    uint256 endTime;

    function makeCampaign(
        uint256 id,
        string memory name
    ) private view returns (DataType.CampaignInfo memory info) {
        info.id = id;
        info.name = name;
        info.beneficiary = beneficiary;
        info.targetAmount = targetAmount;
        info.currentAmount = 0;
        info.beginTime = beginTime;
        info.endTime = endTime;
        info.creator = creator;
        return info;
    }

    function setUp() public {
        manager = new CampaignManager();
        beneficiary = makeAddr("beneficiary");
        creator = makeAddr("creator");
        beginTime = block.timestamp;
        endTime = beginTime + 10 minutes;

        info1 = makeCampaign(1, "cp1");
        info2 = makeCampaign(2, "cpp reference");
        info3 = makeCampaign(3, "funding for the best language php!");
    }

    function testSize() public {
        assertEq(manager.size(), 0);

        manager.addCampaign(info1);
        assertEq(manager.size(), 1);

        manager.addCampaign(info2);
        assertEq(manager.size(), 2);

        manager.addCampaign(info3);
        assertEq(manager.size(), 3);
    }

    function testEmpty() public {
        assertEq(manager.empty(), true);

        manager.addCampaign(info1);
        assertEq(manager.empty(), false);

        manager.addCampaign(info2);
        assertEq(manager.empty(), false);
    }

    function testAddDifferentCampaign() public {
        uint256 notExistId = 999;
        manager.addCampaign(info1);
        assertEq(manager.hasCampaign(info1.id), true);
        assertEq(manager.hasCampaign(info2.id), false);
        assertEq(manager.hasCampaign(info3.id), false);
        assertEq(manager.hasCampaign(notExistId), false);
        assertEq(manager.size(), 1);

        manager.addCampaign(info2);
        assertEq(manager.hasCampaign(info1.id), true);
        assertEq(manager.hasCampaign(info2.id), true);
        assertEq(manager.hasCampaign(info3.id), false);
        assertEq(manager.hasCampaign(notExistId), false);
        assertEq(manager.size(), 2);

        manager.addCampaign(info3);
        assertEq(manager.hasCampaign(info1.id), true);
        assertEq(manager.hasCampaign(info2.id), true);
        assertEq(manager.hasCampaign(info3.id), true);
        assertEq(manager.hasCampaign(notExistId), false);
        assertEq(manager.size(), 3);
    }

    function testAddDuplicateCampaign() public {
        {
            manager.addCampaign(info1);
            assertEq(manager.size(), 1);

            vm.expectRevert("campaign already exists");
            manager.addCampaign(info1);
            assertEq(manager.size(), 1);
        }

        {
            manager.addCampaign(info2);
            assertEq(manager.size(), 2);

            vm.expectRevert("campaign already exists");
            manager.addCampaign(info2);
            assertEq(manager.size(), 2);
        }

        {
            manager.addCampaign(info3);
            assertEq(manager.size(), 3);

            vm.expectRevert("campaign already exists");
            manager.addCampaign(info3);
            assertEq(manager.size(), 3);
        }
    }

    function testSupportMaximumCampaigns() public {
        // NOTE: 把 INVALID_INDEX 和 CAPACITY 调低，方便测试
        // uint256 capacity = manager.capacity();
        // for (uint256 i = 1; i <= capacity; ++i) {
        //     info1.id = i;
        //     manager.addCampaign(info1);
        //     assertEq(manager.size(), i);
        // }
        // assertEq(manager.size(), manager.capacity());
        // info1.id = type(uint256).max;
        // vm.expectRevert("achieve maximum number of supported campaings");
        // manager.addCampaign(info1);
    }

    function testRemoveCampaign() public {
        // add campaign
        {
            manager.addCampaign(info1);
            assertEq(manager.size(), 1);

            manager.addCampaign(info2);
            assertEq(manager.size(), 2);

            manager.addCampaign(info3);
            assertEq(manager.size(), 3);
        }

        // remove campaign
        {
            manager.removeCampaign(info3.id);
            assertEq(manager.size(), 2);
            assertEq(manager.empty(), false);

            assertEq(manager.hasCampaign(info1.id), true);
            assertEq(manager.hasCampaign(info2.id), true);
            assertEq(manager.hasCampaign(info3.id), false);
        }
        {
            manager.removeCampaign(info1.id);
            assertEq(manager.size(), 1);
            assertEq(manager.empty(), false);

            assertEq(manager.hasCampaign(info1.id), false);
            assertEq(manager.hasCampaign(info2.id), true);
            assertEq(manager.hasCampaign(info3.id), false);
        }
        {
            manager.removeCampaign(info2.id);
            assertEq(manager.size(), 0);
            assertEq(manager.empty(), true);

            assertEq(manager.hasCampaign(info1.id), false);
            assertEq(manager.hasCampaign(info2.id), false);
            assertEq(manager.hasCampaign(info3.id), false);
        }
    }

    function testDeleteAllCampaigns() public {
        // add campaign
        uint256 left = 100;
        uint256 right = 150;
        uint256 size = right - left + 1;
        {
            for (uint256 i = left; i <= right; ++i) {
                info1.id = i;
                manager.addCampaign(info1);
            }
            assertEq(manager.size(), size);
        }

        // 删除奇数
        {
            uint256 cnt = 0;
            for (uint256 id = left; id <= right; ++id) {
                if (id % 2 == 1) {
                    cnt++;
                    manager.removeCampaign(id);
                }
            }
            assertEq(manager.size(), size - cnt);
        }

        // 删除偶数
        {
            uint256 cnt = 0;
            for (uint256 id = left; id <= right; ++id) {
                if (id % 2 == 0) {
                    cnt++;
                    manager.removeCampaign(id);
                }
            }
            assertEq(manager.size(), 0);
            assertEq(manager.empty(), true);
        }
    }
}
