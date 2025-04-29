#[test_only]
module scratch_pad_move::hello_world_tests;

use scratch_pad_move::hello_world;

#[test]
fun test_hello_world() {
    assert!(hello_world::hello_world() == b"Hello, World!".to_string(), 0);
}