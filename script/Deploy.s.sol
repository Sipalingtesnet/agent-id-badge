// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/AgentIDBadge.sol";
import "../src/MockAgentID.sol";

/// @notice Testnet deployment: MockAgentID (stand-in for the real Agent ID
/// contract, which has no testnet deployment) + AgentIDBadge gated on it.
/// The deployer is granted a mock Agent ID balance of 1 so the mint flow
/// can be tested end-to-end on testnet.
contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        MockAgentID mock = new MockAgentID();
        AgentIDBadge badge = new AgentIDBadge(address(mock));
        mock.setBalance(msg.sender, 1);
        vm.stopBroadcast();
        console.log("MockAgentID:", address(mock));
        console.log("AgentIDBadge:", address(badge));
        console.log("AgentID contract arg:", badge.agentIdContract());
    }
}
