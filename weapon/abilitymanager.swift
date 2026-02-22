//
//  abilitymanager.swift
//  weapon
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import Foundation
class AbilityManager {
    static func executeWayUpperCut(attacker: BattleCharacter, target: BattleCharacter) -> BattleResult {
        var result = BattleResult()
        
        // Calculate base damage
        let baseDamage = calculateDamage(attacker: attacker, target: target, power: 120)
        
        // Critical hit chance (higher for uppercut)
        let isCritical = Bool.random(withProbability: 0.3) // 30% crit chance
        let criticalMultiplier = isCritical ? 1.5 : 1.0
        let finalDamage = Int(Double(baseDamage) * criticalMultiplier)
        
        // Apply damage
        result.damage = finalDamage
        target.currentHP -= finalDamage
        
        // Knockup effect (80% chance)
        if Bool.random(withProbability: 0.8) {
            result.effects.append(.knockup)
            target.isKnockedUp = true
            target.canActThisTurn = false // Skip target's next turn
        }
        
        // Battle message
        if isCritical {
            result.message = "WAY UPPER CUT! CRITICAL HIT! \(finalDamage) damage!"
        } else {
            result.message = "Way Upper Cut! \(finalDamage) damage!"
        }
        
        if result.effects.contains(.knockup) {
            result.message += " Enemy launched skyward!"
        }
        
        return result
    }
    
    private static func calculateDamage(attacker: BattleCharacter, target: BattleCharacter, power: Int) -> Int {
        let attack = attacker.attack
        let defense = target.defense
        return max(1, (attack * power / 100) - defense)
    }
}

