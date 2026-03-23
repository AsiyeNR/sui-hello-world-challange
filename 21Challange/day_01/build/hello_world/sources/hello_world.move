module hello_world::hello_world {
    use std::string;
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    // Yönergedeki Constant'lar
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
        
        // Bu satırlar sabitleri kullandığımızı gösterir, build hatasını engeller
        let _unused_1 = NUMBER;
        let _unused_2 = FLAG;
        let _unused_3 = MY_ADDRESS;

        transfer::public_transfer(object, tx_context::sender(ctx));
    }
}