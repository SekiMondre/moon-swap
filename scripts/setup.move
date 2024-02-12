script {
    use aptos_framework::resource_account;

    fun main(admin: &signer) {
        resource_account::create_resource_account(admin, b"69", b"");
    }
}
