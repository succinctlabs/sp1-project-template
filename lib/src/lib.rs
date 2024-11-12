use serde::{Deserialize, Serialize};

/// The public values encoded as a struct.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PublicValuesStruct {
    pub n: u32,
    pub a: u32,
    pub b: u32,
}

/// Compute the n'th fibonacci number (wrapping around on overflows), using normal Rust code.
pub fn fibonacci(n: u32) -> (u32, u32) {
    let mut a = 0u32;
    let mut b = 1u32;
    for _ in 0..n {
        let c = a.wrapping_add(b);
        a = b;
        b = c;
    }
    (a, b)
}
