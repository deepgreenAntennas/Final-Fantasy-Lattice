//
//  game_levels.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import Foundation
# game_levels.py

from enum import Enum
from typing import Dict, List, Any
import random

class GameDifficulty(Enum):
    NORMAL = "Normal"
    HARD = "Hard"
    EXPERT = "Expert"
    LATTICE_MASTER = "Lattice Master"

class GameLevel:
    def __init__(self, level_number: int, difficulty: GameDifficulty = GameDifficulty.NORMAL):
        self.level_number = level_number
        self.difficulty = difficulty
        self.zone_name = self._generate_zone_name()
        self.enemy_scaling = self._calculate_enemy_scaling()
        self.reward_scaling = self._calculate_reward_scaling()
        self.objectives = self._generate_objectives()
        self.boss_encounter = self._generate_boss()
        self.secret_areas = self._generate_secret_areas()
        
    def _generate_zone_name(self) -> str:
        """Generate lore-appropriate zone names"""
        zone_types = {
            1-10: ["Chronos Ruins", "Abandoned Lab", "Research Outpost"],
            11-20: ["Industrial Wasteland", "Factory District", "Machine Graveyard"],
            21-30: ["Lattice Nexus", "Dimensional Crossroads", "Reality Fracture"],
            31-40: ["Ghoul Metropolis", "Undercity", "Bone Cathedral"],
            41-50: ["Temporal Observatory", "Time Garden", "Echo Chamber"],
            51-60: ["Machine Spirit Core", "AI Nexus", "Digital Realm"],
            61-70: ["Void Border", "Reality's Edge", "Final Threshold"],
            71-100: ["Lattice Heart", "Creation Core", "Ultimate Nexus"]
        }
        
        for range_key, names in zone_types.items():
            if isinstance(range_key, int):
                if self.level_number == range_key:
                    return random.choice(names)
            else:
                start, end = range_key
                if start <= self.level_number <= end:
                    return random.choice(names)
        
        return f"Mysterious Zone {self.level_number}"
    
    def _calculate_enemy_scaling(self) -> Dict:
        """Calculate enemy scaling based on level and difficulty"""
        base_power = self.level_number * 10
        difficulty_multiplier = {
            GameDifficulty.NORMAL: 1.0,
            GameDifficulty.HARD: 1.5,
            GameDifficulty.EXPERT: 2.0,
            GameDifficulty.LATTICE_MASTER: 3.0
        }
        
        return {
            "hp_multiplier": base_power * difficulty_multiplier[self.difficulty],
            "damage_multiplier": base_power * 0.1 * difficulty_multiplier[self.difficulty],
            "spawn_rate": min(1.0, 0.1 + (self.level_number * 0.02)),
            "elite_chance": min(0.3, self.level_number * 0.01)
        }
    
    def _calculate_reward_scaling(self) -> Dict:
        """Calculate reward scaling based on level and difficulty"""
        base_reward = self.level_number * 25
        difficulty_bonus = {
            GameDifficulty.NORMAL: 1.0,
            GameDifficulty.HARD: 1.25,
            GameDifficulty.EXPERT: 1.5,
            GameDifficulty.LATTICE_MASTER: 2.0
        }
        
        return {
            "credits": int(base_reward * difficulty_bonus[self.difficulty]),
            "lattice_crystals": max(1, int(self.level_number * 0.5)),
            "item_rarity_boost": min(0.5, self.level_number * 0.01),
            "exp_multiplier": 1.0 + (self.level_number * 0.02)
        }
    
    def _generate_objectives(self) -> List[Dict]:
        """Generate level objectives"""
        objectives = []
        
        # Primary objective (always present)
        primary_obj = {
            "type": "primary",
            "description": f"Reach the heart of {self.zone_name}",
            "reward": self.reward_scaling["credits"] * 2,
            "required": True
        }
        objectives.append(primary_obj)
        
        # Secondary objectives (based on level)
        if self.level_number % 5 == 0:
            objectives.append({
                "type": "boss",
                "description": f"Defeat the guardian of {self.zone_name}",
                "reward": self.reward_scaling["credits"] * 3,
                "required": False
            })
        
        if self.level_number > 10:
            objectives.append({
                "type": "exploration",
                "description": f"Discover all secret areas in {self.zone_name}",
                "reward": self.reward_scaling["lattice_crystals"] * 2,
                "required": False
            })
        
        if self.level_number > 25:
            objectives.append({
                "type": "challenge",
                "description": f"Complete without using healing items",
                "reward": self.reward_scaling["credits"] * 1.5,
                "required": False
            })
        
        return objectives
    
    def _generate_boss(self) -> Dict:
        """Generate boss encounter for the level"""
        if self.level_number % 10 == 0:  # Every 10 levels
            boss_tiers = {
                10: ["Lab Director", "Chronos Sentinel", "Experiment Gone Wrong"],
                20: ["Factory Overmind", "Rogue AI", "Mechanical Titan"],
                30: ["Lattice Weaver", "Dimensional Horror", "Reality Eater"],
                40: ["Ghoul King", "Bone Monarch", "Plague Emperor"],
                50: ["Time Devourer", "Chrono Dragon", "Temporal Paradox"],
                60: ["Machine God", "AI Overlord", "Digital Deity"],
                70: ["Void Walker", "Edge Guardian", "Final Barrier"],
                80: ["Lattice Heart", "Creation Guardian", "Ultimate Being"],
                90: ["The Architect", "Reality Smith", "Final Boss"],
                100: ["The True End", "Absolute Finality", "Game Master"]
            }
            
            boss_name = random.choice(boss_tiers.get(self.level_number, ["Mysterious Entity"]))
            
            return {
                "name": boss_name,
                "level": self.level_number * 2,
                "health": self.level_number * 1000,
                "reward_multiplier": 5.0,
                "special_abilities": self._generate_boss_abilities()
            }
        
        return None
    
    def _generate_boss_abilities(self) -> List[str]:
        """Generate unique boss abilities"""
        abilities_pool = [
            "Time Stop", "Reality Warp", "Dimension Shift", "Lattice Overload",
            "Mass Teleport", "Elemental Fusion", "Ultimate Attack", "Phase Change",
            "Healing Factor", "Damage Reflection", "Summon Minions", "Area Denial"
        ]
        
        return random.sample(abilities_pool, min(4, self.level_number // 10))
    
    def _generate_secret_areas(self) -> List[Dict]:
        """Generate secret areas for exploration"""
        secrets = []
        secret_chance = 0.3 + (self.level_number * 0.01)  # More secrets at higher levels
        
        if random.random() < secret_chance:
            secret_types = ["hidden_chamber", "lost_archive", "treasure_vault", "ancient_artifact"]
            secrets.append({
                "type": random.choice(secret_types),
                "difficulty": self.level_number + 5,
                "reward": self.reward_scaling["credits"] * 2,
                "special_item": random.choice([True, False])
            })
        
        return secrets

class LevelProgressionSystem:
    def __init__(self):
        self.levels = {}
        self.player_level = 1
        self.completed_levels = set()
        self.current_difficulty = GameDifficulty.NORMAL
        
    def generate_level(self, level_number: int) -> GameLevel:
        """Generate or retrieve a game level"""
        if level_number not in self.levels:
            self.levels[level_number] = GameLevel(level_number, self.current_difficulty)
        
        return self.levels[level_number]
    
    def complete_level(self, level_number: int, objectives_completed: List[str]) -> Dict:
        """Mark a level as completed and calculate rewards"""
        level = self.generate_level(level_number)
        self.completed_levels.add(level_number)
        
        # Calculate total rewards
        total_rewards = {
            "credits": 0,
            "lattice_crystals": 0,
            "exp": level.level_number * 100,
            "items": []
        }
        
        # Base completion reward
        total_rewards["credits"] += level.reward_scaling["credits"]
        total_rewards["lattice_crystals"] += level.reward_scaling["lattice_crystals"]
        
        # Objective rewards
        for objective in level.objectives:
            if objective["type"] in objectives_completed:
                if "credits" in objective.get("reward", {}):
                    total_rewards["credits"] += objective["reward"]
                else:
                    total_rewards["credits"] += objective.get("reward", 0)
                
                if "lattice_crystals" in objective.get("reward", {}):
                    total_rewards["lattice_crystals"] += objective["reward"]["lattice_crystals"]
        
        # Boss reward (if applicable)
        if level.boss_encounter and "boss" in objectives_completed:
            total_rewards["credits"] = int(total_rewards["credits"] * level.boss_encounter["reward_multiplier"])
        
        # Secret area rewards
        for secret in level.secret_areas:
            if secret["type"] in objectives_completed:
                total_rewards["credits"] += secret["reward"]
                if secret["special_item"]:
                    total_rewards["items"].append(f"Secret_Item_Level{level_number}")
        
        return {
            "level": level_number,
            "rewards": total_rewards,
            "zone": level.zone_name,
            "next_level_unlocked": level_number + 1,
            "completion_time": f"{random.randint(5, 30)} minutes"
        }
    
    def get_level_range(self, start: int, end: int) -> List[GameLevel]:
        """Get a range of levels"""
        return [self.generate_level(i) for i in range(start, end + 1)]
    
    def increase_difficulty(self):
        """Increase the game difficulty"""
        difficulties = list(GameDifficulty)
        current_index = difficulties.index(self.current_difficulty)
        
        if current_index < len(difficulties) - 1:
            self.current_difficulty = difficulties[current_index + 1]
            # Regenerate levels with new difficulty
            self.levels = {}
            
        return f"Difficulty increased to {self.current_difficulty.value}"
    
    def get_progression_stats(self) -> Dict:
        """Get player progression statistics"""
        total_levels = max(self.levels.keys()) if self.levels else 0
        
        return {
            "player_level": self.player_level,
            "levels_completed": len(self.completed_levels),
            "completion_percentage": (len(self.completed_levels) / total_levels * 100) if total_levels > 0 else 0,
            "current_difficulty": self.current_difficulty.value,
            "total_credits_earned": self._calculate_total_earnings(),
            "secret_areas_found": self._count_secret_areas(),
            "bosses_defeated": self._count_bosses_defeated()
        }
    
    def _calculate_total_earnings(self) -> int:
        """Calculate total credits earned from all completed levels"""
        total = 0
        for level_num in self.completed_levels:
            level = self.generate_level(level_num)
            total += level.reward_scaling["credits"]
        return total
    
    def _count_secret_areas(self) -> int:
        """Count secret areas found"""
        count = 0
        for level_num in self.completed_levels:
            level = self.generate_level(level_num)
            count += len(level.secret_areas)
        return count
    
    def _count_bosses_defeated(self) -> int:
        """Count bosses defeated"""
        return len([l for l in self.completed_levels if l % 10 == 0])

# Generate levels 1-1000 with increasing complexity
def generate_game_world():
    progression = LevelProgressionSystem()
    
    print("=== GENERATING GAME WORLD (Levels 1-1000) ===")
    
    # Generate sample levels at different tiers
    sample_levels = [1, 10, 25, 50, 75, 100, 250, 500, 750, 1000]
    
    for level_num in sample_levels:
        level = progression.generate_level(level_num)
        print(f"\n--- Level {level_num}: {level.zone_name} ---")
        print(f"Enemy Scaling: {level.enemy_scaling['hp_multiplier']:.1f}x HP")
        print(f"Rewards: {level.reward_scaling['credits']} credits")
        print(f"Objectives: {len(level.objectives)}")
        
        if level.boss_encounter:
            print(f"Boss: {level.boss_encounter['name']} (Level {level.boss_encounter['level']})")
    
    return progression

if __name__ == "__main__":
    game_world = generate_game_world()
    
    # Simulate progression
    for level in range(1, 11):
        result = game_world.complete_level(level, ["primary", "exploration"])
        print(f"Completed Level {level}: {result['rewards']['credits']} credits earned")
    
    print(f"\nProgression Stats: {game_world.get_progression_stats()}")
