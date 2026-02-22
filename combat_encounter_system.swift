//
//  combat_encounter_system.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import Foundation
# combat_encounter_system.py

class CombatEncounter:
    def __init__(self, player_party: List[Character], enemies: List[Enemy]):
        self.player_party = player_party
        self.enemies = enemies
        self.turn_order = []
        self.current_turn = 0
        self.battle_log = []
        
    def initiate_combat(self):
        """Initialize combat encounter"""
        # Determine turn order based on speed
        all_combatants = self.player_party + self.enemies
        self.turn_order = sorted(all_combatants,
                               key=lambda x: x.stats.get("speed", 0),
                               reverse=True)
        
        self.battle_log.append("🚨 Combat initiated!")
        self.battle_log.append(f"Turn order: {[combatant.name for combatant in self.turn_order]}")
        
        return self.battle_log
    
    def execute_turn(self, character: Character, target: Enemy, ability: Dict):
        """Execute a combat turn"""
        if ability["type"] == "physical":
            damage = self._calculate_damage(character, target, ability)
            target.stats["hp"] -= damage
            
            log_entry = f"⚔️ {character.name} uses {ability['name']} on {target.name} for {damage} damage!"
            if "effect" in ability:
                log_entry += f" ({ability['effect']})"
            
            self.battle_log.append(log_entry)
            
        elif ability["type"] == "magic":
            damage = self._calculate_magic_damage(character, target, ability)
            target.stats["hp"] -= damage
            
            log_entry = f"✨ {character.name} casts {ability['name']} on {target.name} for {damage} damage!"
            self.battle_log.append(log_entry)
        
        # Check if enemy is defeated
        if target.stats["hp"] <= 0:
            self.battle_log.append(f"💀 {target.name} has been defeated!")
            self.enemies.remove(target)
            self.turn_order.remove(target)
    
    def _calculate_damage(self, attacker: Character, defender: Enemy, ability: Dict) -> int:
        """Calculate physical damage"""
        base_damage = attacker.stats["attack"] + ability.get("power", 0)
        defense_reduction = defender.stats["defense"] * 0.5
        damage = max(1, base_damage - defense_reduction)
        
        # Critical hit chance based on luck
        crit_chance = attacker.stats.get("luck", 5) * 0.01
        if random.random() < crit_chance:
            damage = int(damage * 1.5)
            self.battle_log.append("💥 Critical hit!")
        
        return damage
    
    def _calculate_magic_damage(self, attacker: Character, defender: Enemy, ability: Dict) -> int:
        """Calculate magic damage"""
        base_damage = attacker.stats["magic"] + ability.get("power", 0)
        magic_resist_reduction = defender.stats["magic_resist"] * 0.3
        damage = max(1, base_damage - magic_resist_reduction)
        return damage
    
    def enemy_turn(self, enemy: Enemy):
        """Execute enemy AI turn"""
        if not self.player_party:
            return
        
        # Simple AI - attack random player character
        target = random.choice(self.player_party)
        ability = random.choice(enemy.abilities)
        
        if ability["type"] in ["physical", "magic"]:
            damage = self._calculate_damage(enemy, target, ability)
            target.stats["hp"] -= damage
            
            log_entry = f"😈 {enemy.name} uses {ability['name']} on {target.name} for {damage} damage!"
            self.battle_log.append(log_entry)
            
            # Check if player is defeated
            if target.stats["hp"] <= 0:
                self.battle_log.append(f"😵 {target.name} has been knocked out!")
                self.player_party.remove(target)
                self.turn_order.remove(target)
    
    def is_combat_over(self) -> bool:
        """Check if combat is over"""
        return len(self.player_party) == 0 or len(self.enemies) == 0
    
    def get_victory_rewards(self) -> Dict:
        """Calculate victory rewards"""
        if len(self.player_party) == 0:
            return {"victory": False, "rewards": {}}
        
        total_rewards = {
            "credits": 0,
            "exp": 0,
            "items": []
        }
        
        for enemy in self.enemies:
            total_rewards["credits"] += enemy.loot_table["credits"]
            total_rewards["exp"] += enemy.level * 10
            
            # Item drops
            if random.random() < enemy.loot_table["common_items"]:
                total_rewards["items"].append(f"Common_{enemy.enemy_type.value}_Item")
            if random.random() < enemy.loot_table["uncommon_items"]:
                total_rewards["items"].append(f"Uncommon_{enemy.enemy_type.value}_Item")
            if random.random() < enemy.loot_table["rare_items"]:
                total_rewards["items"].append(f"Rare_{enemy.enemy_type.value}_Item")
        
        return {
            "victory": True,
            "rewards": total_rewards,
            "survivors": [char.name for char in self.player_party]
        }

# Example usage
if __name__ == "__main__":
    print("=== CHARACTER ROSTER & ENEMY BESTIARY ===")
    
    # Create character roster
    roster = CharacterRoster()
    print(f"Available characters: {[char.name for char in roster.available_characters]}")
    
    # Form a party
    roster.form_party(["Jen", "Altima", "Kael"])
    party_stats = roster.get_party_stats()
    print(f"\nParty Stats: {party_stats}")
    
    # Check synergies
    synergies = roster.get_character_synergies()
    print(f"\nParty Synergies: {synergies}")
    
    # Create enemy bestiary
    bestiary = EnemyBestiary()
    summary = bestiary.get_bestiary_summary()
    print(f"\nEnemy Bestiary Summary: {summary}")
    
    # Generate an encounter
    encounter_enemies = bestiary.get_encounter(15)
    print(f"\nEncounter Enemies: {[enemy.name for enemy in encounter_enemies]}")
    
    # Simulate combat
    combat = CombatEncounter(roster.active_party, encounter_enemies)
    combat.initiate_combat()
    
    print("\n=== COMBAT SIMULATION ===")
    for log_entry in combat.battle_log:
        print(log_entry)
