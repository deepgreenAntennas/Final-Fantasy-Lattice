//
//  uppercutanimationsequence.swift
//  weapon
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import Foundation
class UppercutAnimation: BattleAnimation {
    func play(attacker: BattleCharacter, target: BattleCharacter, completion: @escaping () -> Void) {
        print("🎯 \(attacker.name) prepares Way Upper Cut...")
        
        // Step 1: Wind-up
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            print("💪 \(attacker.name) winds up!")
            
            // Step 2: Strike
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                print("👊 UPPERCUT CONNECTS!")
                
                // Step 3: Launch effect
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if target.isKnockedUp {
                        print("🚀 \(target.name) is launched skyward!")
                    }
                    
                    completion()
                }
            }
        }
    }
}
/Users/pussylattice69/Library/Mobile Documents/com~apple~TextEdit/Documents/quicktestfunction.txt
