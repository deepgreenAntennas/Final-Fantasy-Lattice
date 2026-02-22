//
//  QuickBattleTest.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
func testBattleMechanics() {
    let hero = BattleCharacter(name: "Altima", level: 10)
    let enemy = BattleCharacter(name: "Goblin", level: 8)
    
    let engine = BattleEngine()
    let result = engine.executeTurn(attacker: hero, action: BattleAction(type: .attack), target: enemy)
    
    print(result.message)
    print("Enemy HP: \(enemy.currentHP)/\(enemy.maxHP)")
    
    // Test position bonus
    let positionManager = PositionManager()
    positionManager.characterPositions[hero] = .backLine
    let bonus = positionManager.getPositionBonus(character: hero, attackType: .magical)
    print("Back line magic bonus: \(bonex)")
}
