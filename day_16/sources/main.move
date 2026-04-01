module day_16::farm_simulator {
    use sui::object::{Self, UID};
    use sui::tx_context::{TxContext};
    use std::vector;

    // --- Hata Kodları & Sabitler ---
    const EInvalidPlotId: u64 = 0;
    const EPlotAlreadyPlanted: u64 = 1;
    const EPlotNotPlanted: u64 = 2;
    const EMaxPlotsReached: u64 = 3;
    const MAX_PLOTS: u8 = 20;

    // --- Structlar ---

    // Dünkü veri yapımız (Object içinde saklanacağı için 'store' var)
    public struct FarmCounters has copy, drop, store {
        planted: u64,
        harvested: u64,
        plots: vector<u8>
    }

    // ⭐ GÜN 16 YENİ: Gerçek bir Sui Object!
    public struct Farm has key {
        id: UID,                // Nesnenin benzersiz kimliği
        counters: FarmCounters  // Dünkü sayaç verilerimiz
    }

    // --- Fonksiyonlar ---

    // Yeni bir Farm nesnesi oluşturur
    public fun new_farm(ctx: &mut TxContext): Farm {
        Farm {
            // object::new(ctx) ile global olarak benzersiz bir ID alıyoruz
            id: object::new(ctx),
            counters: FarmCounters {
                planted: 0,
                harvested: 0,
                plots: vector::empty<u8>()
            }
        }
    }

    // Yardımıcı fonksiyonlar (Dünden devam)
    public fun plant(farm: &mut Farm, plot_id: u8) {
        assert!(plot_id > 0 && plot_id <= MAX_PLOTS, EInvalidPlotId);
        assert!(vector::length(&farm.counters.plots) < (MAX_PLOTS as u64), EMaxPlotsReached);
        assert!(!vector::contains(&farm.counters.plots, &plot_id), EPlotAlreadyPlanted);

        vector::push_back(&mut farm.counters.plots, plot_id);
        farm.counters.planted = farm.counters.planted + 1;
    }

    // --- Unit Test ---
    #[test]
    fun test_object_creation() {
        use sui::test_scenario;

        let admin = @0xAD;
        let mut scenario = test_scenario::begin(admin);
        
        {
            let mut farm = new_farm(test_scenario::ctx(&mut scenario));
            plant(&mut farm, 10);
            
            assert!(farm.counters.planted == 1, 0);
            
            // Temizlik için objeyi manuel imha ediyoruz (test için geçerli)
            let Farm { id, counters: _ } = farm;
            object::delete(id);
        };
        test_scenario::end(scenario);
    }
}
