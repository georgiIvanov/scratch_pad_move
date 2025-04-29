module scratch_pad_move::transfer_to_sender;

use sui::transfer::transfer;

/// A struct with `key` is an object. The first field is `id: UID`!
/// Owner of this object is considered admin
/// Cap comes from capability
public struct AdminCap has key { id: UID }

/// Some `Gift` object that the admin can `mint_and_transfer`.
public struct Gift has key { id: UID }

// called when module is published; similar to constructor
fun init(ctx: &mut TxContext) {
  
  let admin_cap = AdminCap { id: object::new(ctx) };
  
  transfer(admin_cap, ctx.sender());

}

/// Transfers the `AdminCap` object to the `recipient`. Thus, the recipient
/// becomes the owner of the object, and only they can access it. Essentially, they become admin.
public fun transfer_admin_cap(cap: AdminCap, recipient: address) {
  transfer(cap, recipient);
}

/// Creates a new `Gift` object and transfers it to the `recipient`.
public fun mint_and_transfer(
    _: &AdminCap, recipient: address, ctx: &mut TxContext
) {
    let gift = Gift { id: object::new(ctx) };
    transfer::transfer(gift, recipient);
}

