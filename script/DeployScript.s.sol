// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "forge-std/Script.sol";
import "../src/VotingBase.sol";
import "../src/VotingToken.sol";

contract DeployScript is Script {
    function run() public {
        VotingToken votingToken = new VotingToken();
        VotingBase votingBase = new VotingBase(votingToken);

        vm.startBroadcast();
        votingBase.addMember(msg.sender);  // 在部署时自动添加部署者为成员
        vm.stopBroadcast();
    }
}