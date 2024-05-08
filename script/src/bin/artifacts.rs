//! Builds the proving artifacts and exports the solidity verifier.
//!
//! You can run this script using the following command:
//! ```shell
//! RUST_LOG=info cargo run --package fibonacci-script --bin artifacts --release
//! ```

use std::path::PathBuf;

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
