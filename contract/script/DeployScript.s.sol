// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "../src/VotingBase.sol";
import "../src/VotingToken.sol";
import "../src/core/PriceConverter.sol";
import "../src/VotingFactory.sol";

contract DeployScript is Script {
    function run() public returns(VotingBaseFactory){
        // 使用固定的数据馈送地址
        address dataFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

        vm.startBroadcast();

        // 部署 VotingToken 合约
        VotingToken votingToken = new VotingToken();

        // 部署 VotingBase 合约
        VotingBaseFactory votingFactory = new VotingBaseFactory(
            votingToken,
            dataFeedAddress
        );

       // console.log("VotingBaseFactory deployed at:", address(votingFactory));
        
        vm.stopBroadcast();

        return votingFactory;
    }
}
