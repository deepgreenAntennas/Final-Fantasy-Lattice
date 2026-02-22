//
//  character_customization.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/21/26.
//

import Foundation
# character_customization.py

from enum import Enum
from typing import Dict, List, Any, Optional
import random

class AppearanceFeature(Enum):
    HAIR_STYLE = "Hair Style"
    HAIR_COLOR = "Hair Color"
    EYE_COLOR = "Eye Color"
    SKIN_TONE = "Skin Tone"
    BUILD = "Build"
    SCARS = "Scars"
    TATTOOS = "Tattoos"
    ACCESSORIES = "Accessories"

class PersonalityTrait(Enum):
    BRAVE = "Brave"
    CUNNING = "Cunning"
    KIND = "Kind"
    ARROGANT = "Arrogant"
    MYSTERIOUS = "Mysterious"
    HUMOROUS = "Humorous"
    SERIOUS = "Serious"
    RECKLESS = "Reckless"

class CharacterCustomization:
    def __init__(self):
        self.appearance_options = self._initialize_appearance_options()
        self.personality_traits = self._initialize_personality_traits()
        self.voice_options = self._initialize_voice_options()
        
    def _initialize_appearance_options(self) -> Dict[AppearanceFeature, List[str]]:
        """Initialize all appearance customization options"""
        return {
            AppearanceFeature.HAIR_STYLE: [
                "Short", "Long", "Ponytail", "Braided", "Messy", "Elegant",
                "Spiky", "Undercut", "Bob", "Afro", "Dreadlocks", "Balding"
            ],
            AppearanceFeature.HAIR_COLOR: [
                "Black", "Brown", "Blonde", "Red", "Silver", "White",
                "Blue", "Purple", "Green", "Rainbow", "Platinum"
            ],
            AppearanceFeature.EYE_COLOR: [
                "Brown", "Blue", "Green", "Hazel", "Gray", "Purple",
                "Red", "Gold", "Heterochromatic", "Glowing"
            ],
            AppearanceFeature.SKIN_TONE: [
                "Pale", "Fair", "Light", "Medium", "Olive", "Tan",
                "Brown", "Dark", "Ebony", "Metallic", "Spectral"
            ],
            AppearanceFeature.BUILD: [
                "Slim", "Athletic", "Muscular", "Stocky", "Large",
                "Petite", "Average", "Powerful", "Graceful"
            ],
            AppearanceFeature.SCARS: [
                "None", "Facial Scar", "Battle Wounds", "Ritual Scars",
                "Mystical Marks", "Cybernetic Implants"
            ],
            AppearanceFeature.TATTOOS: [
                "None", "Tribal", "Celestial", "Mechanical", "Arcane",
                "Ghoul Symbols", "Lattice Patterns", "Chronos Marks"
            ],
            AppearanceFeature.ACCESSORIES: [
                "None", "Glasses", "Eyepatch", "Jewelry", "Piercings",
                "Mask", "Headpiece", "Tech Visor", "Mystical Amulet"
            ]
        }
    
    def _initialize_personality_traits(self) -> Dict[PersonalityTrait, Dict]:
        """Initialize personality traits with gameplay effects"""
        return {
            PersonalityTrait.BRAVE: {
                "description": "Gains bonus damage when HP is low",
                "effect": "low_hp_boost",
                "combat_modifier": 1.2
            },
            PersonalityTrait.CUNNING: {
                "description": "Better prices at merchants, improved critical chance",
                "effect": "merchant_discount",
                "discount_rate": 0.9,
                "crit_bonus": 0.05
            },
            PersonalityTrait.KIND: {
                "description": "Healing abilities are more effective, party members receive buffs",
                "effect": "enhanced_healing",
                "healing_boost": 1.25
            },
            PersonalityTrait.ARROGANT: {
                "description": "Deal more damage but take more damage",
                "effect": "high_risk_high_reward",
                "damage_boost": 1.3,
                "defense_penalty": 0.8
            },
            PersonalityTrait.MYSTERIOUS: {
                "description": "Chance to confuse enemies, hidden dialogue options",
                "effect": "confusion_chance",
                "confusion_rate": 0.15
            },
            PersonalityTrait.HUMOROUS: {
                "description": "Enemies may skip turns laughing, improved morale",
                "effect": "comic_relief",
                "skip_chance": 0.1
            },
            PersonalityTrait.SERIOUS: {
                "description": "Consistent performance, resistance to status effects",
                "effect": "steadfast",
                "status_resistance": 0.3
            },
            PersonalityTrait.RECKLESS: {
                "description": "Higher critical chance but lower accuracy",
                "effect": "wild_fighting",
                "crit_chance": 0.2,
                "accuracy_penalty": 0.8
            }
        }
    
    def _initialize_voice_options(self) -> List[Dict]:
        """Initialize voice options with different characteristics"""
        return [
            {"name": "Heroic", "pitch": "medium", "tempo": "moderate", "style": "confident"},
            {"name": "Mysterious", "pitch": "low", "tempo": "slow", "style": "enigmatic"},
            {"name": "Energetic", "pitch": "high", "tempo": "fast", "style": "enthusiastic"},
            {"name": "Calm", "pitch": "medium-low", "tempo": "calm", "style": "serene"},
            {"name": "Intelligent", "pitch": "medium", "tempo": "precise", "style": "analytical"},
            {"name": "Menacing", "pitch": "very_low", "tempo": "deliberate", "style": "intimidating"}
        ]
    
    def create_custom_character(self, base_character, appearance: Dict,
                               personality: PersonalityTrait, voice_style: str) -> Dict:
        """Create a fully customized character"""
        customized_char = {
            "base": base_character,
            "appearance": self._validate_appearance(appearance),
            "personality": personality,
            "voice": self._get_voice_style(voice_style),
            "unique_abilities": self._generate_unique_abilities(personality),
            "custom_name": appearance.get("custom_name", base_character.name)
        }
        
        # Apply personality effects to stats
        self._apply_personality_effects(customized_char)
        
        return customized_char
    
    def _validate_appearance(self, appearance: Dict) -> Dict:
        """Validate and complete appearance choices"""
        validated = {}
        
        for feature, options in self.appearance_options.items():
            chosen = appearance.get(feature.value)
            if chosen and chosen in options:
                validated[feature.value] = chosen
            else:
                validated[feature.value] = random.choice(options)
        
        return validated
    
    def _get_voice_style(self, voice_name: str) -> Dict:
        """Get voice style by name"""
        for voice in self.voice_options:
            if voice["name"].lower() == voice_name.lower():
                return voice
        return self.voice_options[0]  # Default fallback
    
    def _generate_unique_abilities(self, personality: PersonalityTrait) -> List[Dict]:
        """Generate unique abilities based on personality"""
        personality_abilities = {
            PersonalityTrait.BRAVE: ["Courageous Strike", "Last Stand", "Fearless Assault"],
            PersonalityTrait.CUNNING: ["Clever Feint", "Tactical Advantage", "Devious Plot"],
            PersonalityTrait.KIND: ["Compassionate Heal", "Protective Aura", "Supportive Words"],
            PersonalityTrait.ARROGANT: ["Overwhelming Force", "Dismissive Gesture", "Superiority Complex"],
            PersonalityTrait.MYSTERIOUS: ["Enigmatic Presence", "Hidden Knowledge", "Mysterious Portent"],
            PersonalityTrait.HUMOROUS: ["Comic Relief", "Distracting Joke", "Morale Boost"],
            PersonalityTrait.SERIOUS: ["Focused Strike", "Disciplined Defense", "Steady Resolve"],
            PersonalityTrait.RECKLESS: ["Wild Swing", "Reckless Charge", "All-Out Attack"]
        }
        
        ability_names = personality_abilities.get(personality, ["Custom Technique"])
        return [{"name": name, "power": 20, "type": "personality"} for name in ability_names]
    
    def _apply_personality_effects(self, character: Dict):
        """Apply personality effects to character stats"""
        personality_data = self.personality_traits.get(character["personality"])
        if not personality_data:
            return
        
        effect = personality_data["effect"]
        base_stats = character["base"].stats
        
        if effect == "low_hp_boost":
            # This would be applied during combat
            pass
        elif effect == "merchant_discount":
            # This would be applied during shopping
            pass
        elif effect == "enhanced_healing":
            base_stats["magic"] = int(base_stats["magic"] * 1.1)
        elif effect == "high_risk_high_reward":
            base_stats["attack"] = int(base_stats["attack"] * 1.1)
            base_stats["defense"] = int(base_stats["defense"] * 0.9)
        elif effect == "confusion_chance":
            base_stats["luck"] += 5
        elif effect == "comic_relief":
            base_stats["speed"] += 2
        elif effect == "steadfast":
            base_stats["defense"] = int(base_stats["defense"] * 1.05)
        elif effect == "wild_fighting":
            base_stats["attack"] = int(base_stats["attack"] * 1.05)
            base_stats["speed"] -= 1
    
    def generate_random_character(self, base_character) -> Dict:
        """Generate a randomly customized character"""
        appearance = {}
        for feature in AppearanceFeature:
            appearance[feature.value] = random.choice(self.appearance_options[feature])
        
        personality = random.choice(list(PersonalityTrait))
        voice = random.choice(self.voice_options)["name"]
        
        return self.create_custom_character(base_character, appearance, personality, voice)
    
    def save_character_preset(self, character: Dict, preset_name: str) -> bool:
        """Save character customization as a preset"""
        # Implementation would save to file/database
        return True
    
    def load_character_preset(self, preset_name: str) -> Optional[Dict]:
        """Load character customization from preset"""
        # Implementation would load from file/database
        return None
