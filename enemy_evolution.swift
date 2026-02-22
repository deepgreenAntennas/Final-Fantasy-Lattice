//
//  enemy_evolution.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import Foundation
# enemy_evolution.py

from enum import Enum
from typing import Dict, List, Callable
import random

class EvolutionTrigger(Enum):
    LOW_HP = "Low HP"
    TURN_COUNT = "Turn Count"
    PARTY_SIZE = "Party Size"
    SPECIFIC_ABILITY = "Specific Ability"
    ENVIRONMENT = "Environment"
    TIME_LIMIT = "Time Limit"

class EvolutionStage(Enum):
    BASE = "Base Form"
    EVOLVED = "Evolved Form"
    FINAL = "Final Form"
    ULTIMATE = "Ultimate Form"

class EvolvingEnemy:
    def __init__(self, base_enemy, evolution_tree: Dict):
        self.base_enemy = base_enemy
        self.evolution_tree = evolution_tree
        self.current_stage = EvolutionStage.BASE
        self.evolution_triggers_met = set()
        self.evolution_count = 0
        
    def check_evolution(self, combat_state: Dict) -> bool:
        """Check if evolution conditions are met"""
        for trigger, conditions in self.evolution_tree.items():
            if self._check_trigger_conditions(trigger, conditions, combat_state):
                if self._can_evolve(trigger):
                    return self.evolve(trigger)
        return False
    
    def _check_trigger_conditions(self, trigger: EvolutionTrigger, conditions: Dict, combat_state: Dict) -> bool:
        """Check if trigger conditions are satisfied"""
        if trigger == EvolutionTrigger.LOW_HP:
            hp_percent = (self.base_enemy.stats["hp"] / self.base_enemy.stats["max_hp"]) * 100
            return hp_percent <= conditions.get("threshold", 30)
        
        elif trigger == EvolutionTrigger.TURN_COUNT:
            return combat_state.get("turn_count", 0) >= conditions.get("turns", 5)
        
        elif trigger == EvolutionTrigger.PARTY_SIZE:
            return len(combat_state.get("player_party", [])) <= conditions.get("max_size", 2)
        
        elif trigger == EvolutionTrigger.SPECIFIC_ABILITY:
            return conditions.get("ability_used") in combat_state.get("abilities_used", [])
        
        elif trigger == EvolutionTrigger.ENVIRONMENT:
            return combat_state.get("environment") == conditions.get("required_environment")
        
        elif trigger == EvolutionTrigger.TIME_LIMIT:
            return combat_state.get("time_elapsed", 0) >= conditions.get("time_limit", 60)
        
        return False
    
    def _can_evolve(self, trigger: EvolutionTrigger) -> bool:
        """Check if enemy can evolve further"""
        if trigger in self.evolution_triggers_met:
            return False
        
        # Check evolution stage limits
        max_evolutions = self.evolution_tree.get("max_evolutions", 3)
        return self.evolution_count < max_evolutions
    
    def evolve(self, trigger: EvolutionTrigger) -> bool:
        """Evolve the enemy to next stage"""
        self.evolution_triggers_met.add(trigger)
        self.evolution_count += 1
        
        # Determine next stage
        stage_order = [EvolutionStage.BASE, EvolutionStage.EVOLVED,
                      EvolutionStage.FINAL, EvolutionStage.ULTIMATE]
        current_index = stage_order.index(self.current_stage)
        
        if current_index < len(stage_order) - 1:
            self.current_stage = stage_order[current_index + 1]
            self._apply_evolution_effects()
            return True
        
        return False
    
    def _apply_evolution_effects(self):
        """Apply stat and ability changes for evolution"""
        evolution_effects = {
            EvolutionStage.EVOLVED: {
                "stat_multipliers": {"hp": 1.5, "attack": 1.3, "defense": 1.2},
                "new_abilities": 1,
                "appearance_change": "Enhanced Form"
            },
            EvolutionStage.FINAL: {
                "stat_multipliers": {"hp": 2.0, "attack": 1.6, "defense": 1.4},
                "new_abilities": 2,
                "appearance_change": "Final Form",
                "special_effect": "Phase Shift"
            },
            EvolutionStage.ULTIMATE: {
                "stat_multipliers": {"hp": 3.0, "attack": 2.0, "defense": 1.8},
                "new_abilities": 3,
                "appearance_change": "Ultimate Form",
                "special_effect": "Reality Warp"
            }
        }
        
        effects = evolution_effects.get(self.current_stage, {})
        
        # Apply stat multipliers
        for stat, multiplier in effects.get("stat_multipliers", {}).items():
            if stat in self.base_enemy.stats:
                self.base_enemy.stats[stat] = int(self.base_enemy.stats[stat] * multiplier)
        
        # Add new abilities
        new_ability_count = effects.get("new_abilities", 0)
        for _ in range(new_ability_count):
            new_ability = self._generate_evolution_ability()
            self.base_enemy.abilities.append(new_ability)
        
        # Update appearance
        self.base_enemy.name = f"{effects.get('appearance_change', 'Evolved')} {self.base_enemy.name}"
        
        # Apply special effects
        special_effect = effects.get("special_effect")
        if special_effect:
            self.base_enemy.special_effects.append(special_effect)
    
    def _generate_evolution_ability(self) -> Dict:
        """Generate a new ability for evolved form"""
        evolution_abilities = [
            {"name": "Evolutionary Surge", "power": 35, "type": "magic", "effect": "stats_boost"},
            {"name": "Adaptive Strike", "power": 30, "type": "physical", "effect": "pierce_defense"},
            {"name": "Metamorphic Blast", "power": 40, "type": "aoe", "effect": "damage_over_time"},
            {"name": "Perfect Form", "power": 0, "type": "support", "effect": "full_heal"}
        ]
        
        return random.choice(evolution_abilities)

class EvolutionManager:
    def __init__(self):
        self.evolution_templates = self._initialize_evolution_templates()
    
    def _initialize_evolution_templates(self) -> Dict:
        """Initialize templates for different enemy evolution patterns"""
        return {
            "berserker": {
                EvolutionTrigger.LOW_HP: {"threshold": 25},
                EvolutionTrigger.TURN_COUNT: {"turns": 8},
                "max_evolutions": 2,
                "evolution_style": "Aggressive"
            },
            "strategist": {
                EvolutionTrigger.PARTY_SIZE: {"max_size": 3},
                EvolutionTrigger.SPECIFIC_ABILITY: {"ability_used": "Heal"},
                "max_evolutions": 3,
                "evolution_style": "Tactical"
            },
            "environmental": {
                EvolutionTrigger.ENVIRONMENT: {"required_environment": "Lattice_Nexus"},
                EvolutionTrigger.TIME_LIMIT: {"time_limit": 45},
                "max_evolutions": 2,
                "evolution_style": "Adaptive"
            },
            "ultimate": {
                EvolutionTrigger.LOW_HP: {"threshold": 10},
                EvolutionTrigger.TURN_COUNT: {"turns": 15},
                EvolutionTrigger.SPECIFIC_ABILITY: {"ability_used": "Ultimate"},
                "max_evolutions": 3,
                "evolution_style": "Legendary"
            }
        }
    
    def create_evolving_enemy(self, base_enemy, evolution_type: str) -> EvolvingEnemy:
        """Create an enemy with evolution capabilities"""
        evolution_tree = self.evolution_templates.get(evolution_type, {})
        return EvolvingEnemy(base_enemy, evolution_tree)
    
    def process_combat_round(self, evolving_enemies: List[EvolvingEnemy], combat_state: Dict):
        """Process evolution checks for all evolving enemies"""
        evolutions_occurred = []
        
        for enemy in evolving_enemies:
            if enemy.check_evolution(combat_state):
                evolutions_occurred.append({
                    "enemy": enemy.base_enemy.name,
                    "new_stage": enemy.current_stage.value,
                    "triggers_met": list(enemy.evolution_triggers_met)
                })
        
        return evolutions_occurred
