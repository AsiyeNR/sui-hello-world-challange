module day_02::main {
    public fun sum(a: u64, b: u64): u64 {
        a + b
    }

    #[test_only]
    use std::unit_test::assert_eq;

    #[test]
    fun test_sum() {
        // Doğru kullanım: assert_eq! (ünlem ile)
        assert_eq!(sum(10, 20), 30);
    }
}