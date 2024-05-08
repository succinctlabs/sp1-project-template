use std::path::PathBuf;

pub const FIBONACCI_ELF: &[u8] = include_bytes!("../../../program/elf/riscv32im-succinct-zkvm-elf");

/// Builds the proving artifacts from scratch and exports the solidity verifier.
fn main() {
    sp1_sdk::utils::setup_logger();

    tracing::info!("building groth16 artifacts");
    let artifacts_dir = sp1_sdk::artifacts::get_groth16_artifacts_dir();
    sp1_sdk::artifacts::build_groth16_artifacts_with_dummy(artifacts_dir);

    tracing::info!("exporting groth16 verifier");
    let contracts_src_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR")).join("../contracts/src");
    sp1_sdk::artifacts::export_solidity_groth16_verifier(contracts_src_dir)
        .expect("failed to export verifier");
}
