module day_13::bounty_board {
    use std::string::{String};
    use std::vector;

    public enum TaskStatus has drop, copy {
        Open,
        Completed
    }

    public struct Task has drop {
        title: String,
        reward: u64,
        status: TaskStatus,
    }

    public struct TaskBoard has drop {
        owner: address,
        tasks: vector<Task>
    }

    // --- Temel Fonksiyonlar ---

    public fun new_board(owner: address): TaskBoard {
        TaskBoard { owner, tasks: vector::empty<Task>() }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun new_task(title: String, reward: u64): Task {
        Task { title, reward, status: TaskStatus::Open }
    }

    // ⭐ GÜN 13 YENİ: Toplam Ödülü Hesaplama
    public fun total_reward(board: &TaskBoard): u64 {
        let mut total = 0;
        let mut i = 0;
        let len = vector::length(&board.tasks);

        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            total = total + task.reward;
            i = i + 1;
        };
        total
    }

    // ⭐ GÜN 13 YENİ: Tamamlanan Görevleri Sayma
    public fun completed_count(board: &TaskBoard): u64 {
        let mut count = 0;
        let mut i = 0;
        let len = vector::length(&board.tasks);

        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            match (task.status) {
                TaskStatus::Completed => { count = count + 1; },
                TaskStatus::Open => { /* Bir şey yapma */ }
            };
            i = i + 1;
        };
        count
    }

    // --- Unit Test ---
    #[test]
    fun test_aggregations() {
        use std::string;
        let mut board = new_board(@0x1);
        
        add_task(&mut board, new_task(string::utf8(b"Task 1"), 100));
        add_task(&mut board, new_task(string::utf8(b"Task 2"), 250));

        // Toplam ödül 350 olmalı
        assert!(total_reward(&board) == 350, 0);
        
        // Henüz tamamlanan yok, 0 olmalı
        assert!(completed_count(&board) == 0, 1);
    }
}
