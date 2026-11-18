# Agent ID Badge

A free-mint commemorative ERC-721 NFT, mintable **only by holders of an Agent ID**
(the on-chain name of a Binance Agentic Wallet, e.g. `name.ai`).

Built for the **Binance Agent ID Hackathon** (submissions 18 Nov – 9 Dec 2026).

## What it is

- **Free mint** — price 0, you only pay network gas. One badge per wallet.
- **Max supply:** 1000, first-come-first-served.
- **Fully on-chain metadata** — the tokenURI is a `data:` URI with an on-chain SVG
  badge (gold on dark). No IPFS or external server dependency.
- **No promises** — this badge makes no promise of value, returns, or profit.
  It is a commemorative collectible for Agent ID holders.

## How Agent ID is used

The contract stores the Agent ID contract address (immutable, set at deploy time)
and gates minting on it:

```solidity
if (IAgentID(agentIdContract).balanceOf(msg.sender) == 0) revert NotAgentIDHolder();
```

- Mainnet Agent ID contract: `0x60b9262456de011f7d15a54cdd8c48baaa8b022f`
  (SPACE ID Agent ID, ERC-721, non-transferable). Holder status is checked with
  `balanceOf(address) > 0`.
- There is no Agent ID deployment on BSC testnet, so testnet uses
  `src/MockAgentID.sol` — a minimal `balanceOf` stand-in. **Never use the mock
  as the gate on mainnet.**

## Owner powers (minimal, by design)

The contract owner can only **pause / unpause** minting (e.g. to stop a broken
mint flow). There is no withdraw function (the contract never holds funds —
minting is free), no allowlist management, no supply changes, no metadata
changes, and no `setApprovalForAll` anywhere.

## Deployments

### BSC testnet (live)

| Contract | Address |
|---|---|
| AgentIDBadge | [0xBB4Dd413289Bc63D6EF56b0160Fb59A3557aa613](https://testnet.bscscan.com/address/0xBB4Dd413289Bc63D6EF56b0160Fb59A3557aa613) |
| MockAgentID (testnet stand-in) | [0x90940dA3Bfcb4b5474C2Df738416c919b93dfee5](https://testnet.bscscan.com/address/0x90940dA3Bfcb4b5474C2Df738416c919b93dfee5) |

Both contracts are source-verified on Sourcify (Badge: exact match).
Mint website: https://sipalingtesnet.github.io/agent-id-badge/

Testnet mint tx (first mint, token #1):
[0x6a50981b660cf57bc282e059766cf3456d8640fb0bde1507776afdb90c74bf21](https://testnet.bscscan.com/tx/0x6a50981b660cf57bc282e059766cf3456d8640fb0bde1507776afdb90c74bf21)

### BNB Chain mainnet

Not deployed yet. See `MAINNET_DEPLOY_PREVIEW.md` for the exact deployment
preview (contract, constructor args, estimated gas + cost). Mainnet deployment
happens only after explicit approval of that preview.

## Develop

Requires [Foundry](https://getfoundry.sh/).

```bash
forge install        # installs OpenZeppelin Contracts v5.4.0
forge build
forge test           # 13 tests
```

Testnet deploy (needs a funded testnet key — test funds only):

```bash
forge script script/Deploy.s.sol --rpc-url https://data-seed-prebsc-1-s1.bnbchain.org:8545 \
  --private-key $TESTNET_KEY --broadcast --gas-price 3000000000
```

## License

MIT. OpenZeppelin Contracts v5.4.0 (MIT).
