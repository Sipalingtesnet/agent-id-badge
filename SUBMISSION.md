# SUBMISSION — Agent ID Badge (Binance Agent ID Hackathon)

Submission period: 18 Nov – 9 Dec 2026, 15:00 WIB.
Form fields below match the official project submission form.

## 1. Project Name

Agent ID Badge

## 2. Project Overview

Agent ID Badge is a free-mint commemorative NFT for holders of an Agent ID.
Anyone holding an Agent ID can mint one badge for free (gas only), one per
wallet, from a 1000-piece supply. The badge artwork and metadata live fully
on-chain as an SVG data URI, so the collectible survives with no server or
IPFS dependency.

## 3. Project Contract Address(es)

- **Mainnet: TBD — fills in after mainnet deployment**
  (see `MAINNET_DEPLOY_PREVIEW.md`; deploy only after explicit approval).
- **BSC testnet (live now):**
  `0xBB4Dd413289Bc63D6EF56b0160Fb59A3557aa613`
  — https://testnet.bscscan.com/address/0xBB4Dd413289Bc63D6EF56b0160Fb59A3557aa613
  — source verified on Sourcify (exact match).
- Testnet Agent ID stand-in (mock, testnet only):
  `0x90940dA3Bfcb4b5474C2Df738416c919b93dfee5`

## 4. Project Website / Product Access

- Mint website: https://sipalingtesnet.github.io/agent-id-badge/
  (currently pointed at the BSC testnet deployment; switches to mainnet
  addresses after mainnet deployment)
- Source code: https://github.com/Sipalingtesnet/agent-id-badge
- Testnet mint tx (token #1):
  https://testnet.bscscan.com/tx/0x6a50981b660cf57bc282e059766cf3456d8640fb0bde1507776afdb90c74bf21

## 5. Agent ID Usage Description

Agent ID is the project's **access control**. The `AgentIDBadge` contract
stores the Agent ID contract address immutably at deployment and checks it
on every mint:

```solidity
if (IAgentID(agentIdContract).balanceOf(msg.sender) == 0) revert NotAgentIDHolder();
```

Only wallets holding an Agent ID (`balanceOf > 0` on the SPACE ID Agent ID
contract `0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F`) can mint, one badge
per wallet, up to a 1000 supply. The mint website performs the same
`balanceOf` check before showing the mint button, so non-holders never reach
the transaction. Agent ID is therefore not a label on the project — it is
the gate that decides who can use it.

## Notes for the submission form

- No "Binance" branding is used in the project name, token name, or domain.
- The project promises no returns, value, or profit anywhere (contract
  metadata, website, and README all state this explicitly).
- No QR-code / pairing-code login anywhere: the website uses only the
  browser's injected wallet provider (window.ethereum).
- Owner powers are minimal and documented: pause/unpause minting only.
  No withdraw, no allowlist, no supply/metadata changes, no approvals.
- Tests: 13/13 Foundry tests pass (holder mint OK, non-holder reverts,
  double-mint reverts, supply cap enforced, pause works, tokenURI valid).
