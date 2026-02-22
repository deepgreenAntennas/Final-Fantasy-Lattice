//
//  StatusEffectManager.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
class StatusEffectManager {
    enum StatusEffect {
        case poison, silence, stun, berserk, protect, shell, haste, slow
        
        var isPositive: Bool {
            switch self {
            case .protect, .shell, .haste: return true
            default: return false
            }
        }
        
        var duration: Int {
            switch self {
            case .poison: return 3
            case .silence: return 2
            case .stun: return 1
            case .berserk: return 4
            case .protect, .shell: return 4
            case .haste, .slow: return 3
            }
        }
    }
    
    func applyStatusEffect(_ effect: StatusEffect, to target: BattleCharacter) -> Bool {
        // Check resistance
        if Bool.random(withProbability: target.statusResistance) {
            print("\(target.name) resists the \(effect)!")
            return false
        }
        
        target.activeStatuses.append(effect)
        print("\(target.name) is now \(effect)!")
        return true
    }
    
    func processStartOfTurnEffects(character: BattleCharacter) {
        for effect in character.activeStatuses {
            switch effect {
            case .poison:
                let damage = character.maxHP / 10
                character.currentHP -= damage
                print("\(character.name) takes \(damage) poison damage!")
            case .haste:
                character.speedBoost = 1.5
            case .slow:
                character.speedBoost = 0.5
            case .silence:
                character.canUseMagic = false
            default:
                break
            }
        }
    }
}
