module game::gameFaucet {
    use sui::coin::{Self, TreasuryCap};
    use sui::tx_context::{Self, TxContext};
    use sui::transfer;
    use sui::object::{Self, UID};
    use std::option;

    public struct GAMEFAUCET has drop {}

    public struct TreasuryCapHolder has key, store {
        id: UID,
        treasury_cap: TreasuryCap<GAMEFAUCET>,
    }

    // otw = One-time witness,确保只能在init初始化调用一次，同时结构体只有drop能力
    fun init(otw: GAMEFAUCET, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency(
            otw,
            6,
            b"potato89757_faucet",
            b"fanshuF",
            b"potato is fanshu yeah :3",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metadata);

        let treasury_cap_holder = TreasuryCapHolder {
            id: object::new(ctx),
            treasury_cap,
        };
        transfer::share_object(treasury_cap_holder);
    }

    public entry fun mint(treasury: &mut TreasuryCapHolder, amount: u64, ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);
        let treasury_cap = &mut treasury.treasury_cap;
        let coin = coin::mint(treasury_cap, amount, ctx); // mint代币
        transfer::public_transfer(coin, sender); // 转移至指定地址
    }
}