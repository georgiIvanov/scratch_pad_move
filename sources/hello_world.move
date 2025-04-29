/// The module `scratch_pad_move` under named address `scratch_pad_move`.
/// The named address is set in the `Move.toml`.
module scratch_pad_move::hello_world;

// Imports the `String` type from the Standard Library
use std::string::String;

/// Returns the "Hello, World!" as a `String`.
public fun hello_world(): String {
    b"Hello, World!".to_string()
}
