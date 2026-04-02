module day_19::farm_simulator {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};
    use sui::transfer;
    use std::vector;

    // --- Hata Kodları & Sabitler ---
    const EInvalidPlotId: u64 = 0;
    const EPlotAlreadyPlanted: u64 = 1;
    const EPlotNotPlanted: u64 = 2;
    const EMaxPlotsReached: u64 = 3;
    const MAX_PLOTS: u8 = 20;

    // --- Structlar ---
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>
    }

    public struct Farm has key {
        id: UID,
        counters: FarmCounters
    }

    // --- Fonksiyonlar ---

    public entry fun create_farm(ctx: &mut TxContext) {
        let farm = Farm {
            id: object::new(ctx),
            counters: FarmCounters {
                planted: 0,
                harvested: 0,
                plots: vector::empty<u8>()
            }
        };
        transfer::share_object(farm);
    }

    // ⭐ GÜN 19 YENİ: Sorgu Fonksiyonu - Toplam Ekilen
    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    // ⭐ GÜN 19 YENİ: Sorgu Fonksiyonu - Toplam Hasat Edilen
    public fun total_harvested(farm: &Farm): u64 {
        farm.counters.harvested
    }

    // Mevcut aksiyonlar (Gerekli olduğu için tutuyoruz)
    public entry fun plant_on_farm(farm: &mut Farm, plot_id: u8) {
        assert!(plot_id > 0 && plot_id <= MAX_PLOTS, EInvalidPlotId);
        assert!(vector::length(&farm.counters.plots) < (MAX_PLOTS as u64), EMaxPlotsReached);
        assert!(!vector::contains(&farm.counters.plots, &plot_id), EPlotAlreadyPlanted);

        vector::push_back(&mut farm.counters.plots, plot_id);
        farm.counters.planted = farm.counters.planted + 1;
    }

    public entry fun harvest_from_farm(farm: &mut Farm, plot_id: u8) {
        let (found, index) = vector::index_of(&farm.counters.plots, &plot_id);
        assert!(found, EPlotNotPlanted);

        vector::remove(&mut farm.counters.plots, index);
        farm.counters.harvested = farm.counters.harvested + 1;
    }

    // --- Unit Test ---
    #[test]
    fun test_queries() {
        use sui::test_scenario;
        let user = @0xABC;
        let mut scenario = test_scenario::begin(user);
        
        create_farm(test_scenario::ctx(&mut scenario));
        
        test_scenario::next_tx(&mut scenario, user);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            
            plant_on_farm(&mut farm, 1);
            plant_on_farm(&mut farm, 2);
            
            // Sorgu fonksiyonlarını test et
            assert!(total_planted(&farm) == 2, 0);
            assert!(total_harvested(&farm) == 0, 1);

            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }
}
