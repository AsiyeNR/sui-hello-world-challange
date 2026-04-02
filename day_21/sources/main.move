module day_21::farm_simulator {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};
    use sui::transfer;
    use sui::event;
    use std::vector;

    // --- Hata Kodları ---
    const EInvalidPlotId: u64 = 0;
    const EPlotAlreadyPlanted: u64 = 1;
    const EPlotNotPlanted: u64 = 2;
    const EMaxPlotsReached: u64 = 3;

    const MAX_PLOTS: u8 = 20;

    // --- Event ---
    public struct PlantEvent has copy, drop {
        planted_after: u64,
    }

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

    public entry fun create_farm(ctx: &mut TxContext) {
        transfer::share_object(new_farm(ctx));
    }

    public fun total_planted(farm: &Farm): u64 { farm.counters.planted }
    public fun total_harvested(farm: &Farm): u64 { farm.counters.harvested }

    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) {
        assert!(plot_id > 0 && plot_id <= MAX_PLOTS, EInvalidPlotId);
        assert!(vector::length(&farm.counters.plots) < (MAX_PLOTS as u64), EMaxPlotsReached);
        assert!(!vector::contains(&farm.counters.plots, &plot_id), EPlotAlreadyPlanted);

        vector::push_back(&mut farm.counters.plots, plot_id);
        farm.counters.planted = farm.counters.planted + 1;
    }

    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) {
        plant_on_farm(farm, plot_id);
        event::emit(PlantEvent { planted_after: total_planted(farm) });
    }

    public entry fun harvest_from_farm(farm: &mut Farm, plot_id: u8) {
        let (found, index) = vector::index_of(&farm.counters.plots, &plot_id);
        assert!(found, EPlotNotPlanted);

        vector::remove(&mut farm.counters.plots, index);
        farm.counters.harvested = farm.counters.harvested + 1;
    }

    // --- ⭐ KAPSAMLI TESTLER ---
    #[test_only] use sui::test_scenario;

    #[test]
    fun test_create_farm() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            let farm = test_scenario::take_shared<Farm>(&scenario);
            assert!(total_planted(&farm) == 0, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_planting_increases_counter() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            assert!(total_planted(&farm) == 1, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_harvesting_increases_counter() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            harvest_from_farm(&mut farm, 1);
            assert!(total_harvested(&farm) == 1, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test]
    fun test_multiple_operations() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 3);
            plant_on_farm_entry(&mut farm, 5);
            plant_on_farm_entry(&mut farm, 18);
            harvest_from_farm(&mut farm, 5);
            assert!(total_planted(&farm) == 3, 0);
            assert!(total_harvested(&farm) == 1, 1);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test] #[expected_failure(abort_code = EInvalidPlotId)]
    fun test_invalid_plot_id_low() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 0);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test] #[expected_failure(abort_code = EPlotAlreadyPlanted)]
    fun test_duplicate_plot() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            plant_on_farm_entry(&mut farm, 1);
            plant_on_farm_entry(&mut farm, 1);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test] #[expected_failure(abort_code = EMaxPlotsReached)]
    fun test_plot_limit() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            let mut i = 1;
            while (i <= 20) {
                plant_on_farm_entry(&mut farm, i);
                i = i + 1;
            };
            // BURASI ÖNEMLİ: ID geçerli (10), ama limit 20/20 olduğu için 
            // EMaxPlotsReached (Code 3) ile patlayacak.
            plant_on_farm_entry(&mut farm, 10); 
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }

    #[test] #[expected_failure(abort_code = EPlotNotPlanted)]
    fun test_harvest_nonexistent_plot() {
        let mut scenario = test_scenario::begin(@0x1);
        create_farm(test_scenario::ctx(&mut scenario));
        test_scenario::next_tx(&mut scenario, @0x1);
        {
            let mut farm = test_scenario::take_shared<Farm>(&scenario);
            harvest_from_farm(&mut farm, 9);
            test_scenario::return_shared(farm);
        };
        test_scenario::end(scenario);
    }
}
