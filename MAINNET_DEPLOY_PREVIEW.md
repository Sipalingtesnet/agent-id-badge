# MAINNET DEPLOY PREVIEW — Agent ID Badge

> **STATUS: PREVIEW ONLY — NOT DEPLOYED.**
> Mainnet deployment happens ONLY after Mikasa replies with an explicit **"y"**
> to this exact preview in chat. No mainnet transaction has been sent.

## What will be deployed

| Item | Value |
|---|---|
| Contract | `AgentIDBadge` (`src/AgentIDBadge.sol`, OpenZeppelin ERC721 + Ownable) |
| Chain | BNB Chain mainnet (chain id 56) |
| Constructor argument | Agent ID contract `0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F` (SPACE ID Agent ID, ERC-721) |
| Token name / symbol | Agent ID Badge / AIDB |
| Max supply | 1000, 1 per wallet, price 0 (gas only) |
| Owner powers | Pause / unpause minting ONLY. No withdraw, no allowlist, no supply or metadata changes, no `setApprovalForAll` |
| Deploy script | `script/DeployMainnet.s.sol` (deploys ONLY the badge — no mock on mainnet) |
| Source | https://github.com/Sipalingtesnet/agent-id-badge |

## Deployer wallet — TO BE NAMED

The deployer wallet is **not decided yet**. It must be a mainnet-funded wallet
Mikasa names for this exact deployment (her personal wallet, or sitomo/gupron
via the Binance Agentic Wallet flow — to be confirmed by her). The workhorse
key used for testnet holds **no mainnet BNB** and must NOT be used for mainnet.

The final contract address depends on the deployer address + nonce, so it is
only known at broadcast time. (The simulation below used Foundry's default
sender and predicted `0x5b73C5498c1E3b4dbA84de0F1833c4a029d90519` — that is
**not** the real address.)

## Simulation (eth_call, no broadcast) — 18 Nov 2026

- Simulated against BNB Chain mainnet RPC (`https://bsc-dataseed.binance.org`).
- Estimated total gas for the deployment script: **4,449,888 gas**
  (contract creation itself measured **3,427,343 gas** on BSC testnet).
- Current mainnet gas price at simulation time: **0.05 gwei**
  (`cast gas-price` = 50,000,000 wei).
- BNB price at simulation time: **$589.35** (CoinGecko).

## Cost scenarios (4,449,888 gas basis)

| Gas price | Cost (BNB) | Cost (USD @ $589.35) |
|---|---|---|
| 0.05 gwei (current) | 0.0002225 | ~$0.13 |
| 1 gwei | 0.00445 | ~$2.62 |
| 3 gwei | 0.01335 | ~$7.87 |
| 5 gwei | 0.02225 | ~$13.11 |

For reference, one user mint costs ~106,173 gas (measured on testnet) —
at 0.05 gwei that is ~0.0000053 BNB (~$0.003) paid by the minter, not by us.

## Exact command (run ONLY after her "y" + named deployer wallet)

```bash
cd ~/workspace/agent-id-hackathon/badge
forge script script/DeployMainnet.s.sol \
  --rpc-url https://bsc-dataseed.binance.org \
  --private-key <DEPLOYER_KEY_VIA_APPROVED_FLOW> \
  --broadcast --slow --gas-price <GAS_PRICE_AT_DEPLOY_TIME>
```

After broadcast: verify source on BscScan via Sourcify
(`forge verify-contract --verifier sourcify --chain-id 56 <ADDRESS>
src/AgentIDBadge.sol:AgentIDBadge`), switch the mint website config from
testnet to the mainnet addresses, and update `SUBMISSION.md` with the real
contract address.

## Safety checklist (standing rules)

- [x] Simulated first (eth_call) — clean, no broadcast yet
- [x] No payment, no approvals, no user-fund transfers anywhere in the contract
- [x] Constructor arg is the verified real Agent ID contract (live-checked:
      name "SPACE ID Agent ID", symbol "AI"; sitomo + gupron both hold 1)
- [x] No hidden instructions found in any dependency (OpenZeppelin v5.4.0,
      forge-std — standard, audited libraries)
- [ ] Deployer wallet named by Mikasa — PENDING
- [ ] Her explicit "y" on this preview — PENDING
