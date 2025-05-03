This file contains some additional notes around Move / Sui

> Relevant stuff that didn't make it into the readme.md

### Sui
- 1 SUI equals 10^9 MISTs
- maximum gas budget is [50 billion MIST or 50 SUI](https://docs.sui.io/concepts/tokenomics/gas-in-sui)

### Move
- [Move limits](https://move-book.com/guides/building-against-limits.html) - obj size 250KB, tx size - 128KB
- Addresses are fixed **32 bytes** hex string and used to identify [packages](https://move-book.com/concepts/packages.html), [accounts](https://move-book.com/concepts/what-is-an-account.html), and [objects](https://move-book.com/object/index.html)
	- some [addresses are reserved](https://move-book.com/appendix/reserved-addresses.html) for system packages / objects
- [Package](https://move-book.com/concepts/packages.html) is a Sui program, it can contain multiple modules
- Modules can be considered separate smart-contracts
- [Transaction](https://move-book.com/concepts/what-is-a-transaction.html) in move, it may contain multiple commands 
- Move is used on many blockchains - Sui, Aptos, Initia
	- They can all have different flavors
	- Aptos: [move-stdlib](https://github.com/aptos-labs/aptos-core/blob/main/aptos-move/framework/move-stdlib/doc/overview.md), [aptos-stdlib](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework/aptos-stdlib/doc), [aptos-framework](https://github.com/aptos-labs/aptos-core/tree/main/aptos-move/framework/aptos-framework/doc) - chain-specific 
-  [Differences between](https://move-book.com/guides/2024-migration-guide.html) Move 2020 and Move 2024

Basic Move
- [move-language](https://move-language.github.io/move) - alternative to move-book.com, has more syntax details
- [Move](https://move-book.com/move-basics/index.html) basics - only the language
	- over / undeflows raise a runtime error
	- you can have named address registered in Move.toml `let value = @std`
	- [type conversions](https://move-book.com/move-basics/address.html#conversion)
	- [abilities](https://move-book.com/move-basics/abilities-introduction.html) - traits in rust?
		- copy - allows copy
		- drop - allows struct to be discarded
		- [key](https://move-book.com/storage/key-ability.html) - allows the struct to be used as a _key_ in a storage
		- [store](https://move-book.com/storage/store-ability.html) - allows the struct to be _stored_ in structs that have the _key_ ability
	- [debug module](https://docs.sui.io/references/framework/std/debug) docs
	- [using a debugger](https://docs.sui.io/references/ide/debugger) 
	- `abort(u64)` reverts a tx
	- `assert` == `require` in solidity
	- errors can be `u64` or `vector<u8>`, see [error messages](https://move-book.com/move-basics/assert-and-abort.html#error-messages)
	- [visibility](https://move-book.com/move-basics/visibility.html) - private, package (private for pkg), public
	- [Phantom Type Parameters](https://move-book.com/move-basics/generics.html#phantom-type-parameters) - used to differentiate between types - `Coin<USDC>` vs `Coin<EUR>`
	- [type reflection](https://move-book.com/move-basics/type-reflection.html#type-reflection) - name, module, address of a type
	- [testing](https://move-book.com/move-basics/testing.html) - expected_failure attribute

### Object Model / Storage in Sui
- An object has: Type (defining structure and behaviour), Unique ID, Owner, Data, Version (nonce), Digest - calculated when the object is created and is updated whenever the object's data changes
- **[4 types of ownership](https://move-book.com/object/ownership.html)** - 
	- single - one owner, exclusive control; account owned
	- shared - can be modified by anyone, rules of interaction are defined by the implementation
	- immutable - _frozen object_ model, read-only constant state
	- object-owner - object is owned by another object
- [UID and ID](https://move-book.com/storage/uid-and-id.html#uid-and-id) - ID is a pointer to an address, UID wraps ID and is a unique identifier of an object.


### Advanced Move
- hot potato pattern
	- structs that don't have `drop` ability need to be unpacked or the TX will abort due to unused value without drop
	- this allows for a struct to be passed between modules, but in the end it has to be returned back to its creator because only they can unpack it. essentially a borrowed value must be returned back.
	- A hot potato is a struct without abilities, it must come with a way to create and destroy it.
	- Hot potatoes are used to ensure that some action is taken before the transaction ends, similar to a callback, like flashloan.
- [config pattern](https://move-book.com/move-basics/constants.html#using-config-pattern) - expose constants through public fns
- [`TxContext`](https://move-book.com/programmability/transaction-context.html)
- [Pattern: Capability](https://move-book.com/programmability/capability.html#pattern-capability) - overall recommendation is to use capabilities over address check for sender
- [Dynamic Fields](https://move-book.com/programmability/dynamic-fields.html) - `dynamic_field` api to attach objects 
- [Witness](https://move-book.com/programmability/witness-pattern.html#instantiating-a-generic-type) allows generic types to be instantiated with a concrete type. Witness is often used for generic type instantiation and authorization
- While a struct can be created any number of times, there are cases where a struct should be guaranteed to be created only once. For this purpose, Sui provides the [One-Time Witness](https://move-book.com/programmability/one-time-witness.html) - a special witness that can only be used once.


### General Sui links
- Uses? [RocksDB](https://medium.com/walmartglobaltech/https-medium-com-kharekartik-rocksdb-and-embedded-databases-1a0f8e6ea74f) ? ([overview](https://github.com/facebook/rocksdb/wiki/RocksDB-Overview)) for its [storage management](https://docs.sui.io/guides/operator/data-management)
- [Developer Cheat Sheet](https://docs.sui.io/guides/developer/dev-cheat-sheet) 
- [Official repo](https://github.com/MystenLabs/sui)
- [Docs](https://docs.sui.io/) 
- Supports [On-Chain Randomness](https://docs.sui.io/guides/developer/advanced/randomness-onchain)
	- Careful, there are some unique attack vectors

### Aptos Move
- [Docs](https://aptos.dev/en/build/smart-contracts)
- Find more about aptos [specific types](https://aptos.dev/en/build/smart-contracts/move-reference?page=aptos-framework%2Fdoc%2Fobject.md) - aptos-framework and std-lib

### Initia
 - [initia_stdlib](https://github.com/initia-labs/movevm/tree/bf81d0d40e1514d308b3f5063ad37efa18bfac4d/precompile/modules/initia_stdlib) / doc - repo
 - uses Move 2020
 - Forked from Aptos