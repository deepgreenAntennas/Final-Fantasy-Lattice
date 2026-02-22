//
//  Ghoul.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import UIKit

class Ghoul: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
import random

class Ghoul:
    def __init__(self):
        self.name = "Ghoul"
        self.level = 1
        self.max_hp = 120
        self.current_hp = 120
        self.mp = 30
        self.attack = 15
        self.defense = 10
        self.magic_defense = 8
        self.speed = 8
        self.status_effects = []
        self.is_undead = True  # Important for healing/damage mechanics
    
    def take_damage(self, damage):
        self.current_hp = max(0, self.current_hp - damage)
        return damage
    
    def attack_target(self, target):
        damage = max(1, self.attack - target.defense // 2)
        target.take_damage(damage)
        return f"{self.name} attacks! {target.name} takes {damage} damage!"
    
    def use_dark_magic(self, target):
        if self.mp >= 10:
            self.mp -= 10
            damage = random.randint(8, 15)
            target.take_damage(damage)
            return f"{self.name} casts Dark! {target.name} takes {damage} dark damage!"
        else:
            return self.attack_target(target)
    
    def use_poison_claw(self, target):
        damage = max(1, (self.attack // 2) - target.defense // 3)
        target.take_damage(damage)
        # Chance to poison target
        if random.random() < 0.3:  # 30% chance
            target.status_effects.append("Poison")
            return f"{self.name}'s poison claw! {target.name} takes {damage} damage and is poisoned!"
        return f"{self.name} uses poison claw! {target.name} takes {damage} damage!"
    
    def choose_action(self, party):
        # AI for the Ghoul - chooses between different attacks
        action_roll = random.random()
        
        if action_roll < 0.4:  # 40% chance for basic attack
            return self.attack_target(party[0])
        elif action_roll < 0.7 and self.mp >= 10:  # 30% chance for dark magic
            return self.use_dark_magic(party[0])
        else:  # 30% chance for poison claw
            return self.use_poison_claw(party[0])
    
    def is_alive(self):
        return self.current_hp > 0
    
    def __str__(self):
        return f"{self.name}: HP {self.current_hp}/{self.max_hp} MP {self.mp}"

# Example usage
if __name__ == "__main__":
    ghoul = Ghoul()
    print(ghoul)
    print("Ghoul ready for battle!")
