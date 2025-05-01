#[test_only]
module scratch_pad_move::limits_tests;

use std::debug;

// Exploring some of the Move limits
// https://move-book.com/guides/building-against-limits.html

/// sui move test test_vector_limits
/// 
/// The test shows that vector length is not affected by the size of the item.
/// 
/// This is not the case for other implementations - Initia results are:
/// 1_249_993 & 624_996 for u64 and u128 respectively
/// 
/// So take these limits with a grain of salt and check them for each chain.
/// 
#[test]
fun test_vector_limits() {
  let mut vec = vector::empty<u64>();
  let mut i: u64 = 0;
  loop {
      vector::push_back(&mut vec, i);
      debug::print(&i);
      i = i + 1;
  }
  // when i is u64,  max num   98_586
  // when i is u128, max num   98_586
}
