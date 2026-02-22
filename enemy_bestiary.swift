//
//  enemy_bestiary.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import Foundation
# enemy_bestiary.py

from enum import Enum
from typing import Dict, List, Optional
import random

class EnemyType(Enum):
    GHOUL = "Ghoul"
    MACHINE = "Machine"
    DIMENSIONAL = "Dimensional"
    HUMAN = "Human"
    BOSS = "Boss"
    ELITE = "Elite"
    MINIBOSS = "Miniboss"

class Enemy:
    def __init__(self, name: str, enemy_type: EnemyType, level: int):
        self.name = name
        self.enemy_type = enemy_type
        self.level = level
        self.stats = self._initialize_stats()
        self.abilities = self._initialize_abilities()
        self.loot_table = self._initialize_loot()
        self.behavior_pattern = self._get_behavior_pattern()
        
    def _initialize_stats(self) -> Dict:
        """Initialize enemy stats based on type and level"""
        base_stats = {
            "hp": 50 + (self.level * 10),
            "attack": 8 + (self.level * 2),
            "defense": 5 + (self.level * 1),
            "speed": 6 + (self.level * 1),
            "magic_resist": 3 + (self.level * 0.5)
        }
        
        type_modifiers = {
            EnemyType.GHOUL: {"hp": 1.3, "attack": 1.1, "defense": 0.9},
            EnemyType.MACHINE: {"hp": 1.1, "defense": 1.4, "magic_resist": 0.7},
            EnemyType.DIMENSIONAL: {"hp": 0.8, "attack": 1.3, "speed": 1.2},
            EnemyType.HUMAN: {"hp": 1.0, "attack": 1.0, "defense": 1.0},
            EnemyType.BOSS: {"hp": 5.0, "attack": 2.0, "defense": 2.0},
            EnemyType.ELITE: {"hp": 2.0, "attack": 1.5, "defense": 1.5},
            EnemyType.MINIBOSS: {"hp": 3.0, "attack": 1.8, "defense": 1.8}
        }
        
        # Apply type modifiers
        modifiers = type_modifiers.get(self.enemy_type, {})
        for stat, multiplier in modifiers.items():
            if stat in base_stats:
                base_stats[stat] = int(base_stats[stat] * multiplier)
        
        return base_stats
    
    def _initialize_abilities(self) -> List[Dict]:
        """Initialize enemy abilities based on type"""
        abilities_db = {
            EnemyType.GHOUL: [
                {"name": "Cursed Claw", "power": 15, "type": "physical", "effect": "poison"},
                {"name": "Grave Stench", "power": 10, "type": "magic", "effect": "debuff"},
                {"name": "Undead Resilience", "power": 0, "type": "passive", "effect": "damage_reduction"}
            ],
            EnemyType.MACHINE: [
                {"name": "Laser Blast", "power": 20, "type": "energy", "effect": "burn"},
                {"name": "System Overload", "power": 25, "type": "aoe", "effect": "stun"},
                {"name": "Repair Protocol", "power": 0, "type": "heal", "effect": "self_heal"}
            ],
            EnemyType.DIMENSIONAL: [
                {"name": "Reality Tear", "power": 22, "type": "magic", "effect": "ignore_defense"},
                {"name": "Phase Shift", "power": 0, "type": "defensive", "effect": "dodge"},
                {"name": "Lattice Resonance", "power": 18, "type": "aoe", "effect": "confuse"}
            ],
            EnemyType.HUMAN: [
                {"name": "Precise Strike", "power": 16, "type": "physical", "effect": "critical"},
                {"name": "Tactical Retreat", "power": 0, "type": "support", "effect": "heal"},
                {"name": "Team Attack", "power": 20, "type": "cooperative", "effect": "boost"}
            ]
        }
        
        # Bosses get enhanced abilities
        if self.enemy_type in [EnemyType.BOSS, EnemyType.MINIBOSS]:
            base_abilities = abilities_db.get(EnemyType.DIMENSIONAL, [])  # Default to dimensional
            enhanced_abilities = []
            for ability in base_abilities:
                enhanced = ability.copy()
                enhanced["power"] = int(enhanced["power"] * 2.5)
                enhanced_abilities.append(enhanced)
            return enhanced_abilities
        
        return abilities_db.get(self.enemy_type, [])
    
    def _initialize_loot(self) -> Dict:
        """Initialize enemy loot table"""
        base_loot = {
            "credits": random.randint(self.level * 5, self.level * 15),
            "common_items": 0.6,  # 60% chance for common item
            "uncommon_items": 0.3,  # 30% chance for uncommon
            "rare_items": 0.1,  # 10% chance for rare
            "special_drops": 0.05  # 5% chance for special drop
        }
        
        # Enhance loot for special enemies
        if self.enemy_type == EnemyType.BOSS:
            base_loot["credits"] *= 10
            base_loot["rare_items"] = 1.0  # Guaranteed rare item
            base_loot["special_drops"] = 0.5  # 50% chance for special
            
        elif self.enemy_type == EnemyType.ELITE:
            base_loot["credits"] *= 3
            base_loot["uncommon_items"] = 0.6
            base_loot["rare_items"] = 0.2
            
        return base_loot
    
    def _get_behavior_pattern(self) -> Dict:
        """Get AI behavior pattern"""
        patterns = {
            EnemyType.GHOUL: {"aggression": 0.8, "intelligence": 0.3, "cunning": 0.6},
            EnemyType.MACHINE: {"aggression": 0.5, "intelligence": 0.9, "cunning": 0.4},
            EnemyType.DIMENSIONAL: {"aggression": 0.7, "intelligence": 0.8, "cunning": 0.9},
            EnemyType.HUMAN: {"aggression": 0.6, "intelligence": 0.7, "cunning": 0.8},
            EnemyType.BOSS: {"aggression": 0.9, "intelligence": 1.0, "cunning": 0.9}
        }
        
        return patterns.get(self.enemy_type, {"aggression": 0.5, "intelligence": 0.5, "cunning": 0.5})

class EnemyBestiary:
    def __init__(self):
        self.enemy_database = self._initialize_database()
        self.encounter_tables = self._initialize_encounter_tables()
        
    def _initialize_database(self) -> Dict[str, Enemy]:
        """Initialize the enemy database with a variety of enemies"""
        enemies = {}
        
        # Ghoul Types
        ghoul_variants = [
            ("Grave Ghoul", 1, EnemyType.GHOUL),
            ("Plaguebearer", 5, EnemyType.GHOUL),
            ("Bone Collector", 10, EnemyType.GHOUL),
            ("Crypt Stalker", 15, EnemyType.GHOUL),
            ("Ghoul King", 50, EnemyType.BOSS)
        ]
        
        # Machine Types
        machine_variants = [
            ("Security Bot", 2, EnemyType.MACHINE),
            ("Factory Drone", 8, EnemyType.MACHINE),
            ("Combat Android", 12, EnemyType.MACHINE),
            ("Siege Mech", 25, EnemyType.ELITE),
            ("AI Overlord", 60, EnemyType.BOSS)
        ]
        
        # Dimensional Types
        dimensional_variants = [
            ("Reality Fracture", 3, EnemyType.DIMENSIONAL),
            ("Void Phantom", 9, EnemyType.DIMENSIONAL),
            ("Lattice Anomaly", 18, EnemyType.DIMENSIONAL),
            ("Time Eater", 35, EnemyType.MINIBOSS),
            ("Dimensional Horror", 75, EnemyType.BOSS)
        ]
        
        # Human Types
        human_variants = [
            ("Raider", 4, EnemyType.HUMAN),
            ("Mercenary", 7, EnemyType.HUMAN),
            ("Chronos Guard", 14, EnemyType.HUMAN),
            ("Lattice Hunter", 22, EnemyType.ELITE),
            ("Rogue Agent", 45, EnemyType.MINIBOSS)
        ]
        
        # Add all enemies to database
        all_variants = ghoul_variants + machine_variants + dimensional_variants + human_variants
        
        for name, level, enemy_type in all_variants:
            enemies[name.lower()] = Enemy(name, enemy_type, level)
        
        return enemies
    
    def _initialize_encounter_tables(self) -> Dict[int, List]:
        """Initialize encounter tables by level range"""
        tables = {}
        
        # Level 1-10 encounters
        tables[1] = [
            {"enemy": "grave ghoul", "weight": 40},
            {"enemy": "security bot", "weight": 30},
            {"enemy": "raider", "weight": 30}
        ]
        
        # Level 11-25 encounters
        tables[11] = [
            {"enemy": "plaguebearer", "weight": 25},
            {"enemy": "combat android", "weight": 25},
            {"enemy": "void phantom", "weight": 20},
            {"enemy": "chronos guard", "weight": 20},
            {"enemy": "crypt stalker", "weight": 10}
        ]
        
        # Level 26-50 encounters
        tables[26] = [
            {"enemy": "bone collector", "weight": 20},
            {"enemy": "siege mech", "weight": 20},
            {"enemy": "lattice anomaly", "weight": 20},
            {"enemy": "lattice hunter", "weight": 15},
            {"enemy": "time eater", "weight": 15},
            {"enemy": "rogue agent", "weight": 10}
        ]
        
        # Level 51-100 encounters (add more as needed)
        tables[51] = [
            {"enemy": "ghoul king", "weight": 5},
            {"enemy": "ai overlord", "weight": 5},
            {"enemy": "dimensional horror", "weight": 5},
            {"enemy": "elite variants", "weight": 85}
        ]
        
        return tables
    
    def get_encounter(self, player_level: int) -> List[Enemy]:
        """Generate an encounter appropriate for player level"""
        # Find the right encounter table
        encounter_level = 1
        for level_threshold in sorted(self.encounter_tables.keys(), reverse=True):
            if player_level >= level_threshold:
                encounter_level = level_threshold
                break
        
        encounter_table = self.encounter_tables[encounter_level]
        
        # Select enemies based on weights
        enemy_names = []
        total_weight = sum(entry["weight"] for entry in encounter_table)
        
        # Determine encounter size (1-6 enemies)
        encounter_size = random.randint(1, min(6, max(1, player_level // 10)))
        
        for _ in range(encounter_size):
            roll = random.randint(1, total_weight)
            current_weight = 0
            
            for entry in encounter_table:
                current_weight += entry["weight"]
                if roll <= current_weight:
                    # Scale enemy level to player level
                    base_enemy = self.enemy_database[entry["enemy"].lower()]
                    scaled_level = max(base_enemy.level,
                                     min(player_level, base_enemy.level + 10))
                    
                    # Create scaled enemy
                    scaled_enemy = Enemy(
                        base_enemy.name,
                        base_enemy.enemy_type,
                        scaled_level
                    )
                    enemy_names.append(scaled_enemy)
                    break
        
        return enemy_names
    
    def get_boss_encounter(self, level: int) -> Enemy:
        """Get an appropriate boss for the level"""
        boss_level = min(100, max(10, level))
        
        # Select boss based on level tier
        if boss_level < 25:
            boss_name = "ghoul king"
        elif boss_level < 50:
            boss_name = "ai overlord"
        elif boss_level < 75:
            boss_name = "dimensional horror"
        else:
            boss_name = "ultimate boss"  # You can add more bosses
        
        base_boss = self.enemy_database[boss_name]
        scaled_boss = Enemy(base_boss.name, base_boss.enemy_type, boss_level)
        return scaled_boss
    
    def get_enemy_by_name(self, name: str) -> Optional[Enemy]:
        """Get an enemy by name"""
        return self.enemy_database.get(name.lower())
    
    def get_enemies_by_type(self, enemy_type: EnemyType) -> List[Enemy]:
        """Get all enemies of a specific type"""
        return [enemy for enemy in self.enemy_database.values()
                if enemy.enemy_type == enemy_type]
    
    def get_bestiary_summary(self) -> Dict:
        """Get summary of the bestiary"""
        type_counts = {}
        level_ranges = {}
        
        for enemy in self.enemy_database.values():
            # Count by type
            enemy_type = enemy.enemy_type.value
            type_counts[enemy_type] = type_counts.get(enemy_type, 0) + 1
            
            # Track level ranges
            if enemy_type not in level_ranges:
                level_ranges[enemy_type] = {"min": enemy.level, "max": enemy.level}
            else:
                level_ranges[enemy_type]["min"] = min(level_ranges[enemy_type]["min"], enemy.level)
                level_ranges[enemy_type]["max"] = max(level_ranges[enemy_type]["max"], enemy.level)
        
        return {
            "total_enemies": len(self.enemy_database),
            "enemies_by_type": type_counts,
            "level_ranges": level_ranges,
            "encounter_tables": len(self.encounter_tables)
        }
