#[test_only]
module scratch_pad_move::transfer_to_sender_tests;

use scratch_pad_move::transfer_to_sender::{ AdminCap, init_module_test, transfer_admin_cap};
use sui::test_scenario;

#[test]
fun test_init() {
    // Create test addresses
    let admin = @0xA;
    let user = @0xB;

    // Start testing scenario with admin as the sender
    let mut scenario = test_scenario::begin(admin);
    {
        // Call init function with the test context
        let ctx = test_scenario::ctx(&mut scenario);
        init_module_test(ctx);
        
    };

    test_scenario::next_tx(&mut scenario, admin);
    {
        // Verify that the admin received an AdminCap
        assert!(test_scenario::has_most_recent_for_sender<AdminCap>(&scenario), 0);
    };

    test_scenario::next_tx(&mut scenario, user);
    {
        // Verify user doesn't have an AdminCap
        assert!(!test_scenario::has_most_recent_for_sender<AdminCap>(&scenario), 0);

        // This is not a valid scenario, because it bypasses normal ownership rules
        // In the real world user will never have admin cap unless admin gives it to them
        // let admin_cap = test_scenario::take_from_address<AdminCap>(&scenario, admin);
        // transfer_admin_cap(admin_cap, user);
    };

    test_scenario::end(scenario);
}
