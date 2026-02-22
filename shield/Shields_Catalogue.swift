//
//  Shields_Catalogue.swift
//  Final Fantasy Lattice
//
//  Created by Dr. Nathaniel Fox on 2/19/26.
//

import Foundation
{
  "shields": [
    {
      "id": "aegis_buckler",
      "name": "Aegis Buckler",
      "type": "shield",
      "rarity": "common",
      "description": "A small, nimble shield perfect for parrying and quick defense.",
      "stats": {
        "defense": 8,
        "magic_defense": 5,
        "evasion": 10,
        "weight": 3
      },
      "special_effect": "15% chance to completely negate physical damage",
      "appearance": "Polished steel round shield with celestial engravings",
      "price": 250,
      "required_level": 1,
      "sprite": "shield_aegis_buckler"
    },
    {
      "id": "tower_shield_valor",
      "name": "Tower Shield of Valor",
      "type": "shield",
      "rarity": "rare",
      "description": "A massive shield that can protect an entire party. Bears the scars of countless battles.",
      "stats": {
        "defense": 25,
        "magic_defense": 12,
        "evasion": -5,
        "weight": 18
      },
      "special_effect": "25% chance to protect adjacent allies from area attacks",
      "appearance": "Enormous rectangular shield with a lion crest",
      "price": 800,
      "required_level": 15,
      "sprite": "shield_tower_valor"
    },
    {
      "id": "lattice_barrier",
      "name": "Lattice Barrier",
      "type": "shield",
      "rarity": "epic",
      "description": "Forged from solidified data streams. Shimmers with protective algorithms.",
      "stats": {
        "defense": 15,
        "magic_defense": 22,
        "evasion": 8,
        "magic": 5
      },
      "special_effect": "Absorbs 30% of magic damage as MP",
      "appearance": "Translucent hexagonal shield with glowing blue circuits",
      "price": 1500,
      "required_level": 25,
      "sprite": "shield_lattice_barrier"
    },
    {
      "id": "dragonscale_guard",
      "name": "Dragonscale Guard",
      "type": "shield",
      "rarity": "legendary",
      "description": "Crafted from the scales of an ancient fire dragon. Warm to the touch.",
      "stats": {
        "defense": 30,
        "magic_defense": 18,
        "fire_resistance": 50,
        "weight": 12
      },
      "special_effect": "Reflects fire damage back at attackers",
      "appearance": "Scarlet scales arranged in an overlapping pattern",
      "price": 3000,
      "required_level": 35,
      "sprite": "shield_dragonscale"
    },
    {
      "id": "mirror_shield_truth",
      "name": "Mirror Shield of Truth",
      "type": "shield",
      "rarity": "epic",
      "description": "A perfect reflective surface that shows no lies, only truth.",
      "stats": {
        "defense": 12,
        "magic_defense": 20,
        "evasion": 15
      },
      "special_effect": "100% chance to reflect status effect spells",
      "appearance": "Polished silver that shows perfect reflections",
      "price": 2200,
      "required_level": 28,
      "sprite": "shield_mirror_truth"
    },
    {
      "id": "ancestral_ward",
      "name": "Ancestral Ward",
      "type": "shield",
      "rarity": "rare",
      "description": "An ancient shield blessed by generations of protectors.",
      "stats": {
        "defense": 18,
        "magic_defense": 16,
        "hp_max": 50,
        "spirit": 10
      },
      "special_effect": "Automatically casts Protect on wielder at battle start",
      "appearance": "Weathered bronze with ancestral runes",
      "price": 1200,
      "required_level": 20,
      "sprite": "shield_ancestral_ward"
    },
    {
      "id": "crystal_barrier",
      "name": "Crystal Barrier",
      "type": "shield",
      "rarity": "epic",
      "description": "A shield grown from a single perfect crystal. Nearly indestructible.",
      "stats": {
        "defense": 28,
        "magic_defense": 25,
        "weight": 8,
        "light_resistance": 40
      },
      "special_effect": "30% chance to shatter when breaking, dealing damage to all enemies",
      "appearance": "Prismatic crystal that catches the light beautifully",
      "price": 2800,
      "required_level": 32,
      "sprite": "shield_crystal_barrier"
    }
  ]
}
