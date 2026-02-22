//
//  BattleEngine.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
class BattleEngine {
    var turnQueue: [BattleCharacter] = []
    var currentTurn: Int = 0
    
    func executeTurn(attacker: BattleCharacter, action: BattleAction, target: BattleCharacter) -> BattleResult {
        var result = BattleResult()
        
        switch action.type {
        case .attack:
            result = calculatePhysicalAttack(attacker: attacker, target: target)
        case .ability:
            result = AbilityManager.executeAbility(attacker: attacker, target: target, ability: action.ability!)
        case .item:
            result = ItemManager.useBattleItem(attacker: attacker, target: target, item: action.item!)
        case .defend:
            result = defendAction(attacker: attacker)
        }
        
        processStatusEffects()
        checkBattleEnd()
        return result
    }
    
    private func calculatePhysicalAttack(attacker: BattleCharacter, target: BattleCharacter) -> BattleResult {
        let baseDamage = attacker.attack - (target.defense / 2)
        let variance = Int.random(in: -5...5)
        let finalDamage = max(1, baseDamage + variance)
        
        // Critical hit chance (based on luck)
        let isCritical = Bool.random(withProbability: Double(attacker.luck) / 100.0)
        let damage = isCritical ? finalDamage * 2 : finalDamage
        
        target.currentHP -= damage
        
        return BattleResult(
            damage: damage,
            isCritical: isCritical,
            message: isCritical ? "CRITICAL HIT! \(damage) damage!" : "\(damage) damage!"
        )
    }
    
    private func defendAction(defender: BattleCharacter) -> BattleResult {
        defender.isDefending = true
        defender.defenseBoost = 1.5 // 50% defense boost
        return BattleResult(message: "\(defender.name) takes defensive stance!")
    }
}
