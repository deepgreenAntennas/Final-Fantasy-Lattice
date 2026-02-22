//
//  Jen's FIle Management System.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import UIKit

class Jen_s_FIle_Management_System: UITableViewCell {

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
from enum import Enum
from jans_bodysuit import JansBodysuit  # Your previous file

class JenMood(Enum):
    DETERMINED = "Determined"
    MYSTERIOUS = "Mysterious"
    NOSTALGIC = "Nostalgic"
    FOCUSED = "Focused"
    ANXIOUS = "Anxious"

class JenRelationshipLevel(Enum):
    STRANGER = 0
    ACQUAINTANCE = 1
    COMPANION = 2
    TRUSTED = 3
    SOULBOUND = 4

class JensCharacterManager:
    def __init__(self):
        self.name = "Jen"
        self.title = "Dimension Hunter"
        self.level = 1
        self.exp = 0
        self.exp_to_next_level = 100
        
        # Core stats
        self.base_stats = {
            'hp': 80,
            'mp': 50,
            'attack': 12,
            'defense': 8,
            'magic': 15,
            'speed': 14,
            'luck': 10
        }
        
        # Story progression
        self.story_arc = {
            'met_player': False,
            'bodysuit_found': False,
            'first_teleport': False,
            'lattice_revelation': False,
            'final_choice': False
        }
        
        # Relationship system
        self.relationship_level = JenRelationshipLevel.STRANGER
        self.trust_points = 0
        self.decisions_made_together = 0
        
        # Bodysuit integration
        self.bodysuit = JansBodysuit()
        self.bodysuit_equipped = False
        
        # Mood and personality
        self.current_mood = JenMood.DETERMINED
        self.known_lore_fragments = []
        
        # Special abilities unlocked through progression
        self.unlocked_abilities = [
            "Dimensional Scan",
            "Basic Teleport"
        ]

    def gain_exp(self, amount):
        """Level up system for Jen"""
        self.exp += amount
        if self.exp >= self.exp_to_next_level:
            self.level_up()
            return True
        return False

    def level_up(self):
        """Handle Jen's level progression"""
        self.level += 1
        self.exp -= self.exp_to_next_level
        self.exp_to_next_level = int(self.exp_to_next_level * 1.5)
        
        # Stat increases
        stat_increases = {
            'hp': 10,
            'mp': 8,
            'attack': 2,
            'defense': 1,
            'magic': 3,
            'speed': 2,
            'luck': 1
        }
        
        for stat, increase in stat_increases.items():
            self.base_stats[stat] += increase
        
        # Unlock new abilities at certain levels
        new_abilities = {
            3: "Reality Slice",
            5: "Chrono Bubble",
            7: "Lattice Anchor",
            10: "Dimensional Fold"
        }
        
        if self.level in new_abilities:
            self.unlocked_abilities.append(new_abilities[self.level])
        
        return f"Jen reached level {self.level}!"

    def equip_bodysuit(self):
        """Jen equips her signature bodysuit"""
        self.bodysuit_equipped = True
        self.trust_points += 20  # Big relationship boost
        
        # Unlock bodysuit-specific abilities
        bodysuit_abilities = ["Phase Shift", "Mana Weave", "Quantum Parry"]
        self.unlocked_abilities.extend(bodysuit_abilities)
        
        return "The bodysuit hums to life, synchronizing with Jen's biometrics."

    def get_effective_stats(self):
        """Get Jen's stats with bodysuit bonuses"""
        effective_stats = self.base_stats.copy()
        
        if self.bodysuit_equipped:
            suit_bonuses = self.bodysuit.stat_modifiers
            for stat, bonus in suit_bonuses.items():
                if stat in effective_stats:
                    effective_stats[stat] += bonus
        
        # Apply level multiplier
        level_multiplier = 1 + (self.level - 1) * 0.1
        for stat in effective_stats:
            effective_stats[stat] = int(effective_stats[stat] * level_multiplier)
        
        return effective_stats

    def increase_trust(self, amount):
        """Increase trust points and check for relationship level ups"""
        self.trust_points += amount
        old_level = self.relationship_level
        
        # Trust thresholds for each level
        trust_thresholds = {
            JenRelationshipLevel.STRANGER: 0,
            JenRelationshipLevel.ACQUAINTANCE: 50,
            JenRelationshipLevel.COMPANION: 150,
            JenRelationshipLevel.TRUSTED: 300,
            JenRelationshipLevel.SOULBOUND: 500
        }
        
        for level, threshold in trust_thresholds.items():
            if self.trust_points >= threshold:
                self.relationship_level = level
        
        if self.relationship_level != old_level:
            return f"Your relationship with Jen has deepened! ({old_level.value} → {self.relationship_level.value})"
        return None

    def get_dialogue(self, context):
        """Get context-appropriate dialogue from Jen"""
        dialogue_templates = {
            'greeting': {
                JenRelationshipLevel.STRANGER: "State your business.",
                JenRelationshipLevel.ACQUAINTANCE: "You again. What do you need?",
                JenRelationshipLevel.COMPANION: "Good to see you. What's the plan?",
                JenRelationshipLevel.TRUSTED: "Hey! Ready for our next move?",
                JenRelationshipLevel.SOULBOUND: "I was hoping you'd come by. What's next, partner?"
            },
            'battle': {
                JenMood.DETERMINED: "Let's finish this!",
                JenMood.MYSTERIOUS: "The lattice trembles with opportunity...",
                JenMood.ANXIOUS: "I hope this works...",
                JenMood.FOCUSED: "Target locked. Engaging."
            },
            'story_revelation': [
                "The bodysuit is showing me something...",
                "Another piece of the puzzle falls into place.",
                "I remember now... fragments of another time.",
                "The lattice patterns are becoming clearer."
            ]
        }
        
        if context in dialogue_templates:
            if isinstance(dialogue_templates[context], dict):
                # Relationship or mood-based dialogue
                if self.relationship_level in dialogue_templates[context]:
                    return dialogue_templates[context][self.relationship_level]
                elif self.current_mood in dialogue_templates[context]:
                    return dialogue_templates[context][self.current_mood]
            else:
                # Random choice from list
                return random.choice(dialogue_templates[context])
        
        return "..."

    def advance_story_arc(self, milestone):
        """Progress Jen's personal story"""
        if milestone in self.story_arc:
            self.story_arc[milestone] = True
            trust_gain = 25  # Base trust for story progress
            
            if milestone == 'lattice_revelation':
                self.unlocked_abilities.append("Lattice Sight")
                trust_gain = 50
            
            trust_message = self.increase_trust(trust_gain)
            return f"Story progressed: {milestone}. " + (trust_message or "")
        
        return "Unknown story milestone."

    def use_ability(self, ability_name, target=None):
        """Jen uses one of her special abilities"""
        if ability_name not in self.unlocked_abilities:
            return f"Jen hasn't unlocked {ability_name} yet."
        
        ability_effects = {
            "Dimensional Scan": "Jen analyzes the target, revealing weaknesses and resistances.",
            "Basic Teleport": "Jen instantly moves to a new position, avoiding danger.",
            "Reality Slice": "Jen tears a temporary rift in reality, damaging enemies.",
            "Lattice Sight": "Jen sees the flows of reality, gaining tactical advantage."
        }
        
        effect = ability_effects.get(ability_name, "Jen uses a mysterious ability.")
        
        # Cost and cooldown could be added here
        return effect

    def get_status_report(self):
        """Get a comprehensive status report on Jen"""
        stats = self.get_effective_stats()
        
        report = f"""
=== JEN STATUS REPORT ===
Level: {self.level}
EXP: {self.exp}/{self.exp_to_next_level}
Relationship: {self.relationship_level.value} ({self.trust_points} points)
Mood: {self.current_mood.value}
Bodysuit: {'EQUIPPED' if self.bodysuit_equipped else 'Not Equipped'}

STATS:
  HP: {stats['hp']} | MP: {stats['mp']}
  Attack: {stats['attack']} | Defense: {stats['defense']}
  Magic: {stats['magic']} | Speed: {stats['speed']}

STORY PROGRESS:
  Met Player: {self.story_arc['met_player']}
  Bodysuit Found: {self.story_arc['bodysuit_found']}
  Lattice Revelation: {self.story_arc['lattice_revelation']}

ABILITIES: {', '.join(self.unlocked_abilities)}
        """
        return report

# Supporting files for Jen's system:
class JensQuestManager:
    """Manages Jen's personal questline"""
    def __init__(self):
        self.available_quests = [
            "Find the Chronos Lab",
            "Decrypt the Bodysuit's Memory",
            "Locate the First Lattice Point",
            "Confront the Ghost in the Machine"
        ]
        self.completed_quests = []
        self.active_quest = None

class JensInventoryManager:
    """Manages Jen's personal inventory and gear"""
    def __init__(self):
        self.personal_items = []
        self.dimensional_artifacts = []
        self.lattice_crystals = 0

# Example usage
if __name__ == "__main__":
    print("=== JEN CHARACTER MANAGER DEMO ===\n")
    
    jen = JensCharacterManager()
    
    # Basic interaction
    print(jen.get_dialogue('greeting'))
    print(f"Starting level: {jen.level}")
    
    # Level up
    jen.gain_exp(150)
    print(jen.level_up())
    
    # Story progression
    print(jen.advance_story_arc('met_player'))
    print(jen.advance_story_arc('bodysuit_found'))
    
    # Equip bodysuit
    print(jen.equip_bodysuit())
    
    # Relationship development
    print(jen.increase_trust(75))
    
    # Final status
    print(jen.get_status_report())
