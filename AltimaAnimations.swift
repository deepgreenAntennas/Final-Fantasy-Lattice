//
//  AltimaAnimations.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
class AltimaAnimations {
    static func playGravityCrushAnimation(target: BattleCharacter) {
        // Visual weight and impact
        animateScreenShake(intensity: 0.8)
        animatePressureWaves(origin: target.position)
        spawnParticleEffect("gravity_distortion", at: target.position)
        
        print("🌀 Reality warps around \(target.name)!")
    }
    
    static func playInertiaSlamAnimation(attacker: BattleCharacter, target: BattleCharacter) {
        // Build-up and release
        animateEnergyBuildUp(attacker.position, duration: 1.0)
        animateShockwave(attacker.position, target.position)
        spawnParticleEffect("kinetic_release", at: target.position)
        
        print("💥 Kinetic energy erupts from Altima!")
    }
}
