## Fund Me (Foundry)

Small ETH crowdfunding contract that enforces a USD-denominated minimum using Chainlink price data. Built, tested, and scripted with Foundry.

### Architecture
- `src/FundMe.sol`: main contract with `PriceConverter` and Chainlink feed support.
- `script/DeployFundMe.s.sol`: deploys with a mock aggregator on Anvil or the Sepolia feed.
- `script/Interactions.s.sol`: funds the most recent deployment via DevOpsTools.
- Tests:
  - Unit: `test/unit test/FundMeTest.t.sol`
  - Integration: `test/Integration test/Interaction.t.sol`

### Prerequisites
- Foundry toolchain (`forge`, `anvil`, `cast`)
- `.env` for live deployments (e.g. `SEPOLIA_RPC_URL`, `PRIVATE_KEY`)

### Quickstart
- Build: `forge build`
- Test (unit + integration): `forge test`
- Local node: `anvil`

### Deploy
- Anvil (mock feed): `forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url http://localhost:8545 --private-key $ANVIL_PRIVATE_KEY --broadcast`
- Sepolia: `forge script script/DeployFundMe.s.sol:DeployFundMe --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast`

### Interact
- Fund last deployment (Anvil): `forge script script/Interactions.s.sol:FundFundMe --rpc-url http://localhost:8545 --private-key $ANVIL_PRIVATE_KEY --broadcast`
- The script uses `broadcast/DeployFundMe.s.sol/<chainid>/run-latest.json` to find the target address; `fs_permissions` in `foundry.toml` enable this read.

### Notes
- Broadcaster behavior: when `vm.startBroadcast` is used, the broadcaster address (not the test contract or prank address) pays and is recorded as the caller unless explicitly set.
- Minimum contribution is enforced in USD terms using the configured price feed; the mock aggregator price is set in `script/HelperConfig.s.sol`.
