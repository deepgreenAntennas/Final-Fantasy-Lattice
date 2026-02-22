//
//  RewardSystem.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
class RewardSystem {
    func calculateBattleRewards(victoriousParty: [BattleCharacter], enemyParty: [BattleCharacter]) -> BattleRewards {
        var rewards = BattleRewards()
        
        // Base XP based on enemy levels
        let totalEnemyPower = enemyParty.reduce(0) { $0 + $1.level * 10 }
        rewards.experience = totalEnemyPower / victoriousParty.count
        
        // Gil reward
        rewards.gil = enemyParty.reduce(0) { $0 + $1.gilValue }
        
        // Item drops
        rewards.items = calculateItemDrops(enemyParty: enemyParty)
        
        // Bonus for tactical play
        if wasTacticalVictory(victoriousParty) {
            rewards.experience = Int(Double(rewards.experience) * 1.25)
            rewards.gil = Int(Double(rewards.gil) * 1.25)
            rewards.bonusMessage = "Tactical Victory Bonus!"
        }
        
        return rewards
    }
    
    private func wasTacticalVictory(_ party: [BattleCharacter]) -> Bool {
        let usedCombos = party.flatMap { $0.abilitiesUsed }.count
        let statusApplications = party.flatMap { $0.statusesApplied }.count
        let positionSwaps = party.filter { $0.positionChanges > 0 }.count
        
        return (usedCombos + statusApplications + positionSwaps) >= 3
    }
}
