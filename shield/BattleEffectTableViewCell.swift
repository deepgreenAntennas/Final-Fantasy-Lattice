//
//  BattleEffectTableViewCell.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import UIKit

class BattleEffectTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
enum BattleEffect {
    case damageNegation
    case protectAllies
    case mpAbsorption
    case damageReflection
    case statusReflection
    case autoProtect
    case shatterExplosion
    
    var message: String {
        switch self {
        case .damageNegation:
            return "The attack is completely negated!"
        case .protectAllies:
            return "Shield protects nearby allies!"
        case .mpAbsorption:
            return "Magic energy is absorbed as MP!"
        case .damageReflection:
            return "Damage is reflected back!"
        case .statusReflection:
            return "Status effect is reflected!"
        case .autoProtect:
            return "Protect springs forth automatically!"
        case .shatterExplosion:
            return "Shield shatters in a brilliant explosion!"
        }
    }
}
