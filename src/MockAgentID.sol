// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @notice TESTNET-ONLY stand-in for the real Agent ID contract
/// (0x60b9262456de011f7d15a54cdd8c48baaa8b022f on BNB Chain mainnet).
/// The real Agent ID contract has no testnet deployment, so this mock
/// lets the badge mint flow be tested end-to-end on BSC testnet.
/// NEVER use this mock as the Agent ID gate on mainnet.
contract MockAgentID {
    mapping(address => uint256) public balances;

    function setBalance(address who, uint256 bal) external {
        balances[who] = bal;
    }

    function balanceOf(address who) external view returns (uint256) {
        return balances[who];
    }
}
