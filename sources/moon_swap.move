module moon_swap::moon_swap {

    use std::signer;
    use std::string;
    use aptos_framework::account;
    use aptos_framework::resource_account;
    use aptos_framework::coin::{Self, Coin};
    // use aptos_framework::timestamp;

    struct LPToken<phantom X, phantom Y> {}

    struct LiquidityPool<phantom X, phantom Y> has key {
        reserve_x: Coin<X>,
        reserve_y: Coin<Y>,
        mint_cap: coin::MintCapability<LPToken<X,Y>>,
        burn_cap: coin::BurnCapability<LPToken<X,Y>>,
    }

    struct SwapInfo has key {
        signer_cap: account::SignerCapability
    }

    const ERROR_GENERIC: u64 = 9999;

    fun init_module(admin: &signer) {
        let sign_cap = resource_account::retrieve_resource_account_cap(admin, @moon_swap);
        let config = SwapInfo {
            signer_cap: sign_cap
        };
        move_to(admin, config);
    }

    public fun start_liquidity_Pool<X,Y>() acquires SwapInfo {
        assert!(coin::is_coin_initialized<X>() && coin::is_coin_initialized<Y>(), ERROR_GENERIC);

        let info = borrow_global_mut<SwapInfo>(@moon_swap_resource);
        let resource_account = account::create_signer_with_capability(&info.signer_cap);
        let resource_address = account::get_signer_capability_address(&info.signer_cap);

        assert!(!exists<LiquidityPool<X,Y>>(resource_address), ERROR_GENERIC);

        coin::register<LPToken<X,Y>>(&resource_account);

        // TODO: make names from X,Y types
        let name = string::utf8(b"<SAMPLE NAME>");
        let symbol = string::utf8(b"TKX-TKY");

        let (burn_cap, freeze_cap, mint_cap) = coin::initialize<LPToken<X,Y>>(
            &resource_account,
            name,
            symbol,
            8, // declare constant?
            true
        );
        coin::destroy_freeze_cap(freeze_cap);

        let lp = LiquidityPool {
            reserve_x: coin::zero<X>(),
            reserve_y: coin::zero<Y>(),
            mint_cap,
            burn_cap,
        };
        move_to(&resource_account, lp);
    }

    // deposit

    // redeem

    // swap

    #[test_only]
    use std::debug;

    #[test(admin = @moon_swap, resource_account = @moon_swap_resource)]
    fun test_init(admin: &signer, resource_account: &signer) acquires SwapInfo {
        let admin_address = signer::address_of(admin);
        account::create_account_for_test(admin_address);

        resource_account::create_resource_account(admin, b"69", b"");
        init_module(resource_account);

        let info = borrow_global<SwapInfo>(@moon_swap_resource);
        assert!(account::get_signer_capability_address(&info.signer_cap) == @moon_swap_resource, ERROR_GENERIC);
    }
}