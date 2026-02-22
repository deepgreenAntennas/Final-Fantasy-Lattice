//
//  party_management.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import Foundation
# party_management.py

from typing import List, Dict, Optional
from character_roster import Character

class PartyFormation(Enum):
    BALANCED = "Balanced"
    OFFENSIVE = "Offensive"
    DEFENSIVE = "Defensive"
    MAGICAL = "Magical"
    SPEED = "Speed Focused"
    SPECIALIZED = "Specialized"

class PartyPosition(Enum):
    FRONT = "Frontline"
    MIDDLE = "Midline"
    BACK = "Backline"

class AdvancedPartyManager:
    def __init__(self):
        self.party_members = []
        self.active_formation = PartyFormation.BALANCED
        self.character_positions = {}
        self.party_buffs = []
        self.formation_bonuses = self._initialize_formation_bonuses()
        
    def _initialize_formation_bonuses(self) -> Dict[PartyFormation, Dict]:
        """Initialize bonuses for different formations"""
        return {
            PartyFormation.BALANCED: {
                "defense_bonus": 1.1,
                "attack_bonus": 1.1,
                "description": "Well-rounded performance"
            },
            PartyFormation.OFFENSIVE: {
                "attack_bonus": 1.3,
                "defense_penalty": 0.9,
                "description": "Maximum damage output"
            },
            PartyFormation.DEFENSIVE: {
                "defense_bonus": 1.4,
                "attack_penalty": 0.8,
                "description": "Superior protection"
            },
            PartyFormation.MAGICAL: {
                "magic_bonus": 1.25,
                "mp_regen_bonus": 1.2,
                "description": "Enhanced magical abilities"
            },
            PartyFormation.SPEED: {
                "speed_bonus": 1.3,
                "initiative_bonus": 1.5,
                "description": "Act first in combat"
            },
            PartyFormation.SPECIALIZED: {
                "specialization_bonus": 1.15,
                "versatility_penalty": 0.9,
                "description": "Enhanced class abilities"
            }
        }
    
    def add_party_member(self, character: Character, position: PartyPosition = None):
        """Add a character to the party"""
        if character in self.party_members:
            return f"{character.name} is already in the party!"
        
        self.party_members.append(character)
        
        # Assign default position if not specified
        if position is None:
            position = self._determine_optimal_position(character)
        
        self.character_positions[character.name] = position
        self._update_formation_bonuses()
        
        return f"{character.name} joined the party as {position.value}!"
    
    def _determine_optimal_position(self, character: Character) -> PartyPosition:
        """Determine optimal position based on character stats"""
        if character.stats.get("defense", 0) > character.stats.get("magic", 0):
            return PartyPosition.FRONT
        elif character.stats.get("magic", 0) > character.stats.get("attack", 0):
            return PartyPosition.BACK
        else:
            return PartyPosition.MIDDLE
    
    def set_party_formation(self, formation: PartyFormation):
        """Change party formation"""
        self.active_formation = formation
        self._update_formation_bonuses()
        return f"Party formation changed to {formation.value}"
    
    def _update_formation_bonuses(self):
        """Update active party bonuses based on formation"""
        self.party_buffs = []
        formation_bonus = self.formation_bonuses.get(self.active_formation, {})
        
        for bonus_type, multiplier in formation_bonus.items():
            if "bonus" in bonus_type:
                self.party_buffs.append({
                    "type": bonus_type,
                    "multiplier": multiplier,
                    "source": "formation"
                })
    
    def optimize_party_positions(self) -> Dict:
        """Optimize all character positions for current formation"""
        position_assignments = {
            PartyPosition.FRONT: [],
            PartyPosition.MIDDLE: [],
            PartyPosition.BACK: []
        }
        
        # Sort characters by their suitability for each position
        for character in self.party_members:
            front_score = character.stats.get("defense", 0) + character.stats.get("hp", 0)
            back_score = character.stats.get("magic", 0) + character.stats.get("speed", 0)
            mid_score = character.stats.get("attack", 0) + character.stats.get("luck", 0)
            
            scores = {
                PartyPosition.FRONT: front_score,
                PartyPosition.MIDDLE: mid_score,
                PartyPosition.BACK: back_score
            }
            
            best_position = max(scores.items(), key=lambda x: x[1])[0]
            position_assignments[best_position].append(character.name)
            self.character_positions[character.name] = best_position
        
        self._update_formation_bonuses()
        return position_assignments
    
    def get_party_synergy(self) -> List[Dict]:
        """Calculate synergy bonuses between party members"""
        synergies = []
        
        for i, char1 in enumerate(self.party_members):
            for j, char2 in enumerate(self.party_members):
                if i < j:  # Avoid duplicates
                    synergy = self._calculate_character_synergy(char1, char2)
                    if synergy:
                        synergies.append(synergy)
        
        return synergies
    
    def _calculate_character_synergy(self, char1: Character, char2: Character) -> Optional[Dict]:
        """Calculate synergy between two characters"""
        class_combinations = {
            ("Dimension Hunter", "Lattice Weaver"): {
                "bonus": "Reality Duo",
                "effect": "+15% damage to dimensional enemies",
                "multiplier": 1.15
            },
            ("Ghoul Whisperer", "Chrono Knight"): {
                "bonus": "Time and Death",
                "effect": "Ghoul summons gain temporary haste",
                "multiplier": 1.1
            },
            ("Machine Shaman", "Techno Mage"): {
                "bonus": "Tech Masters",
                "effect": "+25% to tech-related abilities",
                "multiplier": 1.25
            }
        }
        
        combo = (char1.char_class.value, char2.char_class.value)
        if combo in class_combinations:
            return {
                "characters": [char1.name, char2.name],
                "synergy_bonus": class_combinations[combo]
            }
        
        return None
    
    def get_party_status(self) -> Dict:
        """Get comprehensive party status"""
        return {
            "member_count": len(self.party_members),
            "formation": self.active_formation.value,
            "positions": self.character_positions,
            "active_buffs": [buff["type"] for buff in self.party_buffs],
            "synergy_count": len(self.get_party_synergy()),
            "average_level": sum(char.level for char in self.party_members) / len(self.party_members),
            "party_power": self._calculate_party_power()
        }
    
    def _calculate_party_power(self) -> float:
        """Calculate overall party power level"""
        if not self.party_members:
            return 0
        
        total_power = 0
        for char in self.party_members:
            char_power = (
                char.stats.get("attack", 0) +
                char.stats.get("defense", 0) +
                char.stats.get("magic", 0) +
                char.stats.get("speed", 0)
            ) * char.level * 0.01
            total_power += char_power
        
        # Apply formation bonus
        formation_multiplier = 1.0
        for buff in self.party_buffs:
            if "bonus" in buff["type"]:
                formation_multiplier *= buff["multiplier"]
        
        return total_power * formation_multiplier
