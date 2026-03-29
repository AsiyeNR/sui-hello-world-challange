module day_06::habit_tracker {
    use std::string::{Self, String};
    use std::vector;

    // --- Structlar ---
    public struct Habit has drop {
        name: String,        // String tipini kullanıyoruz
        completed: bool,
    }

    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    // --- Fonksiyonlar ---
    public fun empty_list(): HabitList {
        HabitList { habits: vector::empty<Habit>() }
    }

    // String kabul eden constructor
    public fun new_habit(name: String): Habit {
        Habit { name, completed: false }
    }

    // ⭐ GÜN 6 ÖDEVİ: Byte'ları String'e çeviren yardımcı fonksiyon
    public fun make_habit(bytes: vector<u8>): Habit {
        let name_as_string = string::utf8(bytes);
        new_habit(name_as_string)
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    // --- Unit Test ---
    #[test]
    fun test_string_logic() {
        let mut list = empty_list();
        // Ham byte'ları (vector<u8>) String'e dönüştürüp ekliyoruz
        let h = make_habit(b"Ubuntu Terminaliyle Move!");
        add_habit(&mut list, h);

        assert!(vector::length(&list.habits) == 1, 0);
    }
}
