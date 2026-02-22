//
//  skill_combos.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import Foundation
# skill_combos.py

from typing import List, Dict, Tuple
import random

class ComboType(Enum):
    DAMAGE = "Damage Combo"
    HEALING = "Healing Combo"
    SUPPORT = "Support Combo"
    ULTIMATE = "Ultimate Combo"
    ENVIRONMENTAL = "Environmental Combo"

class SkillComboSystem:
    def __init__(self):
        self.combo_database = self._initialize_combo_database()
        self.active_combos = []
        self.combo_meter = 0
        self.max_combo_meter = 100
        
    def _initialize_combo_database(self) -> Dict[str, Dict]:
        """Initialize all available skill combinations"""
        return {
            # Damage Combos
            "reality_rend": {
                "name": "Reality Rend",
                "combo_type": ComboType.DAMAGE,
                "required_abilities": ["Reality Slash", "Dimensional Step"],
                "execution": "Sequential",
                "power": 45,
                "effect": "Ignores enemy defense",
                "unlock_level": 10
            },
            "temporal_volley": {
                "name": "Temporal Volley",
                "combo_type": ComboType.DAMAGE,
                "required_abilities": ["Time Slash", "Chrono Shield", "Accelerate"],
                "execution": "Simultaneous",
                "power": 60,
                "effect": "Hits all enemies multiple times",
                "unlock_level": 25
            },
            
            # Healing Combos
            "lattice_restoration": {
                "name": "Lattice Restoration",
                "combo_type": ComboType.HEALING,
                "required_abilities": ["Compassionate Heal", "Protective Aura"],
                "execution": "Sequential",
                "power": 0,
                "effect": "Full party heal with regeneration",
                "unlock_level": 15
            },
            
            # Support Combos
            "quantum_synergy": {
                "name": "Quantum Synergy",
                "combo_type": ComboType.SUPPORT,
                "required_abilities": ["Quantum Entanglement", "Mechanical Symbiosis"],
                "execution": "Simultaneous",
                "power": 0,
                "effect": "Party-wide stat boost",
                "unlock_level": 20
            },
            
            # Ultimate Combos
            "dimensional_collapse": {
                "name": "Dimensional Collapse",
                "combo_type": ComboType.ULTIMATE,
                "required_abilities": ["Existence Erasure", "Void Rend", "Reality Tear"],
                "execution": "Chain",
                "power": 150,
                "effect": "Massive area damage with debuffs",
                "unlock_level": 50
            }
        }
    
    def check_combo_opportunity(self, used_abilities: List[str], party_members: List) -> List[Dict]:
        """Check if used abilities can form combos"""
        available_combos = []
        
        for combo_id, combo_data in self.combo_database.items():
            if self._can_perform_combo(combo_data, used_abilities, party_members):
                available_combos.append({
                    "combo_id": combo_id,
                    "combo_data": combo_data,
                    "readiness": self._calculate_combo_readiness(combo_data, used_abilities)
                })
        
        return available_combos
    
    def _can_perform_combo(self, combo_data: Dict, used_abilities: List[str], party_members: List) -> bool:
        """Check if combo can be performed with current abilities"""
        # Check if all required abilities are available
        required_abilities = combo_data["required_abilities"]
        available_abilities = []
        
        for member in party_members:
            available_abilities.extend([ability["name"] for ability in member.abilities])
        
        if not all(ability in available_abilities for ability in required_abilities):
            return False
        
        # Check if abilities have been used in correct sequence/pattern
        if combo_data["execution"] == "Sequential":
            return self._check_sequential_combo(combo_data, used_abilities)
        elif combo_data["execution"] == "Simultaneous":
            return self._check_simultaneous_combo(combo_data, used_abilities)
        elif combo_data["execution"] == "Chain":
            return self._check_chain_combo(combo_data, used_abilities)
        
        return False
    
    def _check_sequential_combo(self, combo_data: Dict, used_abilities: List[str]) -> bool:
        """Check sequential combo pattern"""
        required = combo_data["required_abilities"]
        # Check if abilities were used in order
        ability_indices = []
        for ability in required:
            if ability in used_abilities:
                ability_indices.append(used_abilities.index(ability))
            else:
                return False
        
        # Verify they were used in order
        return ability_indices == sorted(ability_indices)
    
    def _check_simultaneous_combo(self, combo_data: Dict, used_abilities: List[str]) -> bool:
        """Check simultaneous combo pattern"""
        required = combo_data["required_abilities"]
        # Check if all abilities were used in the same turn
        last_turn_abilities = used_abilities[-len(required):] if len(used_abilities) >= len(required) else []
        return set(required) == set(last_turn_abilities)
    
    def _check_chain_combo(self, combo_data: Dict, used_abilities: List[str]) -> bool:
        """Check chain combo pattern"""
        required = combo_data["required_abilities"]
        # Check if abilities were used consecutively
        for i in range(len(used_abilities) - len(required) + 1):
            if used_abilities[i:i+len(required)] == required:
                return True
        return False
    
    def _calculate_combo_readiness(self, combo_data: Dict, used_abilities: List[str]) -> float:
        """Calculate how close the combo is to being ready"""
        required = combo_data["required_abilities"]
        matches = sum(1 for ability in required if ability in used_abilities)
        return matches / len(required)
    
    def execute_combo(self, combo_id: str, executors: List, targets: List) -> Dict:
        """Execute a skill combo"""
        combo_data = self.combo_database.get(combo_id)
        if not combo_data:
            return {"success": False, "error": "Unknown combo"}
        
        result = {
            "success": True,
            "combo_name": combo_data["name"],
            "combo_type": combo_data["combo_type"].value,
            "executors": [char.name for char in executors],
            "power": combo_data["power"],
            "effect": combo_data["effect"]
        }
        
        # Apply combo effects based on type
        if combo_data["combo_type"] == ComboType.DAMAGE:
            result["damage"] = self._calculate_combo_damage(combo_data, executors)
        elif combo_data["combo_type"] == ComboType.HEALING:
            result["healing"] = self._calculate_combo_healing(combo_data, executors)
        elif combo_data["combo_type"] == ComboType.SUPPORT:
            result["buffs"] = self._apply_combo_buffs(combo_data, executors)
        
        # Increase combo meter
        self.combo_meter = min(self.max_combo_meter, self.combo_meter + 10)
        
        return result
    
    def _calculate_combo_damage(self, combo_data: Dict, executors: List) -> int:
        """Calculate combo damage"""
        base_damage = combo_data["power"]
        executor_bonus = sum(char.stats.get("attack", 0) for char in executors) * 0.1
        return int(base_damage + executor_bonus)
    
    def _calculate_combo_healing(self, combo_data: Dict, executors: List) -> int:
        """Calculate combo healing"""
        base_healing = 50  # Base healing value
        healing_bonus = sum(char.stats.get("magic", 0) for char in executors) * 0.2
        return int(base_healing + healing_bonus)
    
    def _apply_combo_buffs(self, combo_data: Dict, executors: List) -> List[Dict]:
        """Apply combo buffs"""
        buffs = []
        for char in executors:
            buffs.append({
                "character": char.name,
                "stat_increase": {
                    "attack": char.stats.get("attack", 0) * 0.1,
                    "defense": char.stats.get("defense", 0) * 0.1,
                    "magic": char.stats.get("magic", 0) * 0.1
                },
                "duration": 3  # turns
            })
        return buffs
    
    def get_combo_meter_status(self) -> Dict:
        """Get combo meter status"""
        return {
            "current_meter": self.combo_meter,
            "max_meter": self.max_combo_meter,
            "percentage": (self.combo_meter / self.max_combo_meter) * 100,
            "available_combos": [
                combo_id for combo_id, combo_data in self.combo_database.items()
                if self.combo_meter >= combo_data.get("unlock_level", 0) * 10
            ]
        }
    
    def unlock_new_combo(self, combo_id: str) -> bool:
        """Unlock a new combo"""
        if combo_id in self.combo_database:
            self.combo_database[combo_id]["unlocked"] = True
            return True
        return False
