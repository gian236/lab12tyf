# Lab 12 — Class Vesting

Vesting de clase para CS031 Technology & Freedom. El token usa `decimals() = 0`, por lo que los valores del laboratorio son literales.

## Economía

- Supply total: `7000` CS031.
- Beneficiarios: 7, con `1000` tokens por wallet.
- Cliff: `1790186400`; libera `100` tokens.
- Vesting lineal: `900` tokens durante `86400` segundos.
- Final: `1790272800`.

`claim()` siempre usa `msg.sender`; una cuenta no registrada no puede retirar tokens de otra cuenta.

## Arquitectura

`ClassToken` es un ERC-20 de OpenZeppelin v5. `ClassVesting` registra una allocation por beneficiary, calcula el saldo liberado y transfiere solamente el saldo reclamable. El script despliega el token, despliega el vesting y deposita los `7000` tokens.

## Tests

```bash
forge test -vv
forge test --gas-report
```

La suite cubre supply, funding, allocations, cliff, linealidad, claims parciales y posteriores, final, claims-only-own, no beneficiarios, duplicados y suma total.

## Deploy local

Con Anvil ejecutándose en `http://127.0.0.1:8545`:

```bash
forge script script/DeployClassVesting.s.sol:DeployClassVesting \
  --rpc-url http://127.0.0.1:8545 \
  --private-key "$ANVIL_PRIVATE_KEY" \
  --broadcast
```

No se guardan private keys en el repositorio. Para Sepolia:

```bash
forge script script/DeployClassVesting.s.sol:DeployClassVesting \
  --rpc-url "$SEPOLIA_RPC_URL" --private-key "$SEPOLIA_PRIVATE_KEY" \
  --broadcast --verify
```

## Deploy local conocido

- Token: `0x5FbDB2315678afecb367f032d93F642f64180aa3`
- Vesting: `0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512`
- Chain ID: `31337`

Comprobaciones:

```bash
cast call "$VESTING" "allocationOf(address)(uint256)" "$BENEFICIARY" --rpc-url http://127.0.0.1:8545
cast call "$VESTING" "releasable(address)(uint256)" "$BENEFICIARY" --rpc-url http://127.0.0.1:8545
cast send "$VESTING" "claim()" --rpc-url http://127.0.0.1:8545 --private-key "$BENEFICIARY_PRIVATE_KEY"
cast call "$TOKEN" "balanceOf(address)(uint256)" "$BENEFICIARY" --rpc-url http://127.0.0.1:8545
cast call "$VESTING" "claimedOf(address)(uint256)" "$BENEFICIARY" --rpc-url http://127.0.0.1:8545
```

Al final del vesting, la beneficiary utilizada en la prueba local recibió `1000` y `claimedOf` quedó en `1000`. El transaction hash depende de la sesión de Anvil activa y debe capturarse al ejecutar el `cast send`.
