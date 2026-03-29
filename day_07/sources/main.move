module day_07::habit_tracker {
    use std::string::{Self, String};
    use std::vector;

    // --- Structlar ---
    public struct Habit has drop {
        name: String,
        completed: bool,
    }

    public struct HabitList has drop {
        habits: vector<Habit>,
    }

    // --- Fonksiyonlar ---
    public fun empty_list(): HabitList {
        HabitList { habits: vector::empty<Habit>() }
    }

    public fun new_habit(name: String): Habit {
        Habit { name, completed: false }
    }

    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    public fun complete_habit(list: &mut HabitList, index: u64) {
        let list_len = vector::length(&list.habits);
        if (index < list_len) {
            let habit_ref = vector::borrow_mut(&mut list.habits, index);
            habit_ref.completed = true;
        };
    }

    // --- TESTLER (GÜN 7 ÖDEVİ) ---

    #[test]
    // Test 1: Listeye alışkanlık eklemeyi test eder
    fun test_add_habit_to_list() {
        let mut list = empty_list();
        let h_name = string::utf8(b"Ders Calis");
        let habit = new_habit(h_name);
        
        add_habit(&mut list, habit);

        // Doğrulama: Listenin uzunluğu 1 olmalı
        assert!(vector::length(&list.habits) == 1, 0);
    }

    #[test]
    // Test 2: Bir alışkanlığı tamamlamayı test eder
    fun test_complete_habit_in_list() {
        let mut list = empty_list();
        add_habit(&mut list, new_habit(string::utf8(b"Spor Yap")));

        // 0. indeksteki alışkanlığı tamamla
        complete_habit(&mut list, 0);

        let habit_ref = vector::borrow(&list.habits, 0);
        // Doğrulama: completed alanı true olmalı
        assert!(habit_ref.completed == true, 1);
    }
}
