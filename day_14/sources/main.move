module day_14::bounty_board {
    use std::string::{Self, String};
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

    // --- Fonksiyonlar ---

    public fun new_board(owner: address): TaskBoard {
        TaskBoard { owner, tasks: vector::empty<Task>() }
    }

    public fun new_task(title: String, reward: u64): Task {
        Task { title, reward, status: TaskStatus::Open }
    }

    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    public fun complete_task(board: &mut TaskBoard, index: u64) {
        let task = vector::borrow_mut(&mut board.tasks, index);
        task.status = TaskStatus::Completed;
    }

    public fun total_reward(board: &TaskBoard): u64 {
        let mut total = 0;
        let mut i = 0;
        let len = vector::length(&board.tasks);
        while (i < len) {
            total = total + vector::borrow(&board.tasks, i).reward;
            i = i + 1;
        };
        total
    }

    public fun completed_count(board: &TaskBoard): u64 {
        let mut count = 0;
        let mut i = 0;
        while (i < vector::length(&board.tasks)) {
            if (vector::borrow(&board.tasks, i).status == TaskStatus::Completed) {
                count = count + 1;
            };
            i = i + 1;
        };
        count
    }

    // --- ⭐ GÜN 14: KAPSAMLI UNIT TESTLER ---

    #[test]
    // Test 1: Pano oluşturma ve görev ekleme
    fun test_create_and_add() {
        let mut board = new_board(@0x1);
        add_task(&mut board, new_task(string::utf8(b"Task A"), 100));
        
        assert!(vector::length(&board.tasks) == 1, 0);
    }

    #[test]
    // Test 2: Görev tamamlama ve sayacı doğrulama
    fun test_complete_and_count() {
        let mut board = new_board(@0x1);
        add_task(&mut board, new_task(string::utf8(b"Task B"), 200));
        
        complete_task(&mut board, 0);
        
        assert!(completed_count(&board) == 1, 1);
    }

    #[test]
    // Test 3: Toplam ödül hesaplama (Birden fazla görevle)
    fun test_total_reward_calculation() {
        let mut board = new_board(@0x1);
        add_task(&mut board, new_task(string::utf8(b"Task 1"), 150));
        add_task(&mut board, new_task(string::utf8(b"Task 2"), 350));
        
        assert!(total_reward(&board) == 500, 2);
    }
}
