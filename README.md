This repo is for researching Move and Sui.

It follows loosely the guides from 
- [Move book](https://move-book.com/index.html)
- [Sui docs](https://docs.sui.io/)

# Setup

To build the project run
```bash
sui move build
```

To run the tests
```bash
sui move test
```

Other variants of executing tests
```bash
# from an outside folder
sui move test --path ./path/to/project/scratch_pad_move

# running single test
sui move test test_hello
```

# Local network environment

Deploy and test on a local network. Full instructions [here](https://move-book.com/your-first-move/hello-sui.html#set-up-an-account).

```bash
RUST_LOG="off,sui_node=info" sui start --with-faucet --force-regenesis
```

#### Setting up `sui client` and working with the network 

```bash
sui client
y
http://127.0.0.1:9000
localnet
0
```

Getting coins from faucet
```bash
# --json for differently formatted output

sui client faucet
sui client balance
# or query objects owner by your account
sui client objects
```

Deploy / publish a package on the network

```bash
# --gas-budget max gas we're willing to spend, not mandatory

# run this from the `todo_list` folder
$ sui client publish --gas-budget 100000000

# alternatively, you can specify path to the package
$ sui client publish --gas-budget 100000000 /path/to/package
```

Interacting with a package. See `Published Objects` log from publishing command above.

```bash
export PACKAGE_ID=0x39c60e2b68a7e893b30fbdeee50383d9c7f510688b40fff04fd9fe166d059aaa
export MY_ADDRESS=$(sui client active-address)

sui client ptb \
--gas-budget 100000000 \
--assign sender @$MY_ADDRESS \
--move-call $PACKAGE_ID::todo_list::new \
--assign list \
--transfer-objects "[list]" sender

# --assign we assign 'sender' the currently active address
# --move-call call "new" function, it returns a value
# --assign we assign the value to list
# --transfer-objects we transfer list to the sender, ownership transfer

# NB: These operations would usually be part of a smart contract, but in Move we can manipulate objects we own freely
```

Now you can interact with the list object.
```bash
# find it by running
# look for: objectType │  0x39c6..9aaa::todo_list::TodoList
sui client objects

# export it for ease of use
export LIST_ID=0x70398336ca52e941589df80fe11b0dd9f471f0ba72d5aea28f0dc3d247728ea4

# run
sui client ptb \
--move-call $PACKAGE_ID::todo_list::add @$LIST_ID "'Finish the Hello, Sui chapter'"

# query the list object directly 
sui client object $LIST_ID

# you can chain commands
sui client ptb \
--move-call $PACKAGE_ID::todo_list::add @$LIST_ID "'Finish Concepts chapter'" \
--move-call $PACKAGE_ID::todo_list::add @$LIST_ID "'Read the Move Basics chapter'" \
--move-call $PACKAGE_ID::todo_list::add @$LIST_ID "'Learn about Object Model'" \
--move-call $PACKAGE_ID::todo_list::remove @$LIST_ID 0
```
