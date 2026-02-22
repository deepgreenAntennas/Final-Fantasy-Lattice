//
//  EnemyAI.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
class EnemyAI {
    enum BehaviorPattern {
        case aggressive, defensive, healer, berserker, tactical
    }
    
    func chooseAction(for enemy: BattleCharacter, party: [BattleCharacter]) -> BattleAction {
        let pattern = enemy.behaviorPattern
        
        switch pattern {
        case .aggressive:
            return aggressiveAction(enemy: enemy, party: party)
        case .defensive:
            return defensiveAction(enemy: enemy, party: party)
        case .healer:
            return healerAction(enemy: enemy, party: party)
        case .berserker:
            return berserkerAction(enemy: enemy, party: party)
        case .tactical:
            return tacticalAction(enemy: enemy, party: party)
        }
    }
    
    private func aggressiveAction(enemy: BattleCharacter, party: [BattleCharacter]) -> BattleAction {
        let weakestTarget = party.min(by: { $0.currentHP < $1.currentHP })!
        let ability = enemy.abilities.filter { $0.cost <= enemy.currentMP }.randomElement()
        
        return BattleAction(type: .ability, target: weakestTarget, ability: ability)
    }
    
    private func tacticalAction(enemy: BattleCharacter, party: [BattleCharacter]) -> BattleAction {
        // Target characters without status protection
        let vulnerableTargets = party.filter { !$0.hasStatusProtection }
        let target = vulnerableTargets.first ?? party.randomElement()!
        
        if Bool.random() && enemy.hasStatusAbilities {
            return BattleAction(type: .ability, target: target, ability: enemy.statusAbility)
        } else {
            return BattleAction(type: .attack, target: target)
        }
    }
}
