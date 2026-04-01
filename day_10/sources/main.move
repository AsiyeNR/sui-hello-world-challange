module day_10::bounty_board {
    use std::string::{String};

    public enum TaskStatus has drop, copy {
        Open,
        Completed
    }

    public struct Task has drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    // --- Public API (Dışarıya Açık) ---

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    // Görevi tamamla: Bu fonksiyon dışarıdan çağrılabilir
    public fun complete_task(task: &mut Task) {
        // İşi mutfaktaki yardımcıya (private fonksiyona) devrediyoruz
        change_status(task, TaskStatus::Completed);
    }

    public fun is_open(task: &Task): bool {
        match (task.status) {
            TaskStatus::Open => true,
            TaskStatus::Completed => false,
        }
    }

    // --- Private Helper (Sadece Bu Modül İçin) ---
    // 'public' anahtar kelimesi yok, yani dış dünyadan gizli!
    fun change_status(task: &mut Task, new_status: TaskStatus) {
        task.status = new_status;
    }

    // --- Unit Test ---
    #[test]
    fun test_visibility_logic() {
        use std::string;
        let mut task = new_task(string::utf8(b"API Tasarla"), 100);
        
        // Public fonksiyonu çağırıyoruz
        complete_task(&mut task);

        assert!(is_open(&task) == false, 0);
    }
}
