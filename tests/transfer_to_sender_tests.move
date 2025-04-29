#[test_only]
module scratch_pad_move::transfer_to_sender_tests;

use scratch_pad_move::transfer_to_sender;
use sui::test_scenario;

#[test]
fun test_init() {
    // Create test addresses
    let admin = @0xA;

    // Start testing scenario with admin as the sender
    let mut scenario = test_scenario::begin(admin);
    {
        // Call init function with the test context
        let ctx = test_scenario::ctx(&mut scenario);
        transfer_to_sender::init_module_test(ctx);
    };

    test_scenario::end(scenario);
}
