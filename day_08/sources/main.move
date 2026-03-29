module day_08::bounty_board {
    use std::string::{String};

    // --- Structlar ---
    
    public struct Task has drop {
        title: String,
        reward: u64,
        done: bool,
    }

    // --- Fonksiyonlar ---

    // Constructor (Yapıcı Fonksiyon)
    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            done: false, // Yeni görevler her zaman 'tamamlanmamış' başlar
        }
    }

    // --- Basit Bir Test ---
    #[test]
    fun test_create_task() {
        use std::string;
        let title = string::utf8(b"Fix Bug");
        let reward = 1000;
        let task = new_task(title, reward);

        assert!(task.reward == 1000, 0);
        assert!(task.done == false, 1);
    }
}
