//
//  ComboSystem.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
class ComboSystem {
    struct Combo {
        let name: String
        let requiredAbilities: [String]
        let effect: () -> Void
        let description: String
    }
    
    var activeCombos: [Combo] = [
        Combo(
            name: "Firestorm",
            requiredAbilities: ["fire_ball", "whirlwind"],
            effect: {
                // Triple damage area attack
                BattleEngine.shared.dealAreaDamage(multiplier: 3.0)
            },
            description: "Fire meets wind, creating an inferno!"
        ),
        Combo(
            name: "Knockout Blow",
            requiredAbilities: ["way_upper_cut", "earth_shatter"],
            effect: {
                // Guaranteed stun + double damage
                BattleEngine.shared.applyGuaranteedStun()
            },
            description: "Uppercut into ground slam—devastating!"
        )
    ]
    
    func checkComboTriggers(abilitiesUsed: [String]) -> [Combo] {
        return activeCombos.filter { combo in
            combo.requiredAbilities.allSatisfy { ability in
                abilitiesUsed.contains(ability)
            }
        }
    }
    
    func executeCombo(_ combo: Combo) {
        print("COMBO ACTIVATED: \(combo.name)!")
        print(combo.description)
        combo.effect()
    }
}
