/// Module: task1
module task1::hello {
  use std::ascii::{String, string};
  use sui::transfer::transfer;
  use sui::tx_context::{sender};

  public struct Hello has key {
    id: UID,
    say: String,
  }

  fun init(ctx: &mut TxContext) {
    let hello_move = Hello {
      id: object::new(ctx),
      say: string(b"imdia"),
    };
    transfer(hello_move, sender(ctx));
  }
}
