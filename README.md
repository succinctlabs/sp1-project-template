# SP1 Project Template

This is a template for creating an end-to-end [SP1](https://github.com/succinctlabs/sp1) project 
that can generate a proof of any RISC-V program and verify the proof onchain.

## Requirements

- [Go](https://go.dev/doc/install)
- [Rust](https://rustup.rs/)
- [SP1](https://succinctlabs.github.io/sp1/getting-started/install.html)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Generate Proof

Generate the proof that will be used as a fixture in the contracts directory.

```
cd script
RUST_LOG=info cargo run --bin prove --release
```

## Solidity Proof Verification

Verify the proof with the SP1 EVM verifier.

```
cd ../contracts
forge test -v
```

