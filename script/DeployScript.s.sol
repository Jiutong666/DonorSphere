// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "../src/VotingBase.sol";
import "../src/VotingToken.sol";
import "../src/core/PriceConverter.sol";

contract DeployScript is Script {
    function run() public {
        // 使用固定的数据馈送地址
        address dataFeedAddress = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
        

        vm.startBroadcast();

        // 部署 VotingToken 合约
        VotingToken votingToken = new VotingToken();

        // 部署 PriceConverter 合约
        PriceConverter priceConverter = new PriceConverter(dataFeedAddress);

        // 部署 VotingBase 合约
        VotingBase votingBase = new VotingBase(
            votingToken,
            address(priceConverter)
        );

        // 自动添加部署者为成员
        votingBase.addMember(msg.sender);

        vm.stopBroadcast();
    }
}
