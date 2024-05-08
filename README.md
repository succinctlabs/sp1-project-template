# SP1 Project Template

This is a template for creating an end-to-end [SP1](https://github.com/succinctlabs/sp1) project 
that can generate a proof of any RISC-V program and verify the proof onchain.

## Requirements

- [Go](https://go.dev/doc/install)
- [Rust](https://rustup.rs/)
- [SP1](https://succinctlabs.github.io/sp1/getting-started/install.html)
- [Foundry](https://book.getfoundry.sh/getting-started/installation)

## Generate Proof
```
RUST_LOG=info cargo run --package fibonacci-script --bin prove --release
```

## Export Solidity Verifier
```
RUST_LOG=info cargo run -p fibonacci-script --bin artifacts --release
```

## Solidity Proof Verification
```
cd contracts/
forge test -v
```

