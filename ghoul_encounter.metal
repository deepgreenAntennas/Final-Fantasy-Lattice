//
//  ghoul_encounter.metal
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

#include <metal_stdlib>
using namespace Ghoul1-Altima2.1.-.nil;
import random

class Ghoul:
    def __init__(self, level=1, variant=None):
        self.variants = {
            "Grave Ghoul": {"hp_mod": 1.2, "atk_mod": 1.1, "def_mod": 1.3},
            "Crypt Stalker": {"hp_mod": 0.9, "atk_mod": 1.4, "def_mod": 0.8, "spd_mod": 1.2},
            "PlagueBearer": {"hp_mod": 1.0, "atk_mod": 1.0, "def_mod": 1.0, "poison_chance": 0.5},
            "BoneCollector": {"hp_mod": 1.5, "atk_mod": 0.8, "def_mod": 1.6}
        }
        
        variant = variant or random.choice(list(self.variants.keys()))
        stats = self.variants[variant]
        
        self.name = variant
        self.level = level
        self.max_hp = int(120 * stats.get("hp_mod", 1.0) * (1 + (level-1)*0.1))
        self.current_hp = self.max_hp
        self.mp = int(30 * (1 + (level-1)*0.1))
        self.attack = int(15 * stats.get("atk_mod", 1.0) * (1 + (level-1)*0.1))
        self.defense = int(10 * stats.get("def_mod", 1.0) * (1 + (level-1)*0.1))
        self.speed = int(8 * stats.get("spd_mod", 1.0) * (1 + (level-1)*0.1))
        self.poison_chance = stats.get("poison_chance", 0.3)
        self.status_effects = []
        self.is_undead = True
        
        # Gear drops
        self.gear_drops = [
            {"name": "Rotten Bandages", "chance": 0.6, "type": "armor"},
            {"name": "Cursed Charm", "chance": 0.3, "type": "accessory"},
            {"name": "Ghoul Claw", "chance": 0.4, "type": "weapon"},
            {"name": "Tombstone Shard", "chance": 0.2, "type": "material"},
            {"name": "Spectral Essence", "chance": 0.1, "type": "rare"}
        ]
        
        # Escape/KO tracking
        self.is_ko = False
        self.escaped = False
    
    def take_damage(self, damage):
        actual_damage = max(1, damage)
        self.current_hp = max(0, self.current_hp - actual_damage)
        
        # Check for KO
        if self.current_hp <= 0:
            self.is_ko = True
            return f"{self.name} has been defeated!"
        return f"{self.name} takes {actual_damage} damage! ({self.current_hp}/{self.max_hp} HP remaining)"
    
    def attempt_escape(self):
        escape_chance = 0.4  # 40% base escape chance
        if random.random() < escape_chance:
            self.escaped = True
            return True, f"{self.name} vanishes into the shadows!"
        else:
            return False, f"{self.name} tries to escape but fails!"
    
    def attack_target(self, target):
        damage = max(1, self.attack - target.defense // 2)
        result = target.take_damage(damage)
        return f"{self.name} attacks! {result}"
    
    def use_dark_magic(self, target):
        if self.mp >= 10:
            self.mp -= 10
            damage = random.randint(8, 15) + (self.level // 2)
            result = target.take_damage(damage)
            return f"{self.name} casts Dark! {result}"
        else:
            return self.attack_target(target)
    
    def use_poison_claw(self, target):
        damage = max(1, (self.attack // 2) - target.defense // 3)
        result = target.take_damage(damage)
        
        if random.random() < self.poison_chance:
            target.status_effects.append("Poison")
            return f"{self.name}'s poison claw! {result} Target is poisoned!"
        return f"{self.name} uses poison claw! {result}"
    
    def choose_action(self, party):
        if self.escaped or self.is_ko:
            return f"{self.name} is out of battle!"
            
        action_roll = random.random()
        
        # Ghouls might try to escape when badly wounded
        if self.current_hp / self.max_hp < 0.3 and random.random() < 0.3:
            success, message = self.attempt_escape()
            return message
        
        if action_roll < 0.4:
            return self.attack_target(party[0])
        elif action_roll < 0.7 and self.mp >= 10:
            return self.use_dark_magic(party[0])
        else:
            return self.use_poison_claw(party[0])
    
    def generate_loot(self):
        loot = []
        for item in self.gear_drops:
            if random.random() < item["chance"]:
                loot.append(item.copy())  # Return copy of item dict
        return loot
    
    def get_hp_status(self):
        hp_percent = (self.current_hp / self.max_hp) * 100
        if hp_percent >= 70:
            return "Healthy"
        elif hp_percent >= 30:
            return "Wounded"
        elif hp_percent > 0:
            return "Critical"
        else:
            return "KO'd"
    
    def is_alive(self):
        return self.current_hp > 0 and not self.escaped
    
    def __str__(self):
        status = "ESCAPED" if self.escaped else "KO'd" if self.is_ko else self.get_hp_status()
        return f"{self.name} Lv.{self.level} | HP: {self.current_hp}/{self.max_hp} | Status: {status}"

# Example usage and battle simulation
if __name__ == "__main__":
    # Create random ghouls
    ghouls = [Ghoul(random.randint(1, 5)) for _ in range(3)]
    
    print("=== GHOUL ENCOUNTER ===")
    for ghoul in ghouls:
        print(ghoul)
    
    print("\n=== BATTLE SIMULATION ===")
    class DummyTarget:
        def __init__(self):
            self.name = "Hero"
            self.defense = 8
            self.status_effects = []
        
        def take_damage(self, damage):
            return f"{self.name} takes {damage} damage!"
    
    hero = DummyTarget()
    
    for turn in range(3):
        print(f"\n--- Turn {turn + 1} ---")
        for ghoul in ghouls:
            if ghoul.is_alive() and not ghoul.escaped:
                print(ghoul.choose_action([hero]))
    
    print("\n=== POST-BATTLE LOOT ===")
    for ghoul in ghouls:
        if ghoul.is_ko:
            loot = ghoul.generate_loot()
            if loot:
                print(f"{ghoul.name} dropped: {[item['name'] for item in loot]}")
            else:
                print(f"{ghoul.name} dropped nothing.")
Website

