module day_18::farm_simulator {
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

    // --- İç Yardımcı Fonksiyonlar ---
    fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            id: object::new(ctx),
            counters: FarmCounters {
                planted: 0,
                harvested: 0,
                plots: vector::empty<u8>()
            }
        }
    }

    // --- Modül İçi Aksiyonlar (Public) ---
    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) {
        assert!(plot_id > 0 && plot_id <= MAX_PLOTS, EInvalidPlotId);
        assert!(vector::length(&farm.counters.plots) < (MAX_PLOTS as u64), EMaxPlotsReached);
        assert!(!vector::contains(&farm.counters.plots, &plot_id), EPlotAlreadyPlanted);

        vector::push_back(&mut farm.counters.plots, plot_id);
        farm.counters.planted = farm.counters.planted + 1;
    }

    public fun harvest_from_farm(farm: &mut Farm, plot_id: u8) {
        let (found, index) = vector::index_of(&farm.counters.plots, &plot_id);
        assert!(found, EPlotNotPlanted);

        vector::remove(&mut farm.counters.plots, index);
        farm.counters.harvested = farm.counters.harvested + 1;
    }

    // --- ENTRY FUNCTIONS (GÜN 18 ÖDEVİ) ---
    public entry fun create_farm(ctx: &mut TxContext) {
        transfer::share_object(new_farm(ctx));
    }

    public entry fun plant_on_farm_entry(farm: &mut Farm, plotId: u8) {
        plant_on_farm(farm, plotId);
    }

    public entry fun harvest_from_farm_entry(farm: &mut Farm, plotId: u8) {
        harvest_from_farm(farm, plotId);
    }

    // --- Unit Test (Testlerin çalışması için bu şart!) ---
    #[test]
    fun test_full_farm_flow() {
        use sui::test_scenario;
        let user = @0xABC;
        let mut scenario = test_scenario::begin(user);
        
        create_farm(test_scenario::ctx(&mut scenario));
        
        test_scenario::next_tx(&mut scenario, user);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 10);
            assert!(farm.counters.planted == 1, 0);
            
            harvest_from_farm_entry(&mut farm, 10);
            assert!(farm.counters.harvested == 1, 1);
            
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }
}
