use sp1_build::{build_program_with_args, BuildArgs};

fn main() {
    build_program_with_args(
        "../program",
        BuildArgs {
            docker: true,
            output_directory: Some("elf".to_string()),
            ..Default::default()
        },
    )
}
