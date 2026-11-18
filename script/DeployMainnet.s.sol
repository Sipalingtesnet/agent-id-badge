// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/AgentIDBadge.sol";

/// @notice MAINNET deployment: AgentIDBadge gated on the REAL Agent ID
/// contract (0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F).
/// No mock is deployed on mainnet. DO NOT broadcast without Mikasa's
/// explicit "y" on MAINNET_DEPLOY_PREVIEW.md.
contract DeployMainnet is Script {
    address constant AGENT_ID = 0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F;

    function run() external {
        vm.startBroadcast();
        AgentIDBadge badge = new AgentIDBadge(AGENT_ID);
        vm.stopBroadcast();
        console.log("AgentIDBadge:", address(badge));
        console.log("AgentID contract arg:", badge.agentIdContract());
    }
}
