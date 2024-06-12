# SP1 Project Template

This is a template for creating an end-to-end [SP1](https://github.com/succinctlabs/sp1) project 
that can generate a proof of any RISC-V program and verify the proof onchain.

## Requirements

- [Rust](https://rustup.rs/)
- [SP1](https://succinctlabs.github.io/sp1/getting-started/install.html)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Generate Proof

**Standard Proof Generation.**

Generate the proof for your program using the standard prover.

```
cd script
RUST_LOG=info cargo run --bin prove --release
```

**EVM-Compatible Proof Generation.**

*WARNING: You will need at least 128GB of RAM to generate the proof.*

Generate the proof that is small enough to be verified on-chain and verifiable by the EVM. This command also generates a fixture that can be used to test the verification of SP1 zkVM proofs inside Solidity.

```
cd script
RUST_LOG=info cargo run --bin prove --release -- --evm
```

## Solidity Proof Verification

After generating the Verify the proof with the SP1 EVM verifier.

```
cd ../contracts
forge test -v
```

