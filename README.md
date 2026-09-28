## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```





gian@gian:/mnt/c/Users/gianp/OneDrive/Escritorio/Semestre_8/TechFreedom/Lab12/lab12-class-vesting$ forge script script/DeployClassVesting.s.sol:DeployClassVesting \
  --rpc-url $RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast
[⠔] Compiling...
[⠊] Compiling 1 files with Solc 0.8.36
[⠒] Solc 0.8.36 finished in 388.48ms
Compiler run successful!
Script ran successfully.

== Logs ==
  Token: 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
  Vesting: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
  Vesting token balance: 7000

## Setting up 1 EVM.

==========================

Chain 31337

Estimated max fee per gas: 2.000000001 gwei
Estimated base fee per gas: 1 gwei
Estimated max priority fee per gas: 0.000000001 gwei

Estimated total gas used for script: 1475046

Estimated amount required: 0.002950092001475046 ETH

==========================
                                                                                                      ##### anvil-hardhat                                                                                   ✅  [Success] Hash: 0x3e67b9ab7b9634a6f62d3f2c55df9874495d9581ef05419d5c43f706d1b6a74f                Contract: ClassToken                                                                                  Contract Address: 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9                                          Block: 2                                                                                              
Paid: 0.00048133493674601 ETH (544246 gas * 0.884406935 gwei)                                         
                                                                                                      
                                                                                                      ##### anvil-hardhat                                                                                   ✅  [Success] Hash: 0x701afe1993e2ee154bba26f88976b1d16e77bd8c4fc681af4804b522d6107b3c                Contract: ClassToken                                                                                  Function: transfer(address,uint256)                                                                   
Contract Address: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9                                          
Block: 2                                                                                              
Paid: 0.000475642009305415 ETH (537809 gas * 0.884406935 gwei)                                        
                                                                                                      
                                                                                                      ##### anvil-hardhat                                                                                   ✅  [Success] Hash: 0x0f317be767b27faa99ca7b9a4471fe95e2fa3209b2c5f295be1a6c208487b794                Contract: ClassVesting                                                                                
Block: 2                                                                                              
Paid: 0.000041348677432055 ETH (46753 gas * 0.884406935 gwei)                                         Paid: 0.000041348677432055 ETH (46753 gas * 0.884406935 gwei)                                         Paid: 0.000041348677432055 ETH (46753 gas * 0.884406935 gwei)                                         Paid: 0.000041348677432055 ETH (46753 gas * 0.884406935 gwei)                                         Paid: 0.000041348677432055 ETH (46753 gas * 0.884406935 gwei)                                         Paid: 0.000041348677432055 ETH (46753 gas * 0.884406935 gwei)                                                                                                                                               ✅ Sequence #1 on anvil-hardhat | Total Paid: 0.00099832562348348 ETH (1128808 gas * avg 0.884406935 gwei)                                                                                                  


==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.

Transactions saved to: /mnt/c/Users/gianp/OneDrive/Escritorio/Semestre_8/TechFreedom/Lab12/lab12-class-vesting/broadcast/DeployClassVesting.s.sol/31337/run-latest.json

Sensitive values saved to: /mnt/c/Users/gianp/OneDrive/Escritorio/Semestre_8/TechFreedom/Lab12/lab12-class-vesting/cache/DeployClassVesting.s.sol/31337/run-latest.json

