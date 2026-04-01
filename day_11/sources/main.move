module day_11::bounty_board {
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

    // ⭐ GÜN 11 YENİ: Sahipliği takip eden Pano yapısı
    public struct TaskBoard has drop {
        owner: address,     // Panonun sahibi olan adres
        tasks: vector<Task> // Panonun içindeki görevler listesi
    }

    // --- Fonksiyonlar ---

    // Yeni bir pano oluşturur
    public fun new_board(owner: address): TaskBoard {
        TaskBoard {
            owner,
            tasks: vector::empty<Task>(),
        }
    }

    public fun new_task(title: String, reward: u64): Task {
        Task {
            title,
            reward,
            status: TaskStatus::Open,
        }
    }

    // Panoya görev ekleme (Sahiplik transferi gerçekleşir!)
    public fun add_task(board: &mut TaskBoard, task: Task) {
        vector::push_back(&mut board.tasks, task);
    }

    // --- Unit Test ---
    #[test]
    fun test_board_ownership() {
        use std::string;
        // Örnek bir adres tanımlayalım (0x1)
        let owner_addr = @0x1;
        let mut board = new_board(owner_addr);
        
        let task = new_task(string::utf8(b"Sahiplik Ogren"), 200);
        add_task(&mut board, task);

        assert!(board.owner == owner_addr, 0);
        assert!(vector::length(&board.tasks) == 1, 1);
    }
}
