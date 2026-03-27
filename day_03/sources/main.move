module day_03::habit_tracker {
    // Habit yapısı (Struct)
    public struct Habit has drop {
        name: vector<u8>,
        completed: bool,
    }

    // Yeni bir Habit oluşturan fonksiyon (Constructor)
    public fun new_habit(name: vector<u8>): Habit {
        Habit {
            name: name,
            completed: false,
        }
    }

    // --- Unit Test ---
    #[test_only]
    use std::unit_test::assert_eq;

    #[test]
    fun test_habit() {
        let h = new_habit(b"Su Ic");
        assert_eq!(h.completed, false);
    }
}
