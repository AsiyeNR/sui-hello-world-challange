module day_05::habit_tracker {
    use std::string::{String};
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
        
        // --- IF/ELSE Kontrolü ---
        if (index < list_len) {
            let habit_ref = vector::borrow_mut(&mut list.habits, index);
            // Struct alanını değiştiriyoruz
            habit_ref.completed = true;
        } else {

        }
    }

    // --- Unit Test ---
    #[test]
    fun test_complete_habit() {
        use std::string;
        let mut list = empty_list();
        add_habit(&mut list, new_habit(string::utf8(b"Sui Move")));

        complete_habit(&mut list, 0);

        let habit_ref = vector::borrow(&list.habits, 0);
        assert!(habit_ref.completed == true, 0);
    }
}