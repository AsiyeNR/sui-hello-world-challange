module day_20::farm_simulator {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};
    use sui::transfer;
    use sui::event; // ⭐ Event modülünü ekledik
    use std::vector;

    // --- Hata Kodları & Sabitler ---
    const EInvalidPlotId: u64 = 0;
    const EPlotAlreadyPlanted: u64 = 1;
    const EPlotNotPlanted: u64 = 2;
    const EMaxPlotsReached: u64 = 3;
    const MAX_PLOTS: u8 = 20;

    // --- ⭐ GÜN 20 YENİ: Event Struct ---
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

    // Sorgu fonksiyonu (Event için kullanacağız)
    public fun total_planted(farm: &Farm): u64 {
        farm.counters.planted
    }

    public fun plant_on_farm(farm: &mut Farm, plot_id: u8) {
        assert!(plot_id > 0 && plot_id <= MAX_PLOTS, EInvalidPlotId);
        assert!(vector::length(&farm.counters.plots) < (MAX_PLOTS as u64), EMaxPlotsReached);
        assert!(!vector::contains(&farm.counters.plots, &plot_id), EPlotAlreadyPlanted);

        vector::push_back(&mut farm.counters.plots, plot_id);
        farm.counters.planted = farm.counters.planted + 1;
    }

    // ⭐ GÜN 20 GÖREVİ: Event yayınlayan Entry fonksiyonu
    public entry fun plant_on_farm_entry(farm: &mut Farm, plot_id: u8) {
        // 1. Ekme işlemini yap
        plant_on_farm(farm, plot_id);

        // 2. Güncel sayıyı al
        let planted_count = total_planted(farm);

        // 3. Olayı dünyaya duyur (Emit)
        event::emit(PlantEvent {
            planted_after: planted_count
        });
    }

    public entry fun harvest_from_farm(farm: &mut Farm, plot_id: u8) {
        let (found, index) = vector::index_of(&farm.counters.plots, &plot_id);
        assert!(found, EPlotNotPlanted);

        vector::remove(&mut farm.counters.plots, index);
        farm.counters.harvested = farm.counters.harvested + 1;
    }
}
