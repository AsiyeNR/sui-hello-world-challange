module day_04::habit_tracker {
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

    // Boş bir liste oluşturur
    public fun empty_list(): HabitList {
        HabitList {
            habits: vector::empty<Habit>(),
        }
    }

    // Yeni bir Habit oluşturur
    public fun new_habit(name: String): Habit {
        Habit {
            name,
            completed: false,
        }
    }

    // Listeye Habit ekler (Ownership & Borrowing örneği)
    public fun add_habit(list: &mut HabitList, habit: Habit) {
        vector::push_back(&mut list.habits, habit);
    }

    // --- Unit Test ---
    #[test]
    fun test_add_habit() {
        let mut list = empty_list();
        let name = string::utf8(b"Sui Calis");
        let habit = new_habit(name);

        add_habit(&mut list, habit);

        // Listenin boyutu 1 mi kontrol et
        assert!(vector::length(&list.habits) == 1, 0);
    }
}