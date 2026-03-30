module day_09::bounty_board {
    use std::string::{String};

    // ⭐ GÜN 09 YENİ: Görev durumlarını temsil eden Enum
    public enum TaskStatus has drop, copy {
        Open,
        Completed
    }

    public struct Task has drop {
        title: String,
        reward: u64,
        status: TaskStatus, // Artık bool done yerine Enum kullanıyoruz!
    }

    // --- Fonksiyonlar ---

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open, // Başlangıç durumu her zaman Open
        }
    }

    // Görevin açık olup olmadığını kontrol eden yardımcı fonksiyon
    public fun is_open(task: &Task): bool {
        // Enum kontrolü
        match (task.status) {
            TaskStatus::Open => true,
            TaskStatus::Completed => false,
        }
    }

    // --- Unit Test ---
    #[test]
    fun test_task_status() {
        use std::string;
        let task = new_task(string::utf8(b"Enum Ogren"), 500);

        // Yeni oluşturulan görev Open olmalı
        assert!(is_open(&task) == true, 0);
    }
}
