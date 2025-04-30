#[test_only]
module scratch_pad_move::transfer_to_sender_tests;

use scratch_pad_move::transfer_to_sender::{ AdminCap, Gift, init_module_test, transfer_admin_cap, mint_and_transfer};
use sui::test_scenario;

#[test]
fun test_init_and_transfer() {
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

    test_scenario::next_tx(&mut scenario, user);
    {
        // Verify user doesn't have an AdminCap
        assert!(!test_scenario::has_most_recent_for_sender<AdminCap>(&scenario), 0);

        // This is not a valid scenario, because it bypasses normal ownership rules
        // In the real world user will never have admin cap unless admin gives it to them
        // let admin_cap = test_scenario::take_from_address<AdminCap>(&scenario, admin);
        // transfer_admin_cap(admin_cap, user);
    };

    test_scenario::next_tx(&mut scenario, admin);
    {
        // Verify that the admin has the AdminCap, therefore take_from_address is not a violation
        assert!(test_scenario::has_most_recent_for_sender<AdminCap>(&scenario), 0);

        // Transfer admin cap to user
        let admin_cap = test_scenario::take_from_address<AdminCap>(&scenario, admin);
        transfer_admin_cap(admin_cap, user);
    };

    test_scenario::next_tx(&mut scenario, user);
    {
        // Sender (user) has the admin cap
        assert!(test_scenario::has_most_recent_for_sender<AdminCap>(&scenario), 0);

        // Admin doesn't have the admin cap
        assert!(!test_scenario::has_most_recent_for_address<AdminCap>(admin), 0);

        let admin_cap = test_scenario::take_from_sender<AdminCap>(&scenario);

        let ctx = test_scenario::ctx(&mut scenario);
        mint_and_transfer(&admin_cap, admin, ctx);

        // Return the admin_cap to the sender
        // We need to return the admin cap back from where we got it - hot potato
        test_scenario::return_to_sender(&scenario, admin_cap);
    };

    test_scenario::next_tx(&mut scenario, admin);
    {
        assert!(test_scenario::has_most_recent_for_sender<Gift>(&scenario), 0);
        assert!(!test_scenario::has_most_recent_for_address<Gift>(user), 0);
    };

    test_scenario::end(scenario);
}
