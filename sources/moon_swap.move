module moon_swap::moon_swap {

    use std::signer;
    use std::string;
    use aptos_framework::account;
    use aptos_framework::resource_account;
    // use aptos_framework::timestamp;

    struct LPToken<phantom X, phantom Y> {}

    struct LiquidityPool<X, Y> {
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

    // make pool

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