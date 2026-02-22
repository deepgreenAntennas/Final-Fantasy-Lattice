//
//  GhoulManagerCalendar.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/20/26.
//

import Foundation
# status_effects_manager.py

import random
from enum import Enum
from typing import Dict, List, Callable

class StatusEffect(Enum):
    POISON = "Poison"
    PARALYSIS = "Paralysis"
    BURN = "Burn"
    FREEZE = "Freeze"
    CONFUSION = "Confusion"
    SLEEP = "Sleep"
    REGEN = "Regeneration"
    HASTE = "Haste"
    SLOW = "Slow"
    DEFENSE_UP = "Defense Up"
    DEFENSE_DOWN = "Defense Down"
    ATTACK_UP = "Attack Up"
    ATTACK_DOWN = "Attack Down"

class StatusEffectsManager:
    def __init__(self):
        # Effect definitions with duration and potency
        self.effect_definitions = {
            StatusEffect.POISON: {
                "duration": 3,
                "potency": 5,
                "tick_type": "damage",  # damage, heal, stat_change, control
                "application_message": "{target} is poisoned!",
                "tick_message": "{target} takes {value} poison damage!"
            },
            StatusEffect.PARALYSIS: {
                "duration": 2,
                "potency": 0.4,  # 40% chance to miss turn
                "tick_type": "control",
                "application_message": "{target} is paralyzed!",
                "tick_message": "{target} is stunned!"
            },
            StatusEffect.BURN: {
                "duration": 3,
                "potency": 8,
                "tick_type": "damage",
                "application_message": "{target} is burning!",
                "tick_message": "{target} takes {value} burn damage!"
            },
            StatusEffect.REGEN: {
                "duration": 4,
                "potency": 10,
                "tick_type": "heal",
                "application_message": "{target} is regenerating!",
                "tick_message": "{target} recovers {value} HP!"
            },
            StatusEffect.HASTE: {
                "duration": 3,
                "potency": 1.5,  # Speed multiplier
                "tick_type": "stat_change",
                "stat_affected": "speed",
                "application_message": "{target} is moving faster!"
            },
            StatusEffect.DEFENSE_DOWN: {
                "duration": 3,
                "potency": 0.7,  # Multiplier
                "tick_type": "stat_change",
                "stat_affected": "defense",
                "application_message": "{target}'s defense dropped!"
            }
        }
        
        # Active effects storage
        self.active_effects: Dict[StatusEffect, Dict] = {}

    def apply_effect(self, effect: StatusEffect, target_name: str, custom_potency=None, custom_duration=None):
        """Apply a status effect to a target"""
        if effect not in self.effect_definitions:
            return f"Unknown effect: {effect}"
        
        # Use custom values or defaults
        duration = custom_duration or self.effect_definitions[effect]["duration"]
        potency = custom_potency or self.effect_definitions[effect]["potency"]
        
        # Add or refresh the effect
        self.active_effects[effect] = {
            "duration": duration,
            "remaining": duration,
            "potency": potency,
            "target": target_name
        }
        
        message_template = self.effect_definitions[effect]["application_message"]
        return message_template.format(target=target_name)

    def process_start_of_turn(self):
        """Process all effects at the start of a turn"""
        messages = []
        effects_to_remove = []
        
        for effect, data in self.active_effects.items():
            definition = self.effect_definitions[effect]
            target = data["target"]
            
            # Handle effect based on type
            if definition["tick_type"] == "damage":
                message = definition["tick_message"].format(
                    target=target,
                    value=data["potency"]
                )
                messages.append({"type": "damage", "message": message, "value": data["potency"]})
                
            elif definition["tick_type"] == "heal":
                message = definition["tick_message"].format(
                    target=target,
                    value=data["potency"]
                )
                messages.append({"type": "heal", "message": message, "value": data["potency"]})
                
            elif definition["tick_type"] == "control":
                if random.random() < data["potency"]:  # Chance to trigger
                    message = definition["tick_message"].format(target=target)
                    messages.append({"type": "control", "message": message, "effect": effect})
            
            # Reduce duration
            data["remaining"] -= 1
            if data["remaining"] <= 0:
                effects_to_remove.append(effect)
        
        # Remove expired effects
        for effect in effects_to_remove:
            del self.active_effects[effect]
            messages.append({"type": "expire", "message": f"{effect.value} wears off!"})
        
        return messages

    def get_stat_modifiers(self):
        """Get current stat modifications from active effects"""
        modifiers = {}
        
        for effect, data in self.active_effects.items():
            definition = self.effect_definitions[effect]
            
            if definition["tick_type"] == "stat_change":
                stat = definition["stat_affected"]
                modifier = definition["potency"]
                
                if stat not in modifiers:
                    modifiers[stat] = 1.0  # Base multiplier
                
                modifiers[stat] *= modifier
        
        return modifiers

    def check_action_interruption(self, action_type: str) -> bool:
        """Check if an action should be interrupted by status effects"""
        # Paralysis check
        if StatusEffect.PARALYSIS in self.active_effects:
            if random.random() < self.active_effects[StatusEffect.PARALYSIS]["potency"]:
                return True
        
        # Sleep check
        if StatusEffect.SLEEP in self.active_effects:
            if action_type != "wake":  # Only waking actions allowed
                return True
        
        # Confusion check
        if StatusEffect.CONFUSION in self.active_effects:
            if random.random() < 0.3:  # 30% chance to hit self/ally
                return True
        
        return False

    def clear_all_effects(self):
        """Clear all status effects (for end of battle, etc.)"""
        removed_count = len(self.active_effects)
        self.active_effects.clear()
        return f"All {removed_count} status effects cleared."

    def get_active_effects_status(self):
        """Get a readable string of active effects"""
        if not self.active_effects:
            return "No active effects"
        
        status_list = []
        for effect, data in self.active_effects.items():
            status_list.append(f"{effect.value} ({data['remaining']} turns)")
        
        return ", ".join(status_list)

    def has_effect(self, effect: StatusEffect) -> bool:
        """Check if a specific effect is active"""
        return effect in self.active_effects

# Example usage with Ghoul class integration
class GhoulWithStatusEffects:
    def __init__(self, name="Ghoul"):
        self.name = name
        self.max_hp = 100
        self.current_hp = 100
        self.defense = 10
        self.speed = 8
        self.status_manager = StatusEffectsManager()
    
    def start_of_turn(self):
        """Process status effects at start of ghoul's turn"""
        messages = self.status_manager.process_start_of_turn()
        
        # Apply damage/healing from effects
        for message_data in messages:
            if message_data["type"] == "damage":
                self.current_hp -= message_data["value"]
                print(f"☠️  {message_data['message']}")
            elif message_data["type"] == "heal":
                self.current_hp = min(self.max_hp, self.current_hp + message_data["value"])
                print(f"💚 {message_data['message']}")
            elif message_data["type"] == "control":
                print(f"⚡ {message_data['message']}")
                return False  # Turn skipped due to control effect
            elif message_data["type"] == "expire":
                print(f"🕒 {message_data['message']}")
        
        return True  # Proceed with turn
    
    def attempt_action(self, action_name: str):
        """Check if ghoul can perform an action"""
        if self.status_manager.check_action_interruption(action_name):
            print(f"{self.name} is unable to act due to status effects!")
            return False
        return True
    
    def get_effective_stats(self):
        """Get stats with status effect modifications"""
        base_stats = {
            "defense": self.defense,
            "speed": self.speed
        }
        
        modifiers = self.status_manager.get_stat_modifiers()
        
        for stat, value in base_stats.items():
            if stat in modifiers:
                base_stats[stat] = int(value * modifiers[stat])
        
        return base_stats

# Demo the system
if __name__ == "__main__":
    print("=== STATUS EFFECTS MANAGER DEMO ===\n")
    
    ghoul = GhoulWithStatusEffects("Grave Ghoul")
    
    print("Applying effects to ghoul...")
    print(ghoul.status_manager.apply_effect(StatusEffect.POISON, ghoul.name))
    print(ghoul.status_manager.apply_effect(StatusEffect.PARALYSIS, ghoul.name))
    print(ghoul.status_manager.apply_effect(StatusEffect.DEFENSE_DOWN, ghoul.name))
    
    print(f"\nActive effects: {ghoul.status_manager.get_active_effects_status()}")
    
    print("\n=== PROCESSING 3 TURNS ===")
    for turn in range(1, 4):
        print(f"\n--- Turn {turn} ---")
        print(f"GHoul HP: {ghoul.current_hp}")
        
        # Start of turn processing
        can_act = ghoul.start_of_turn()
        
        if can_act:
            if ghoul.attempt_action("attack"):
                print(f"{ghoul.name} attacks!")
            else:
                print(f"{ghoul.name} cannot attack!")
        else:
            print(f"{ghoul.name} loses their turn!")
        
        print(f"Remaining effects: {ghoul.status_manager.get_active_effects_status()}")
        print(f"Effective stats: {ghoul.get_effective_stats()}")
