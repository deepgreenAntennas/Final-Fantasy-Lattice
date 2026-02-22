//
//  PhysicsEngine.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
class PhysicsEngine {
    struct Impact {
        let force: Double
        let direction: Vector2
        let knockback: Bool
    }
    
    func calculateKnockback(attacker: BattleCharacter, target: BattleCharacter, ability: BattleAbility) -> Impact {
        let baseForce = Double(attacker.strength) * ability.power
        let targetMass = Double(target.vitality) / 10.0
        
        let knockbackForce = baseForce / max(1.0, targetMass)
        let shouldKnockback = knockbackForce > 5.0 // Threshold
        
        return Impact(
            force: knockbackForce,
            direction: calculateDirection(attacker, target),
            knockback: shouldKnockback
        )
    }
    
    func applyPhysicsEffects(impact: Impact, target: BattleCharacter) {
        if impact.knockback {
            target.position += impact.direction * impact.force
            target.applyStatus(.staggered)
            print("\(target.name) is sent reeling from the impact!")
        }
        
        // Environmental interactions
        if target.position.x > battleFieldBounds.width {
            print("\(target.name) crashes through the terrain!")
            target.takeDamage(impact.force * 10)
        }
    }
}
