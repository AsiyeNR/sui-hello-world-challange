module day_12::bounty_board {
    use std::string::{String};
    use std::vector;
    use std::option::{Self, Option};

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

    // --- Fonksiyonlar ---

    public fun new_board(owner: address): TaskBoard {
        TaskBoard { owner, tasks: vector::empty<Task>() }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun new_task(title: String, reward: u64): Task {
        Task { title, reward, status: TaskStatus::Open }
    }

    // ⭐ GÜN 12 YENİ: Başlığa göre görev arama (Option döner)
    public fun find_task_by_title(board: &TaskBoard, title: String): Option<u64> {
        let mut i = 0;
        let len = vector::length(&board.tasks);

        while (i < len) {
            let task = vector::borrow(&board.tasks, i);
            if (task.title == title) {
                // Bulundu! Index'i Some içinde sarmalayıp dönüyoruz
                return option::some(i)
            };
            i = i + 1;
        };

        // Döngü bitti ve bulunamadıysa None dönüyoruz
        option::none()
    }

    // --- Unit Test ---
    #[test]
    fun test_find_task() {
        use std::string;
        let mut board = new_board(@0x1);
        let target_title = string::utf8(b"Find Me");
        
        add_task(&mut board, new_task(target_title, 100));

        // Başarıyla bulmalı
        let result = find_task_by_title(&board, target_title);
        assert!(option::is_some(&result), 0);
        assert!(*option::borrow(&result) == 0, 1);

        // Olmayan bir şeyi arayalım
        let fail_result = find_task_by_title(&board, string::utf8(b"Missing"));
        assert!(option::is_none(&fail_result), 2);
    }
}
