module day_15::farm_simulator {
    use std::vector;

    // --- Hata Kodları ---
    const EInvalidPlotId: u64 = 0;
    const EPlotAlreadyPlanted: u64 = 1;
    const EPlotNotPlanted: u64 = 2;
    const EMaxPlotsReached: u64 = 3;

    // --- Sabitler ---
    const MAX_PLOTS: u8 = 20;

    // --- Structlar ---
    // store yeteneği, bu yapının bir Sui Object içinde saklanabilmesini sağlar
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>
    }

    // --- Fonksiyonlar ---

    public fun new_counters(): FarmCounters {
        FarmCounters {
            planted: 0,
            harvested: 0,
            plots: vector::empty<u8>()
        }
    }

    // Ekim yapma fonksiyonu
    public fun plant(counters: &mut FarmCounters, plot_id: u8) {
        // 1. Doğrulama: plot_id 1-20 arasında mı?
        assert!(plot_id > 0 && plot_id <= MAX_PLOTS, EInvalidPlotId);
        
        // 2. Doğrulama: Limit doldu mu?
        assert!(vector::length(&counters.plots) < (MAX_PLOTS as u64), EMaxPlotsReached);

        // 3. Doğrulama: Bu parselde zaten bir şey ekili mi?
        assert!(!vector::contains(&counters.plots, &plot_id), EPlotAlreadyPlanted);

        vector::push_back(&mut counters.plots, plot_id);
        counters.planted = counters.planted + 1;
    }

    // Hasat yapma fonksiyonu
    public fun harvest(counters: &mut FarmCounters, plot_id: u8) {
        // Doğrulama: Bu parselde ekili bir şey var mı?
        let (found, index) = vector::index_of(&counters.plots, &plot_id);
        assert!(found, EPlotNotPlanted);

        vector::remove(&mut counters.plots, index);
        counters.harvested = counters.harvested + 1;
    }

    // --- Unit Test ---
    #[test]
    fun test_farm_flow() {
        let mut counters = new_counters();
        
        plant(&mut counters, 5);
        assert!(counters.planted == 1, 0);
        assert!(vector::contains(&counters.plots, &5), 1);

        harvest(&mut counters, 5);
        assert!(counters.harvested == 1, 2);
        assert!(!vector::contains(&counters.plots, &5), 3);
    }
}
