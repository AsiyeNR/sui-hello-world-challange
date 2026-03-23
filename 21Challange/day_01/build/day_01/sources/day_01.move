module challange::day_01 {
    use std::string;

    const NUMBER: u64 = 42;
    const FLAG: bool = true;
    const MY_ADDRESS: address = @0x1;

    public struct HelloWorldObject has key, store {
        id: UID,
        text: string::String
    }

    public entry fun mint(ctx: &mut TxContext) {
        let object = HelloWorldObject {
            id: object::new(ctx),
            text: string::utf8(b"Hello World!")
        };
        let _ = NUMBER; let _ = FLAG; let _ = MY_ADDRESS;
        transfer::public_transfer(object, tx_context::sender(ctx));
    }
}
