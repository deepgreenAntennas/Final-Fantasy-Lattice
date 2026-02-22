//
//  AltimaStyles.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
class AltimaCombatStyles {
    enum CombatStyle {
        case gravityMage    // Heavy control magic
        case momentumStriker // Physics-based attacks
        case latticeWarden  // Defensive powerhouse
    }
    
    // POWERFUL GRAVITY MAGIC
    static let gravityCrush: BattleAbility = {
        BattleAbility(
            id: "gravity_crush",
            name: "Gravity Crush",
            description: "Altima manipulates fundamental forces, pinning enemies with intense pressure",
            effect: {
                let damage = target.maxHP * 0.3 // 30% max HP damage
                target.applyStatus(.stunned) // Stun from the pressure
                target.speedReduction = 0.5 // Heavy = slow
                return "The air thickens! \(target.name) is crushed by gravitational force!"
            }
        )
    }()
    
    // MOMENTUM-BASED ATTACKS
    static let inertiaSlam: BattleAbility = {
        BattleAbility(
            id: "inertia_slam",
            name: "Inertia Slam",
            description: "Builds kinetic energy for a devastating impact",
            effect: {
                let momentum = attacker.turnsInPlace * 15 // Bonus based on positioning
                let damage = 80 + momentum
                attacker.resetPositionBonus()
                return "Built momentum released! \(damage) crushing damage!"
            }
        )
    }()
    
    // LATTICE-BASED DEFENSES
    static let dataFortress: BattleAbility = {
        BattleAbility(
            id: "data_fortress",
            name: "Data Fortress",
            description: "Weaves defensive algorithms into physical form",
            effect: {
                attacker.defenseBoost = 2.0 // Double defense
                attacker.magicDefenseBoost = 2.0
                attacker.applyStatus(.protect)
                attacker.applyStatus(.shell)
                return "Reality stabilizes around Altima! Defenses maximized!"
            }
        )
    }()
}
